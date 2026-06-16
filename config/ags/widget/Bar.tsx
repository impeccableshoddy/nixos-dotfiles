import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"

const time = createPoll("", 1000, "date '+%a %H:%M'")

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      cssClasses={["Bar"]}
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <label label="tags here" />
        </box>
        <box>
          <label label={time} />
        </box>
        <box hexpand halign={Gtk.Align.END}>
          <label label="modules here" />
        </box>
      </centerbox>
    </window>
  )
}
