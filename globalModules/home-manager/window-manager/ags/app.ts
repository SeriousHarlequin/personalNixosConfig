import { App } from "astal/gtk3"
import { css } from "./colors"
import Dashboard, { open as dashboardOpen } from "./widgets/dashboard"
import Sound, { open as soundOpen } from "./widgets/sound"
import { setup as setupNotifications } from "./widgets/notifications"

App.start({
    css,
    requestHandler(request, res) {
        if (request === "toggle-dashboard") dashboardOpen.set(!dashboardOpen.get())
        if (request === "toggle-sound") soundOpen.set(!soundOpen.get())
        res("ok")
    },
    main() {
        setupNotifications()
        Dashboard()
        Sound()
    },
})
