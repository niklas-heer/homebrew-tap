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

Both apps are notarized and update themselves through Sparkle, so the casks set
`auto_updates` and `brew upgrade` leaves them alone unless you pass `--greedy`.
The **Casks** workflow reads each app's appcast hourly, then bumps, audits,
installs, and checks the new release with Gatekeeper before opening an update PR.

Using the fully qualified formula name lets Homebrew trust only the formula being installed instead of the complete third-party tap.
