class Sceno < Formula
  desc "Declarative architecture diagrams and slide decks from KDL"
  homepage "https://github.com/niklas-heer/sceno"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/niklas-heer/sceno/releases/download/v0.5.0/sceno_darwin_arm64.tar.gz"
      sha256 "754c2c13ddfe3f5db2c6603f555ac29ba13ea7a0063932a69e7aab5e00a9ba56"
    end

    on_intel do
      url "https://github.com/niklas-heer/sceno/releases/download/v0.5.0/sceno_darwin_amd64.tar.gz"
      sha256 "ea7878fd0e6ca5301aed57affeaee17d3a3f89ef51582d801da8dc9b5d9d1bf0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sceno/releases/download/v0.5.0/sceno_linux_arm64.tar.gz"
      sha256 "c6456c8582a4f955b232651d223993866069da8278ea2c9d6fd7af7bbbf027e7"
    end

    on_intel do
      url "https://github.com/niklas-heer/sceno/releases/download/v0.5.0/sceno_linux_amd64.tar.gz"
      sha256 "fa3b3fa2e792856bdd39424ea307ebc3259464118e7bd24027d91a70b20c99a8"
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
