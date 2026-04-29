---
name: chezmoi-management
description: 'katanabe''s personal chezmoi dotfiles workflow on macOS. Covers the source layout, the diff/apply/re-add cycle, the .tmpl + re-add footgun, APM coexistence, brew autoupdate, the background "auto: sync dotfiles" commit job, and Claude native install PATH handling. Consult this skill whenever any chezmoi command is being considered, or when touching ~/.config/, ~/.zshrc, ~/.apm/, or ~/.claude/skills/. Also use when initializing a fresh macOS machine. Don''t guess chezmoi behavior — patterns here have specific reasons rooted in this user''s setup.'
---

# chezmoi management (katanabe)

Personal operations memo for the dotfiles repo at `git@github.com:katanabe/dotfiles.git`. The chezmoi documentation is sufficient for general usage; this skill captures **what is specific to this user's environment** so future sessions don't relitigate decisions.

## Environment

| | |
|---|---|
| Source path | `~/.local/share/chezmoi/` |
| Remote | `git@github.com:katanabe/dotfiles.git` (SSH) |
| Branch | `main` |
| Auto-sync | Yes — a background job commits drift as `auto: sync dotfiles YYYY-MM-DD` (author: katanabe). Verify `git status`/`log` before staging changes |
| Pre-commit | Not set up |
| OS | macOS (Darwin), Apple Silicon |
| Terminal | Ghostty (config at `dot_config/ghostty/config`) |

## Layout

```
~/.local/share/chezmoi/
├── .chezmoiignore                          # APM-managed paths excluded from apply
├── dot_apm/
│   ├── apm.yml                             # adopted skill manifest (chezmoi-managed)
│   └── apm.lock.yaml                       # commit-pinned for reproducibility
├── dot_claude/
│   └── skills/
│       └── chezmoi-management/             # this skill (chezmoi-managed)
├── dot_config/
│   ├── Brewfile
│   ├── ghostty/config
│   ├── mise/, sheldon/, starship.toml, zellij/
├── dot_gitconfig
├── dot_local/
├── dot_zshrc.tmpl                          # zshrc as a Go template
├── private_Library/                        # macOS-specific Library dirs (0600)
├── run_once_after_install-packages.sh      # one-shot setup script
├── README.md
└── .git/
```

## Daily flow

### See what's different

```bash
chezmoi diff           # full diff source vs dest
chezmoi diff <path>    # narrow to one file
chezmoi status         # MM/M /??/DA per file
```

**`chezmoi diff` direction**: `-` rows are dest content (will be removed on apply), `+` rows are source/target content (will be added). Apply moves dest → target.

**`chezmoi status` codes** (`[source][dest]`):

| Code | Meaning | Resolution |
|---|---|---|
| `M ` | source changed | `chezmoi apply` to push to dest |
| ` M` | dest changed (drift) | `chezmoi re-add` to capture into source |
| `MM` | both changed | inspect; choose `apply` or `re-add` per side |
| `R ` | run script will execute on next apply | usually fine — the scripts here are idempotent |
| `DA` | source says delete, dest still present | usually leftover from a removed managed path; investigate |

### Edit dest → import to source

```bash
chezmoi add <path>           # first-time tracking
chezmoi re-add <path>        # update an already-tracked file
chezmoi re-add               # update everything that drifted
```

⚠️ **Critical: never `re-add` a `.tmpl`-managed file.** The expanded dest content overwrites the `.tmpl` source, destroying any `{{ ... }}` constructs. Check first:

```bash
chezmoi source-path <path>
# → ends in `.tmpl` → DO NOT re-add. Edit source directly with chezmoi edit or your editor.
# → no .tmpl     → re-add is safe.
```

`dot_zshrc.tmpl` is currently template-free, but the moment a `{{ if eq .chezmoi.os ... }}` is added the footgun is armed.

### Edit source → push to dest

```bash
chezmoi apply                       # full
chezmoi apply <path>                # one file
chezmoi apply --force <path>        # skip "modified since chezmoi last wrote" prompt (non-TTY)
```

The apply prompt for "modified since chezmoi last wrote" is what `--force` bypasses. Useful from a script context where there's no TTY.

### Edit via chezmoi (auto-resolves .tmpl)

```bash
chezmoi edit <dest-path>            # opens the source-side file, with .tmpl chosen automatically
chezmoi edit -a <dest-path>         # also apply after closing the editor
chezmoi cd                          # cd to the source dir
```

