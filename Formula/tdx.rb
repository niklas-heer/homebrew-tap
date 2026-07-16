class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.13.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "51892a025d4359ad89a22d55867b6e1cc29b9051b62a276cb819ccc82c8e026d"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "5394704b10d2c6bbb5fedb3b2b25f1567f90368b4d740e3e2f37a00254b92cdf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "678beaf3876c68e247301cc5e76bfd8c527120289636922dedde10c0cacd4f64"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "e46464dfcb2fd8f6504cd73e10c59de41823e1210e5db1677a83cca2d638c06f"
    end
  end

  def install
    bin.install Dir["tdx-*"].first => "tdx"
  end

  test do
    system bin/"tdx", "--help"
  end
end
