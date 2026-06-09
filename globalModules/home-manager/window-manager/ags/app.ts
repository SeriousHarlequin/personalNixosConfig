import { App } from "astal/gtk3"
import { css } from "./colors"
import Dashboard from "./widgets/dashboard"
import Sound from "./widgets/sound"

App.start({
    css,
    main() {
        Dashboard()
        Sound()
    },
})