Prefer `chezmoi edit` over `chezmoi re-add` when uncertain — it never destroys template syntax.

## APM coexistence

APM (Microsoft Agent Package Manager) deploys agent skills to `~/.claude/skills/<name>/`. The boundary with chezmoi:

| path | manager | rationale |
|---|---|---|
| `~/.apm/apm.yml` | chezmoi (`dot_apm/apm.yml`) | declares which skills are adopted; small declarative file |
| `~/.apm/apm.lock.yaml` | chezmoi (`dot_apm/apm.lock.yaml`) | pins commit hashes for reproducibility |
| `~/.apm/apm_modules/` | APM (cache) | listed in `.chezmoiignore` |
| `~/.apm/config.json` | per-machine, untracked | tiny client preference |
| `~/.claude/skills/<apm-managed>/` | APM | covered by the wildcard `.claude/skills/*` rule in `.chezmoiignore` (no per-skill entry needed) |
| `~/.claude/skills/<chezmoi-managed>/` (e.g. this skill) | chezmoi | re-included via `!.claude/skills/<name>` + `!.claude/skills/<name>/**` in `.chezmoiignore` |

The current `.chezmoiignore` ignores everything under `.claude/skills/` and re-includes only chezmoi-managed skills explicitly. So adopting a new APM skill requires no `.chezmoiignore` edit; adding a new *chezmoi-managed* skill requires adding two negation lines for it.

### Add a skill via APM (with chezmoi sync)

A helper function `apm-add` is defined in `dot_zshrc.tmpl`. It encapsulates the full flow:

```bash
apm-add <owner>/<repo>/skills/<name>            # latest main
apm-add <owner>/<repo>/skills/<name>#<tag-or-sha>   # pinned
```

What it does internally:

1. `apm install -g <pkg>` — deploys the skill, updates `~/.apm/apm.yml` + `~/.apm/apm.lock.yaml`
2. `chezmoi re-add ~/.apm/apm.yml ~/.apm/apm.lock.yaml` — captures into source
3. Reminds the user to commit/push the dotfiles repo

No `.chezmoiignore` edit is needed: the wildcard `.claude/skills/*` rule already covers any APM-deployed path.

To remove a skill: `apm uninstall -g <owner>/<repo>` then `chezmoi re-add` the manifests. The function does not bundle the removal flow because it's rarer.

### Pinning recommendation

`apm.lock.yaml` always pins to a resolved commit, but `apm.yml` may carry an unpinned reference like `mizchi/skills/foo`. APM warns ("dependency has no pinned version — pin with #tag or #sha to prevent drift"). For long-term skills it's worth pinning manually in `apm.yml`:

| Pin form | Example | When to use |
|---|---|---|
| **Tag** | `mizchi/skills/foo#v1.0.0` | Preferred. Use when the upstream publishes semver tags. |
| **Commit SHA** | `mizchi/skills/foo#a0ebf680f62836f64d7e9b741ee212f55b108f88` | Use when the upstream has no tags, or you want exact reproducibility regardless of tag re-pointing. Full SHA preferred over short. |
| **Branch** | `mizchi/skills/foo#main` | Equivalent to no-pin (tracks head). Avoid for stable adoption. |

Pin via `apm install -g <pkg>#<ref>` directly, or edit `apm.yml` and re-run `apm install -g --frozen-lockfile`.

## New machine bootstrap

The full sequence on a fresh macOS box:

```bash
# 1. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. chezmoi + apply (clones the repo and runs run_once scripts)
brew install chezmoi
chezmoi init git@github.com:katanabe/dotfiles.git --apply
```

`chezmoi apply` on first run executes `run_once_after_install-packages.sh`, which:

1. `brew bundle --file=~/.config/Brewfile` — installs everything declared in Brewfile (incl. `microsoft/apm/apm`)
2. `sheldon lock` — installs zsh plugins
3. `brew autoupdate start 86400` — daily catalog update only (no auto-upgrade; intentional, to avoid surprise version bumps)
4. `apm install -g --frozen-lockfile` — restores all APM-managed skills at the locked commits

After the script finishes, the machine is fully reproduced.

The run_once script is idempotent on subsequent applies (every step has a "skip if already done" guard). chezmoi only re-runs it when its content hash changes.

## Auto-sync background job

A scheduled job (likely launchd) commits any drift in the chezmoi source repo with messages like:

```
auto: sync dotfiles 2026-04-29
```

Authored as `katanabe <nabeon+github@gmail.com>`. Implications:

