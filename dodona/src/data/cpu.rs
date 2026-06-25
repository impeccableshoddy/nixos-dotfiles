use std::time::Duration;

fn extract_kib(content: &str, key: &str) -> Option<u64> {
    for line in content.lines() {
        if line.starts_with(key) {
            let parts: Vec<&str> = line.split_whitespace().collect();
            if parts.len() >= 2 { return parts[1].parse().ok(); }
        }
    }
    None
}

async fn read_proc_meminfo() -> Option<String> {
    tokio::fs::read_to_string("/proc/meminfo").await.ok()
}

pub fn spawn(tx: calloop::channel::SyncSender<crate::core::event_loop::UiEvent>) {
    tokio::spawn(async move {
        let mut interval = tokio::time::interval(Duration::from_secs(1));
        loop {
            interval.tick().await;
            let content = match read_proc_meminfo().await { Some(c) => c, None => continue };
            let mem_total = extract_kib(&content, "MemTotal:").unwrap_or(1) as f32;
            let mem_avail = extract_kib(&content, "MemAvailable:").unwrap_or(0) as f32;
            let swap_total = extract_kib(&content, "SwapTotal:").unwrap_or(0) as f32;
            let swap_free = extract_kib(&content, "SwapFree:").unwrap_or(0) as f32;
            let ram_pct = if mem_total > 0.0 { ((mem_total - mem_avail) / mem_total) * 100.0 } else { 0.0 };
            let swap_pct = if swap_total > 0.0 { ((swap_total - swap_free) / swap_total) * 100.0 } else { 0.0 };
            let snap = crate::core::event_loop::MemSnapshot { ram_pct, swap_pct };
            if tx.send(crate::core::event_loop::UiEvent::Mem(snap)).is_err() { break; }
        }
    });
}
