class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.11.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "bcdc2e5de0794cce7ec63307e5dc0f3c248a81c950670501a12e88c4a3ab38fb"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "bb9f9fe8acf45a5f135e0d9c8b19527adf2cae9efc79471d0f80bfe3e9e53a23"

      def install
        bin.install "tdx-darwin-amd64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "a3dd4dac94d5191f5e92086bcf8909ee1f9928386e343ff3a0d2853db8b369bd"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "2504cafc391dd829686f70f91c3ae609422c8dcf792ed578290171758be73803"

      def install
        bin.install "tdx-linux-amd64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
