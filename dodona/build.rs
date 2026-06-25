//! Build script: provision embedded fonts for include_bytes!.

use std::env;
use std::fs;
use std::path::{Path, PathBuf};

const DEPARTURE_MONO_URL: &str =
    "https://github.com/arrowtype/departure-mono/releases/download/v1.502/DepartureMono-Regular.otf";
const COMMIT_MONO_URL: &str =
    "https://github.com/Commit-Mono/Commit-Mono/releases/download/v1.143/CommitMono-Regular.otf";

fn main() {
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());

    let departure_path = out_dir.join("DepartureMono-Regular.otf");
    ensure_font(
        "DepartureMono-Regular",
        &departure_path,
        DEPARTURE_MONO_URL,
        &[
            env::var("DEPARTURE_MONO_PATH").ok(),
            env::var("DODONA_NIX_FONTS_DIR").ok().map(|d| d.clone()),
        ],
        |dir| find_font_in_dir(dir, "DepartureMono", "Regular"),
    );

    let commit_path = out_dir.join("CommitMono-Regular.otf");
    ensure_font(
        "CommitMono-Regular",
        &commit_path,
        COMMIT_MONO_URL,
        &[
            env::var("COMMIT_MONO_PATH").ok(),
            env::var("DODONA_NIX_FONTS_DIR").ok().map(|d| d.clone()),
        ],
        |dir| find_font_in_dir(dir, "CommitMono", "Regular"),
    );

    println!("cargo:rerun-if-changed=assets/fonts/");
}

fn ensure_font<F>(
    name: &str,
    target: &Path,
    url: &str,
    search_dirs: &[Option<String>],
    find_in_dir: F,
) where
    F: Fn(&Path) -> Option<PathBuf>,
{
    if target.exists() {
        return;
    }

    for dir_opt in search_dirs {
        if let Some(dir) = dir_opt {
            let path = Path::new(dir);
            if path.is_file() && path.exists() {
                fs::copy(path, target).expect(&format!("failed to copy {} font", name));
                println!("cargo:warning=font {} copied from {}", name, path.display());
                return;
            }
            if path.is_dir() {
                if let Some(found) = find_in_dir(path) {
                    fs::copy(&found, target).expect(&format!("failed to copy {} font", name));
                    println!("cargo:warning=font {} found at {}", name, found.display());
                    return;
                }
            }
        }
    }

    let local = Path::new("assets/fonts").join(target.file_name().unwrap());
    if local.exists() {
        fs::copy(&local, target).expect(&format!("failed to copy {} font", name));
        return;
    }

    println!("cargo:warning=downloading font {} from {}", name, url);
    let status = std::process::Command::new("curl")
        .args(["-fSL", "-o"])
        .arg(target)
        .arg(url)
        .status()
        .expect("failed to run curl - is it installed?");

    if !status.success() {
        panic!(
            "failed to download font {} from {} - curl exited with {:?}",
            name, url, status.code()
        );
    }

    let data = fs::read(target).unwrap_or_default();
    if data.len() < 4 {
        panic!("downloaded font {} is too small ({} bytes)", name, data.len());
    }
    let magic = &data[0..4];
    if magic != b"OTTO" && magic != b"\x00\x01\x00\x00" && magic != b"true" && magic != b"OTCF" {
        panic!(
            "downloaded font {} has invalid magic bytes: {:02X?}",
            name, magic
        );
    }
}

fn find_font_in_dir(dir: &Path, base_name: &str, style: &str) -> Option<PathBuf> {
    if !dir.is_dir() {
        return None;
    }
    for entry in fs::read_dir(dir).ok()? {
        let entry = entry.ok()?;
        let path = entry.path();
        if path.is_dir() {
            if let Some(found) = find_font_in_dir(&path, base_name, style) {
                return Some(found);
            }
        } else {
            let fname = path.file_name()?.to_string_lossy().to_string();
            let has_base = fname.to_lowercase().contains(&base_name.to_lowercase());
            let has_style = fname.contains(style);
            let is_font = fname.ends_with(".otf") || fname.ends_with(".ttf");
            if has_base && has_style && is_font {
                return Some(path);
            }
        }
    }
    None
}
