class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "9c8de391d56d90b127f3314926bd36433b066fc2b298e954ccf753ae269dc092"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "ade8e74d2c8228dd10a2439d4e6f5bf495f9f34f3e53d67fa642e7e6a31ffa81"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "d6e1239781adddc1fd21d72a0f30e07ab2051d2a0d5c4eb4b8c44ae3b19b309f"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "8d3bd774e861d160b23d4e184a36e36be9a3dff15e66e5270444b2a1a4aa7640"
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