- Pending source edits may be auto-committed before being staged manually. Run `git status` and `git log` immediately before committing to avoid empty/partial commits and surprising rebases.
- When bundling related changes into one logical commit, do all edits and commit promptly, otherwise the auto-sync may split them.
- `auto: sync dotfiles ...` commits in the log are not from Claude or the user — they're the sync job catching drift. Don't try to amend or reorder them retroactively unless deliberately reshaping history.

The source of the job is not yet documented in this repo. Treat it as "always running" until disabled.

### Race-safe edit cycle

Because auto-sync can commit and push at any time, every edit-to-push sequence should slot status/log checks at three specific points. Use this as the canonical workflow whenever you're about to modify any chezmoi-managed file:

```bash
# === Checkpoint 1: BEFORE editing =================================
chezmoi cd
git status                       # Expect: clean. If dirty, auto-sync hasn't run yet — inspect before editing on top.
git log --oneline -3             # Note the latest auto: sync commit so you can spot new ones later.
cd -

# === Edit ==========================================================
chezmoi edit ~/.<file>           # or direct source edit; or `chezmoi add` for new files
chezmoi diff <path>              # confirm intended change shape
chezmoi apply [--force] <path>   # only if dest needs to be brought in line

# === Checkpoint 2: BEFORE committing ==============================
chezmoi cd
git status                       # Expect: ONLY your changes. If you see unrelated modifications, auto-sync is mid-flight — wait or pull-rebase first.
git log --oneline -3             # Compare against checkpoint 1. New auto: sync commits appearing here mean the remote has advanced.

# === Pull-rebase, then commit =====================================
git pull --rebase origin main    # Integrate any auto-sync commits that landed remotely while you were editing. Required before pushing.
git add <specific paths>         # Never `git add -A` — auto-sync may have unrelated work in progress.
git commit -m "..."

# === Checkpoint 3: BEFORE pushing =================================
git log --oneline -3             # Confirm your commit sits on top, no surprise interleaved commits.
git push origin main
cd -
```

Why each checkpoint matters:

| Checkpoint | What it catches | What to do if check fails |
|---|---|---|
| Before edit | auto-sync has uncommitted local drift you'd accidentally bundle into your change | Inspect the drift; either commit it as a separate `auto:`-style commit, or back off and let auto-sync handle it, then start over |
| Before commit | auto-sync committed something locally between your edit and now | Verify it's only auto-sync's work (not your own changes captured prematurely) — if so, harmless; proceed |
| Before push | the remote advanced (auto-sync from another machine, or local auto-sync pushed) | `git pull --rebase` if you skipped that step, then re-check |

If `git pull --rebase` produces a conflict in `dot_apm/apm.lock.yaml` (likely scenario: another machine added a skill at the same time), resolve by re-running `apm install -g --frozen-lockfile` after accepting both sets of dependencies into `apm.yml`, then regenerating the lockfile with a fresh `apm install -g`.

### Entry points

The "Edit" block in the middle of the cycle varies by what you're actually doing. Plug the matching block into the canonical sequence above:

| Entry point | Middle block | Notes |
|---|---|---|
| **add** (new file, not yet tracked) | `chezmoi add <path>` → `chezmoi diff <path>` (expect: no diff, source = dest) | chezmoi creates the source-side parent dirs automatically (e.g., `dot_config/direnv/` on `chezmoi add ~/.config/direnv/direnvrc`). No `apply` needed because nothing changed in dest. |
| **edit** (tracked, .tmpl-safe) | `chezmoi edit <path>` → `chezmoi diff <path>` → `chezmoi apply [--force] <path>` | Use `--force` only when dest was modified after chezmoi last wrote it (e.g., the user hand-edited `~/.zshrc` outside chezmoi). The prompt this bypasses is the "modified since chezmoi last wrote" interactive confirmation. |
| **re-add** (tracked, NON-.tmpl drift) | `chezmoi re-add <path>` → `chezmoi diff <path>` (expect: no diff) | Forbidden on `.tmpl`-managed paths — destroys template syntax. If unsure, run `chezmoi source-path <path>` first; if it ends in `.tmpl`, use the **edit** entry point instead. |

### Commit message convention

Reserved prefix used by the auto-sync job:
- `auto: sync dotfiles YYYY-MM-DD` — never use this manually; it would collide with the sync job's own log scanning.

Human/Claude commits follow Conventional Commits with chezmoi-relevant scope hints:

