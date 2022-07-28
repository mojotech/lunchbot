// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html'
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from 'phoenix'
import {LiveSocket} from 'phoenix_live_view'
import topbar from "../vendor/topbar"

// Define hooks
const Hooks = {}
Hooks.ScrollLock = {
  mounted() {
    this.lockScroll()
  },
  destroyed() {
    this.unlockScroll()
  },
  lockScroll() {
    // From https://github.com/excid3/tailwindcss-stimulus-components/blob/master/src/modal.js
    // Add right padding to the body so the page doesn't shift when we disable scrolling
    const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth
    document.body.style.paddingRight = `${scrollbarWidth}px`
    // Save the scroll position
    this.scrollPosition = window.pageYOffset || document.body.scrollTop
    // Add classes to body to fix its position
    document.body.classList.add('fix-position')
    // Add negative top position in order for body to stay in place
    document.body.style.top = `-${this.scrollPosition}px`
  },
  unlockScroll() {
    // From https://github.com/excid3/tailwindcss-stimulus-components/blob/master/src/modal.js
    // Remove tweaks for scrollbar
    document.body.style.paddingRight = null
    // Remove classes from body to unfix position
    document.body.classList.remove('fix-position')
    // Restore the scroll position of the body before it got locked
    document.documentElement.scrollTop = this.scrollPosition
    // Remove the negative top inline style from body
    document.body.style.top = null
  }
}
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: {
    _csrf_token: csrfToken
  },
  hooks: Hooks
});

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

