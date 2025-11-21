class Tdx < Formula
  desc "Fast Markdown Todo Manager with TUI"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "PLACEHOLDER_DARWIN_ARM64"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-x64"
      sha256 "PLACEHOLDER_DARWIN_X64"

      def install
        bin.install "tdx-darwin-x64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "PLACEHOLDER_LINUX_ARM64"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-x64"
      sha256 "PLACEHOLDER_LINUX_X64"

      def install
        bin.install "tdx-linux-x64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
