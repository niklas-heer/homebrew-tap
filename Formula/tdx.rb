class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "64328739307b57937fb53e04d5700b243daa44678099efbbd057e658a257bccc"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "fcc86faf17365f370b43a7f7d35e85e414e33e3e6eeac3bff4f46173520509ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "d53a7ac6ec77231e79fca6a3d633e0f0c28b42899b17d16e5156d5736c3e1f13"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "5ae8e1c0eb2619c371feb00fbd7f66785e9b6ed2728bb35991211d2b47a25d7f"
    end
  end

  def install
    bin.install Dir["tdx-*"].first => "tdx"
  end

  test do
    system bin/"tdx", "--help"
  end
end
