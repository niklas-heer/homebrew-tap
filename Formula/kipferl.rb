class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "4f8bfd9932eff07c64d49f2f8feb5085a7fb994934fbc3f61521c7e398ce9612"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "0107bf55a79d8b8b53f8cdf6085d8778118f21e457b87b3ba8071233addc5e8b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "34702c923dfb9687fab16b70d334c9e363359e7c5e05ce86ee52cfc8fa0d846c"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "aa93d8af6f050f8be1c60dedb34ef748c854074ca7bd55e5b807e6176be0fb33"
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
