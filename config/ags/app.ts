import app from "ags/gtk4/app"
import Bar from "./widget/Bar"

app.start({
  instanceName: "my-shell",
  requestHandler(request, res) {
    res("OK")
  },
  main() {
    app.get_monitors().map(Bar)
  },
})
