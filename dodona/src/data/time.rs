use std::time::{Duration, SystemTime, UNIX_EPOCH};

fn format_time(dur: Duration) -> String {
    let total_secs = dur.as_secs();
    let ms = dur.subsec_millis();
    let hours = (total_secs / 3600) % 24;
    let mins = (total_secs / 60) % 60;
    let secs = total_secs % 60;
    format!("{:02}:{:02}:{:02}.{:03}", hours, mins, secs, ms)
}

fn format_date(dur: Duration) -> String {
    let total_days = dur.as_secs() / 86400;
    let year = 1970 + (total_days / 365) as u32;
    let month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    let day_of_year = (total_days % 365) as u32;
    let month_idx = ((day_of_year * 12) / 365).min(11);
    let day = day_of_year.saturating_sub(month_idx * 30 + month_idx / 2).max(1);
    format!("{:02}-{}-{}", day, month_names[month_idx as usize], year)
}

pub fn snapshot() -> crate::core::event_loop::ClockSnapshot {
    let now = SystemTime::now();
    let dur = now.duration_since(UNIX_EPOCH).unwrap_or_default();
    crate::core::event_loop::ClockSnapshot {
        time: format_time(dur),
        date: format_date(dur),
        unix_ms: dur.as_millis(),
    }
}

pub fn spawn(tx: calloop::channel::SyncSender<crate::core::event_loop::UiEvent>) {
    tokio::spawn(async move {
        let mut interval = tokio::time::interval(Duration::from_millis(100));
        loop {
            interval.tick().await;
            let snap = snapshot();
            if tx.send(crate::core::event_loop::UiEvent::Clock(snap)).is_err() {
                break;
            }
        }
    });
}
