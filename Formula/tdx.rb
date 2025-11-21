class Tdx < Formula
  desc "Fast Markdown Todo Manager with TUI"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "f8461e40a2ece4affc5c98b4910709c1d605e2a2bd55a5d95314d867e8c927df"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-x64"
      sha256 "18a9b2cea6c0ab83b44e94a763fcf850077be80578773d934c48c32f6e97f090"

      def install
        bin.install "tdx-darwin-x64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "3fe92e6d7d3d9a1175d905be839008e030e36a8ee461515341c5f8e12fa0e8dc"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-x64"
      sha256 "1e460e8216f75bb3c9dc9490d9f03e7909a263e2da783b61bbbe3bebf7c9945b"

      def install
        bin.install "tdx-linux-x64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
