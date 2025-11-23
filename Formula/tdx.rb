class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "f77c5ab89b15c8c80cd84bda4e314e5b9f1721ec0e55bfb3a7f5057ec5ff0b56"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "ebbbfc75679941415e63ee7a43cacb57699744ecf1c999a4309cb86558ae8c93"

      def install
        bin.install "tdx-darwin-amd64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "acca7f14e2e773ec363d022251c8a1e18cf1772f824d7a5402f2dd4a1cef615c"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "467862a4c85bfc1267b0a2a3907c9608b6c8e7867c628310afc58e98670cf4cb"

      def install
        bin.install "tdx-linux-amd64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