- `feat(<area>): ...` — new tracked content or new capability (e.g., `feat(zsh): add git aliases`, `feat(apm): adopt mizchi/skills/foo`)
- `chore(<area>): ...` — version bumps, cleanups, lockfile-only refreshes
- `fix(<area>): ...` — workflow correction, restoring a removed line, repairing drift

Pick `<area>` to mirror the file path that's actually changing: `apm`, `brew`, `zsh`, `ghostty`, `claude`, `mise`, etc.

## Claude native install + PATH

Claude Code is installed via the native installer, not Homebrew:

- Binary: `~/.local/share/claude/versions/<version>/`
- Symlink: `~/.local/bin/claude → ~/.local/share/claude/versions/<version>`
- The installer **modifies `~/.zshrc` directly** to add `~/.local/bin` to PATH

The installer-injected line was hoisted into `dot_zshrc.tmpl` so `chezmoi apply` doesn't strip it on each run. The line in source:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

is in the Environment section of `dot_zshrc.tmpl`. If the installer re-adds the same line to `~/.zshrc` after a Claude Code update, run:

```bash
chezmoi apply --force ~/.zshrc
```

to discard the duplicate (the source version wins).

The Claude binary itself is **deliberately not chezmoi-managed** — it auto-updates via Claude's own updater. Tracking it in chezmoi would cause version rollbacks.

## Common operations cheat sheet

```bash
chezmoi diff [<path>]                       # diff
chezmoi status                              # state
chezmoi apply [-v] [--force] [<path>]       # apply
chezmoi add <path>                          # first-time track
chezmoi re-add [<path>]                     # update tracked (NOT for .tmpl)
chezmoi edit [-a] <path>                    # edit source (auto-resolves .tmpl)
chezmoi forget <path>                       # untrack but keep dest
chezmoi managed [<path>]                    # what is tracked
chezmoi unmanaged ~/                        # what is NOT tracked
chezmoi cd                                  # cd to source
chezmoi source-path <path>                  # show source path of a dest
chezmoi execute-template <file              # render a .tmpl manually
chezmoi data                                # vars available in templates
chezmoi doctor                              # setup diagnosis
```

## Troubleshooting

### chezmoi apply wants to delete a line that I didn't put there
Likely an installer (Claude, ghq, etc.) modified the dest file directly. Two paths:

1. Hoist the line into the chezmoi source (e.g. `dot_zshrc.tmpl`) so source matches what the installer expects. ← preferred for tools that re-inject on update.
2. `chezmoi re-add` the dest into source if the line is genuinely user-authored.

### "could not open a new TTY" when running chezmoi non-interactively
chezmoi prompts for confirmation when the dest was modified after chezmoi last wrote it. Pass `--force` to bypass:

```bash
chezmoi apply --force <path>
```

### A new file in `~/.claude/skills/` should it go to chezmoi or APM?

| Origin | Manager |
|---|---|
| Installed via `apm install` from a public/private repo | APM (`apm-add` helper) |
| Authored locally, only used by this user | chezmoi (`chezmoi add ~/.claude/skills/<name>`) |
| Forked from a public skill, want to customize | chezmoi (vendoring loses upstream updates intentionally) |

Name collisions: APM overwrites at install time. Don't mix the same name in both managers.

### `~/.config/Brewfile` drifted (added a package via `brew install` directly)
Either:
- `brew bundle dump --force --file=~/.config/Brewfile` to regenerate from current state, then `chezmoi re-add ~/.config/Brewfile`
- Or edit the source Brewfile directly and `chezmoi apply`

### Roll back a bad apply
chezmoi has no built-in undo. Use the source repo's git history:

```bash
chezmoi cd
git log --oneline -10
git reset --hard <good-rev>
cd -
chezmoi apply
```

Note: this fights the auto-sync job — coordinate by stopping the sync briefly or rebasing forward.

## Editing this skill

This skill itself is chezmoi-managed at `dot_claude/skills/chezmoi-management/SKILL.md`. To revise:

1. Edit the source: `chezmoi edit ~/.claude/skills/chezmoi-management/SKILL.md`
   (or directly: `~/.local/share/chezmoi/dot_claude/skills/chezmoi-management/SKILL.md`)
2. `chezmoi apply` to deploy
3. Restart Claude Code to pick up the change (skills load at startup)
4. Commit + push the dotfiles repo

Keep this skill focused on operations specific to this environment. General chezmoi knowledge belongs in chezmoi's own docs; this is the personal layer on top.
