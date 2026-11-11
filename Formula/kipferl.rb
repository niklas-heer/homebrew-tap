class Kipferl < Formula
  desc "Bake Python CLI apps into fast standalone binaries"
  homepage "https://kipferl.dev"
  version "0.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-aarch64"
      sha256 "c02c5d128e337d487a903f5b0099e81439eff83dfc381761f48af43f2138066b"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-macos-x86_64"
      sha256 "b3f20b65f2cb8f68c58316df8212b9c9d7f691e343b7912079cc5a87f04b7864"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-aarch64"
      sha256 "9472363fef4aa9435454ca968c21b943cc5b8277bf537d27461a22f8195aa78b"
    else
      url "https://github.com/niklas-heer/kipferl/releases/download/v#{version}/kipferl-linux-x86_64"
      sha256 "bd752381392ffb7a07bab6352172c367718ec77947637c2b38000c7afee7407a"
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
