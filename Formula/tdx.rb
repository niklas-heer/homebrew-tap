class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "163a55edec88e19adb9d6198da55809726715fe50d4155ada1659b0d76c20aa6"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "76d10eadaaece9599211e1c7c88ab760dccd43855b5bcb7279d59f5be7ac1b53"

      def install
        bin.install "tdx-darwin-amd64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "9fe5023cddee1b1668494dd24e17709e392488ef89fea8c6473139cec3171008"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "54ff6b42d17032e964e6cf57f7c69059096b2895e5811ac091a4d68c3c20bcf3"

      def install
        bin.install "tdx-linux-amd64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
