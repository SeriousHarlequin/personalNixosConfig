import GLib from "gi://GLib"
import Gio from "gi://Gio"
import { Variable, execAsync } from "astal"

export interface Notification {
    id: number
    appName: string
    summary: string
    body: string
}

export const notifications = Variable<Notification[]>([])

const pendingNotify = new Map<number, { appName: string; summary: string; body: string }>()

export function dismiss(id: number) {
    execAsync([
        "gdbus", "call", "--session",
        "--dest", "org.freedesktop.Notifications",
        "--object-path", "/org/freedesktop/Notifications",
        "--method", "org.freedesktop.Notifications.CloseNotification",
        String(id),
    ]).catch(console.error)
    notifications.set(notifications.get().filter(n => n.id !== id))
}

type ParseState =
    | { tag: "idle" }
    | { tag: "notify_call"; serial: number; strings: string[] }
    | { tag: "notify_return"; callSerial: number }
    | { tag: "notif_closed" }

export function setup() {
    let proc: Gio.Subprocess
    try {
        proc = Gio.Subprocess.new(
            ["dbus-monitor", "--session", "--monitor",
             "interface='org.freedesktop.Notifications'",
             "type='method_return'"],
            Gio.SubprocessFlags.STDOUT_PIPE,
        )
    } catch (e) {
        console.error("notifications: failed to start dbus-monitor:", e)
        return
    }

    const pipe = proc.get_stdout_pipe()
    if (!pipe) return

    const stream = new Gio.DataInputStream({ base_stream: pipe })

    let state: ParseState = { tag: "idle" }

    function readLine() {
        stream.read_line_async(GLib.PRIORITY_DEFAULT_IDLE, null, (src, res) => {
            try {
                const [bytes] = src!.read_line_finish(res)
                if (!bytes) return

                const line = new TextDecoder().decode(bytes)
                const isHeader = !line.match(/^\s/)

                if (isHeader) {
                    // Notify method call (not NotificationClosed)
                    if (line.startsWith("method call") &&
                        line.includes("member=Notify") &&
                        !line.includes("member=NotificationClosed")) {
                        const m = line.match(/serial=(\d+)/)
                        state = m
                            ? { tag: "notify_call", serial: parseInt(m[1]), strings: [] }
                            : { tag: "idle" }
                    } else if (line.startsWith("method return")) {
                        const m = line.match(/reply_serial=(\d+)/)
                        const callSerial = m ? parseInt(m[1]) : -1
                        state = pendingNotify.has(callSerial)
                            ? { tag: "notify_return", callSerial }
                            : { tag: "idle" }
                    } else if (line.includes("member=NotificationClosed")) {
                        state = { tag: "notif_closed" }
                    } else {
                        state = { tag: "idle" }
                    }
                } else if (state.tag !== "idle") {
                    const trimmed = line.trim()

                    if (state.tag === "notify_call") {
                        // Notify signature: s app_name, u replaces_id, s app_icon, s summary, s body, ...
                        // We collect strings in order; uint32 replaces_id is skipped
                        const sm = trimmed.match(/^string "(.*)"$/)
                        if (sm) {
                            state.strings.push(sm[1])
                            if (state.strings.length === 4) {
                                // strings[0]=appName, [1]=icon, [2]=summary, [3]=body
                                pendingNotify.set(state.serial, {
                                    appName: state.strings[0],
                                    summary: state.strings[2],
                                    body: state.strings[3],
                                })
                                state = { tag: "idle" }
                            }
                        }
                    } else if (state.tag === "notify_return") {
                        const um = trimmed.match(/^uint32 (\d+)$/)
                        if (um) {
                            const id = parseInt(um[1])
                            const p = pendingNotify.get(state.callSerial)
                            if (p) {
                                pendingNotify.delete(state.callSerial)
                                notifications.set([{ id, ...p }, ...notifications.get()])
                            }
                            state = { tag: "idle" }
                        }
                    } else if (state.tag === "notif_closed") {
                        const um = trimmed.match(/^uint32 (\d+)$/)
                        if (um) {
                            const id = parseInt(um[1])
                            notifications.set(notifications.get().filter(n => n.id !== id))
                            state = { tag: "idle" }
                        }
                    }
                }

                readLine()
            } catch (e) {
                console.error("notifications: stream error:", e)
            }
        })
    }

    readLine()
}
