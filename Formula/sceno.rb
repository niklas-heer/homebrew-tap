class Sceno < Formula
  desc "Declarative architecture diagrams and slide decks from KDL"
  homepage "https://github.com/niklas-heer/sceno"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/sceno/releases/download/v#{version}/sceno_darwin_arm64.tar.gz"
      sha256 "5ff0711c8d7116d7fc2ffea62ab1e9e349e871c9f183dd088f73bc718f8f8cd1"
    end

    on_intel do
      url "https://github.com/niklas-heer/sceno/releases/download/v#{version}/sceno_darwin_amd64.tar.gz"
      sha256 "0b7c05fa6ab9a0d33ec2590361563715ee2b126057356d6b916dfba350a37eb2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sceno/releases/download/v#{version}/sceno_linux_arm64.tar.gz"
      sha256 "486d786402f533d56fee196103195d04f7f2d12c2f639c9d142568295fcd52ba"
    end

    on_intel do
      url "https://github.com/niklas-heer/sceno/releases/download/v#{version}/sceno_linux_amd64.tar.gz"
      sha256 "b4a16ea5d58a2b14c207a381afb34bbcfcf306c8f6805caef4888e988ee02832"
    end
  end

  def install
    bin.install "sceno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sceno version")
    assert_match "agent handbook", shell_output("#{bin}/sceno docs --json")
  end
end
