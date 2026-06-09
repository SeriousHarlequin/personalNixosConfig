import { App, Astal, Gtk, Widget } from "astal/gtk3"
import { Variable, bind, execAsync } from "astal"

const volumeRaw = Variable("Volume: 0.50").poll(500, [
    "wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@",
])

function setVolume(delta: number) {
    execAsync([
        "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@",
        `${Math.abs(delta)}%${delta > 0 ? "+" : "-"}`,
    ]).catch(console.error)
}

function toggleMute() {
    execAsync(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
        .catch(console.error)
}

export default function Sound() {
    return new Widget.Window({
        application: App,
        name: "sound",
        layer: Astal.Layer.TOP,
        anchor: Astal.WindowAnchor.BOTTOM,
        exclusivity: Astal.Exclusivity.IGNORE,
        visible: false,
        css: "background-color: transparent;",
        child: new Widget.Box({
            vertical: true,
            spacing: 8,
            css: `
                margin-bottom: 20px;
                padding: 20px 24px;
                min-width: 260px;
                background-color: @base00;
                border-radius: 16px;
                border: 1px solid alpha(@base04, 0.4);
            `,
            children: [
                new Widget.Box({
                    spacing: 8,
                    children: [
                        new Widget.Button({
                            css: "font-family: 'JetBrainsMono Nerd Font'; font-size: 20px; color: @base0D; background: none; border: none; padding: 0; min-width: 28px;",
                            label: bind(volumeRaw).as(s =>
                                s.includes("[MUTED]") ? "" : ""
                            ),
                            onClicked: toggleMute,
                        }),
                        new Widget.LevelBar({
                            hexpand: true,
                            valign: Gtk.Align.CENTER,
                            value: bind(volumeRaw).as(s => {
                                const m = s.match(/Volume:\s*([\d.]+)/)
                                return m ? parseFloat(m[1]) : 0
                            }),
                        }),
                        new Widget.Label({
                            css: "min-width: 38px;",
                            halign: Gtk.Align.END,
                            label: bind(volumeRaw).as(s => {
                                const m = s.match(/Volume:\s*([\d.]+)/)
                                return m ? `${Math.round(parseFloat(m[1]) * 100)}%` : "-"
                            }),
                        }),
                    ],
                }),
                new Widget.Box({
                    spacing: 8,
                    homogeneous: true,
                    children: [
                        new Widget.Button({
                            hexpand: true,
                            css: "color: @base06; background-color: @base01; border: none; border-radius: 8px; padding: 6px 0;",
                            label: "-5%",
                            onClicked: () => setVolume(-5),
                        }),
                        new Widget.Button({
                            hexpand: true,
                            css: "color: @base06; background-color: @base01; border: none; border-radius: 8px; padding: 6px 0;",
                            label: "+5%",
                            onClicked: () => setVolume(5),
                        }),
                    ],
                }),
            ],
        }),
    })
}
