# Homebrew tap

Homebrew formulae maintained by Niklas Heer.

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

Using the fully qualified formula name lets Homebrew trust only the formula being installed instead of the complete third-party tap.
