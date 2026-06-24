# Git Workflow — Dodona Project

## Branch strategy

- `main` — always buildable, always pushed, always matches what's on the
  laptop
- `feature/dodona` — current working branch for the overhaul
- Future features branch from `main`, merge back when stable

We do not use GitFlow. We do not use trunk-based development. We use one
long-lived feature branch because this is a single-author project and the
"feature branch" is the feature.

## Commit conventions

### Commit message format

```
<scope>: <imperative summary under 60 chars>

<optional body, 72-char wrap, explaining why not what>

<optional footer with breaking changes, etc.>
```

### Scope values

| Scope | Meaning |
|---|---|
| `docs` | Documentation only |
| `palette` | Color scheme changes across the system |
| `dodona` | The Rust project itself |
| `dodona(data)` | Data source modules |
| `dodona(render)` | Rendering pipeline |
| `dodona(widgets)` | Widget implementations |
| `dodona(sound)` | Sound system |
| `dodona(ipc)` | IPC with external processes |
| `nvim` | Neovim config |
| `mango` | Mango WM config |
| `shell` | Bash / starship / tmux |
| `flake` | flake.nix / flake.lock |
| `system` | NixOS system modules |
| `home` | home-manager modules |

### Examples

```
docs: add project scope and architecture documents

palette: swap stylix base16 to dodona teal-orange

dodona: scaffold cargo project with empty module tree

dodona(data): implement cpu source with /proc/stat parser

dodona(render): wire tiny-skia pixmap commit to wayland buffer

flake: add dodona as flake output and system package
```

## What goes in a commit

- One logical change per commit
- If you can describe it in one sentence under 60 chars, it's one commit
- If you need "and also", it's two commits
- Tests and the code they test go in the same commit
- Docs and the code they describe go in the same commit (when applicable)
- Generated files: only `Cargo.lock` is committed. `target/`, generated
  WAVs, GeoIP DB are gitignored.

## What does NOT go in a commit

- Generated files (except `Cargo.lock`)
- Build artifacts (`target/`, `.dodona-cache/`)
- Secrets (MaxMind license key, SSH keys, API tokens)
- Personal config files (`.editorconfig` is fine, `.env` is not)
- Binary blobs (screenshots go in `screenshots/` only if referenced by
  README — otherwise they don't belong in the repo)

## Push discipline

- Push to `feature/dodona` freely
- Never force-push to `main`
- Force-push to `feature/dodona` is fine if no one else is pulling from
  it (no one is — single author)
- `main` only advances via `--no-ff` merge from a feature branch

## When to merge to main

When all of these are true:

1. `cargo build --release` succeeds
2. `cargo clippy -- -D warnings` passes
3. `nixos-rebuild build --flake .#oubliette-btw` succeeds
4. Dodona has run for at least 24h continuous without crash
5. All success criteria in `SCOPE.md` are met or explicitly waived
6. All docs in `docs/` are current (no references to TODO code)
7. Worklog is up to date

### Merge procedure

```
git checkout main
git merge --no-ff feature/dodona -m "merge: dodona v0.1 — initial stable release"
git push origin main
git tag v2.0-dodona
git push origin v2.0-dodona
```

After merge, `feature/dodona` is deleted locally and a new
`feature/dodona-v0.2` (or similar) is created for the next iteration.

## Tags

- `v1.x` — pre-dodona state (the dotfiles as they were before this
  branch). Already on `main`, do not touch.
- `v2.0-dodona` — first stable dodona release (palette + dodona v0.1)
- `v2.1`, `v2.2`, ... — incremental dodona releases
- Tags only on `main`, only on merge commits
- Tag message format: `vX.Y-dodona — <one-line summary>`

## Review before merge checklist

- [ ] `cargo build --release` succeeds
- [ ] `cargo clippy -- -D warnings` passes
- [ ] `cargo test` passes (when we have tests)
- [ ] `nixos-rebuild build --flake .#oubliette-btw` succeeds
- [ ] All docs in `docs/` are current (no references to TODO code)
- [ ] Worklog is up to date
- [ ] No secrets / API keys in the diff (`git log -p origin/main..HEAD |
      grep -iE 'key|token|secret'`)
- [ ] `.gitignore` covers all generated files
- [ ] No `console.log` / `dbg!` / `println!` left in committed code
      (use `tracing::debug!` instead)

## Worklog

Every work session appends to `/home/z/my-project/worklog.md` (sandbox)
OR a local `WORKLOG.md` (committed to repo) — TBD which one. The worklog
records:

- What was attempted
- What worked
- What didn't
- What's blocked
- What's next

The worklog is for future-you. Be honest in it. "Tried X, it sucked
because Y, doing Z instead" is a great worklog entry.

## Recovery procedures

### "I committed something I shouldn't have"

If it's the most recent commit and not pushed:
```
git reset HEAD~1
```

If it's pushed to `feature/dodona`:
```
git revert <commit-sha>
git push
```

If it's pushed to `main`: don't do this. If you did, contact no one (you're
alone on this repo), force-push:
```
git reset --hard <sha-before-the-bad-one>
git push --force-with-lease origin main
```
Then notify yourself in the worklog.

### "I lost work"

```
git reflog
git reset --hard HEAD@{N}
```

`git reflog` is your friend. Work is almost never truly lost.
