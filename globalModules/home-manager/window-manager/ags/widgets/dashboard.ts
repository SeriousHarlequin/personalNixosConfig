import { App, Astal, Gtk, Widget } from "astal/gtk3"
import { Variable, GLib, bind, execAsync } from "astal"
import { notifications, dismiss } from "./notifications"
import type { Notification } from "./notifications"

export const open = Variable(false)

const clock = Variable("").poll(1000, () =>
    GLib.DateTime.new_now_local().format("%H:%M")!
)

const date = Variable("").poll(60000, () =>
    GLib.DateTime.new_now_local().format("%A, %d %B")!
)

const cpu = Variable("0").poll(3000, [
    "awk",
    "/^cpu /{total=$2+$3+$4+$5+$6+$7+$8; idle=$5; printf \"%.0f\", 100*(total-idle)/total}",
    "/proc/stat",
])

const ram = Variable("0").poll(3000, [
    "awk",
    "/^MemTotal/{t=$2}/^MemAvailable/{a=$2}END{printf \"%.0f\", (t-a)*100/t}",
    "/proc/meminfo",
])

const uptime = Variable("").poll(10000, [
    "awk",
    "{s=$1; d=int(s/86400); h=int((s%86400)/3600); m=int((s%3600)/60); if(d>0) printf \"%dd %dh %dm\",d,h,m; else if(h>0) printf \"%dh %dm\",h,m; else printf \"%dm\",m}",
    "/proc/uptime",
])

const lastBuild = Variable("").poll(60000, [
    "sh", "-c", "date -d @$(stat -c %Y /nix/var/nix/profiles/system) '+%d %b, %H:%M'",
])

const dnd = Variable("false").poll(2000, ["swaync-client", "--get-dnd"])

function Separator() {
    return new Widget.Box({
        css: "min-height: 1px; background-color: alpha(@base04, 0.3); margin: 4px 0;",
    })
}

function StatRow(icon: string, value: Variable<string>) {
    return new Widget.Box({
        spacing: 8,
        children: [
            new Widget.Label({
                css: "font-family: 'JetBrainsMono Nerd Font'; font-size: 16px; color: @base0D; min-width: 28px;",
                label: icon,
            }),
            new Widget.LevelBar({
                hexpand: true,
                valign: Gtk.Align.CENTER,
                value: bind(value).as(v => parseInt(v) / 100),
            }),
            new Widget.Label({
                css: "min-width: 38px;",
                halign: Gtk.Align.END,
                label: bind(value).as(v => `${v}%`),
            }),
        ],
    })
}

function InfoRow(icon: string, label: string, value: Variable<string>) {
    return new Widget.Box({
        spacing: 8,
        children: [
            new Widget.Label({
                css: "font-family: 'JetBrainsMono Nerd Font'; font-size: 16px; color: @base0D; min-width: 28px;",
                label: icon,
            }),
            new Widget.Label({
                css: "font-size: 13px; color: alpha(@base06, 0.6);",
                label: label,
            }),
            new Widget.Label({
                hexpand: true,
                halign: Gtk.Align.END,
                label: bind(value),
            }),
        ],
    })
}

function NotifRow(notif: Notification): Gtk.Widget {
    const children: Gtk.Widget[] = [
        new Widget.Box({
            spacing: 8,
            children: [
                new Widget.Label({
                    hexpand: true,
                    halign: Gtk.Align.START,
                    wrap: true,
                    css: "font-weight: bold; color: @base06;",
                    label: notif.summary || notif.appName,
                }),
                new Widget.Button({
                    css: "color: alpha(@base06, 0.5); background: none; border: none; padding: 0; min-width: 24px;",
                    label: "×",
                    onClicked: () => dismiss(notif.id),
                }),
            ],
        }),
    ]

    if (notif.body) {
        children.push(new Widget.Label({
            halign: Gtk.Align.START,
            wrap: true,
            css: "font-size: 12px; color: alpha(@base06, 0.6);",
            label: notif.body,
        }))
    }

    if (notif.appName && notif.summary) {
        children.push(new Widget.Label({
            halign: Gtk.Align.START,
            css: "font-size: 11px; color: alpha(@base06, 0.4);",
            label: notif.appName,
        }))
    }

    return new Widget.Box({
        vertical: true,
        spacing: 4,
        css: "background-color: @base01; border-radius: 8px; padding: 8px 12px;",
        children,
    })
}

function NotifSection() {
    return new Widget.Box({
        vertical: true,
        vexpand: true,
        spacing: 8,
        children: [
            new Widget.Box({
                spacing: 8,
                children: [
                    new Widget.Label({
                        css: "font-family: 'JetBrainsMono Nerd Font'; font-size: 16px; color: @base0D; min-width: 28px;",
                        label: "",
                    }),
                    new Widget.Label({
                        hexpand: true,
                        halign: Gtk.Align.START,
                        label: bind(notifications).as(n =>
                            `${n.length} notification${n.length !== 1 ? "s" : ""}`
                        ),
                    }),
                    new Widget.Button({
                        css: "font-family: 'JetBrainsMono Nerd Font'; font-size: 16px; color: @base0D; background: none; border: none; padding: 0;",
                        label: bind(dnd).as(d => d.trim() === "true" ? "" : ""),
                        onClicked: () => execAsync(["swaync-client", "--toggle-dnd"]).catch(console.error),
                        tooltipText: "Toggle Do Not Disturb",
                    }),
                ],
            }),
            new Widget.Box({
                vertical: true,
                vexpand: true,
                spacing: 6,
                children: bind(notifications).as(notifs =>
                    notifs.length === 0
                        ? [new Widget.Label({
                            css: "color: alpha(@base06, 0.35); font-size: 13px; padding: 8px 0;",
                            label: "No notifications",
                        })]
                        : notifs.map(n => NotifRow(n))
                ),
            }),
        ],
    })
}

export default function Dashboard() {
    return new Widget.Window({
        application: App,
        name: "dashboard",
        layer: Astal.Layer.TOP,
        anchor: Astal.WindowAnchor.LEFT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM,
        exclusivity: Astal.Exclusivity.IGNORE,
        visible: true,
        clickThrough: bind(open).as(o => !o),
        css: "background-color: transparent;",
        child: new Widget.Revealer({
            revealChild: bind(open),
            transitionType: Gtk.RevealerTransitionType.SLIDE_RIGHT,
            transitionDuration: 250,
            child: new Widget.Box({
                vertical: true,
                spacing: 12,
                css: `
                    margin: 10px;
                    padding: 24px;
                    min-width: 300px;
                    background-color: @base00;
                    border-radius: 16px;
                    border: 1px solid alpha(@base04, 0.4);
                `,
                children: [
                    new Widget.Label({
                        halign: Gtk.Align.CENTER,
                        css: "font-size: 64px; font-weight: bold; color: @base06;",
                        label: bind(clock),
                    }),
                    new Widget.Label({
                        halign: Gtk.Align.CENTER,
                        css: "font-size: 13px; color: alpha(@base06, 0.6);",
                        label: bind(date),
                    }),
                    Separator(),
                    StatRow("", cpu),
                    StatRow("", ram),
                    Separator(),
                    InfoRow("", "Uptime", uptime),
                    InfoRow("", "Last Build", lastBuild),
                    Separator(),
                    NotifSection(),
                ],
            }),
        }),
    })
}
