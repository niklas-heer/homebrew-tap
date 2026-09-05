class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.7.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "f8b5f492d01044581ca1ed51be67f67da018a51a25c3868c7a634ae648e4ec4b"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "7042d40da56330f5135327275a501d8f5288b0dee9ba7a454e3c5fe444bee0d2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "7926f388edf127bede8f1a28285b24d2c245b19a19ea7a78d6a9bce29829b67a"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "9b1c596c9c26d616a5106af199a2df67ace0d641d099e464ea3c4916b3d2b079"
    end
  end

  def install
    binary_name = if OS.mac?
      Hardware::CPU.arm? ? "kipferl-macos-aarch64" : "kipferl-macos-x86_64"
    else
      Hardware::CPU.arm? ? "kipferl-linux-aarch64" : "kipferl-linux-x86_64"
    end

    bin.install binary_name => "kipferl"
  end

  test do
    assert_match "Kipferl", shell_output("#{bin}/kipferl --version")
  end
end
