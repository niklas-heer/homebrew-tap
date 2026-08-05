class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "f028d1522147a0e1999dec1da0d9983094a00217a4f713c52c6669388810ebba"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "4ab006a0802599f2425d82a125ef89f648eeb84630abd2c16a982e530c8e1fa6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "7556c399c952e4e466f233d3193e3b3665d9793f7141a62ba390d758f74a12ef"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "3073191e668a5f051044995148514b422e22a21fcdf7164272be1a9866056343"
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
