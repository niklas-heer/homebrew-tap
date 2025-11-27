class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "aba4954e6e244462be4d3a9fdac0340a435af3b7a23b72a4afe8ba2f9f091c6d"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "1bf806e3e6618668d3564fc1163c4c6445311a46302d5145fc83ccfdf5b26693"

      def install
        bin.install "tdx-darwin-amd64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "dbcc8b7579f356b51077293090caac0ce297a0ac833e2f2e4e475fb27af05f80"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "edfb8d5a5c21a8efef430542a0969c9632342d2d026fc54e0bdcb9b3b56e0c74"

      def install
        bin.install "tdx-linux-amd64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
