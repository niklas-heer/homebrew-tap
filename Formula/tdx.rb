class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.11.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "0529e96fa5148ef0b847794aeb1d3bab0c30d291c8319294626bb02c2aa18fd1"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "ba6ba0e2549c5a34085d80eee5f41653d7227d0f3782f050d1414292c365a312"

      def install
        bin.install "tdx-darwin-amd64" => "tdx"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "8ee17365d0a3c84a7387144d44590c856116612ca59ba7aae779fc30cc68ca26"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "12a0a659cf678b2fc20e53c10ac2a9e7500956009521f6bf36f5f480a992b82b"

      def install
        bin.install "tdx-linux-amd64" => "tdx"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
