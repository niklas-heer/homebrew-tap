# Homebrew tap

Homebrew formulae and casks maintained by Niklas Heer.

## vrdx

Engineering decisions in Markdown, with a local graph dashboard and AI-friendly CLI.

```bash
brew install niklas-heer/tap/vrdx
```

Native binaries for macOS 15+ and GNU/Linux with glibc 2.39+, on ARM64 and x86-64.
No Rust toolchain is needed. See the [vrdx guide](https://github.com/niklas-heer/vrdx#readme).

The **Update vrdx** workflow checks published stable releases hourly or on manual
dispatch. It validates all four checksums and tests installation on each platform
before opening an update PR. Merge that PR to publish the formula; failed checks
leave the previous version available.

## repot

Keep every Git repository on your machine organised, current and portable.

```bash
brew install niklas-heer/tap/repot
```

Native binaries for macOS and GNU/Linux, on ARM64 and x86-64, with shell
completions. `brew install --HEAD niklas-heer/tap/repot` builds from source. See
the [repot guide](https://github.com/niklas-heer/repot#readme).

The **Update repot** workflow checks published stable releases hourly or on manual
dispatch. It renders the formula from the release's `SHA256SUMS`, tests installation
on each platform, and opens an update PR. Merge that PR to publish the formula.

## Sideporch

A small, self-hosted team chat: channels, direct messages, threads, search, file
uploads, push notifications, Slack-compatible webhooks and Lua automations.

```bash
brew install niklas-heer/tap/sideporch
brew services start niklas-heer/tap/sideporch   # optional: run it in the background
```

Native binaries for macOS and Linux, on ARM64 and x86-64. The Linux binaries are
fully static (musl), so they need no particular glibc. The background service keeps
its data in `$(brew --prefix)/var/sideporch`. Open `http://127.0.0.1:8080` and create
the admin account; `sideporch setup-link --data "$(brew --prefix)/var/sideporch"`
prints the setup link, which is a one-time secret when the server runs with
`--require-setup-link`. See the
[Sideporch guide](https://github.com/niklas-heer/sideporch#readme).

The **Update Sideporch** workflow checks published stable releases hourly or on
manual dispatch. It renders the formula from the release's `SHA256SUMS`, tests
installation and a running server on each platform, and opens an update PR. Merge
that PR to publish the formula. Until the first release exists, it does nothing.

## Kindred

A local family-history graph built from Markdown person notes.

```bash
brew install niklas-heer/tap/kindred
```

Linux x86-64 binaries require host glibc 2.35 or newer.

See the [Kindred user guide](https://github.com/niklas-heer/kindred/blob/main/docs/USER_GUIDE.md) for archive metadata, the browser viewer, and exports.

## Latchrun

Local command sessions with scoped credentials, redacted output, and usage analytics.

```bash
brew install niklas-heer/tap/latchrun
```

Requires macOS 15 or newer, or GNU/Linux with host glibc 2.39 or newer.

See the [Latchrun documentation](https://github.com/niklas-heer/latchrun#readme) for profiles, providers, and optional OS sandbox requirements.

## Sceno

Declarative architecture diagrams and slide decks from KDL.

```bash
brew install niklas-heer/tap/sceno
```

## tdx

Markdown todos at terminal speed.

```bash
brew install niklas-heer/tap/tdx
```

## Keywink

Command launcher with memorable key sequences and an on-screen key guide.

```bash
brew install --cask niklas-heer/tap/keywink
```

Requires macOS 13 or newer; runs natively on Apple silicon and Intel.

## Spokn

Text-to-speech reader with karaoke-style highlighting.

```bash
brew install --cask niklas-heer/tap/spokn
```

Requires macOS 14 or newer on Apple silicon.

## Focal

Focused Markdown editor with live rendering, opened from the terminal.

```bash
brew install --cask niklas-heer/tap/focal
```

Requires macOS 14 or newer on Apple silicon. The cask links the `focal` command,
so `focal notes.md` and `focal .` work right away.

All three apps are notarized and update themselves through Sparkle, so the casks set
`auto_updates` and `brew upgrade` leaves them alone unless you pass `--greedy`.
The **Casks** workflow reads each app's appcast hourly, then bumps, audits,
installs, and checks the new release with Gatekeeper before opening an update PR.

Using the fully qualified formula name lets Homebrew trust only the formula being installed instead of the complete third-party tap.
