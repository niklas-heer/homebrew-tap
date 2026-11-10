class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.7.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "7010c290c78d8f8979bbe3470e8ee3968ba807d294995b3dc25a4726d4df1adf"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "87368487846b1f265289d709445a2faa0a99bd755649aecce7f62698480ff965"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "d637c6743893bc2a0d324299faf17cfcfdde0f09d86b53c7b49f4dc341b3e87b"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "ca98c91b0ce330c90ba6b2471a352d0ff849dda892c3106bcc7e8c0e603c53fe"
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
