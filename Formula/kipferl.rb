class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "a732d260524e7149fc0da9c151c731b5a7bdb284a7906698d441f7518dae6fbd"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "e29b9e0e3839e79fd323490370b26863720c8ef74bf8af977744fca2aa2c1179"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "95c8a20624b2775fd2f9264e1e1c0d6152251b5522f6a4633f569108d9f13c7e"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "de7672437d65ac449c3aea762069ff2368d308a2f48d63fc2c273f2507abbb7a"
    end
  end

  def install
    binary_name = if OS.mac?
      Hardware::CPU.arm? ? "kipferl-macos-aarch64" : "kipferl-macos-x86_64"
    else
      Hardware::CPU.arm? ? "kipferl-linux-aarch64" : "kipferl-linux-x86_64"
    end

    bin.install binary_name => "kipferl"
    bin.install_symlink "kipferl" => "ucharm"
  end

  test do
    assert_match "Kipferl", shell_output("#{bin}/kipferl --version")
    assert_match "renamed to", shell_output("#{bin}/ucharm --version 2>&1")
  end
end
