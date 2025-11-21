class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64.zip"
      sha256 "8b8b0ff6a5b8e8e1e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2"

      def install
        libexec.install "tdx-darwin-arm64" => "tdx"
        libexec.install "yoga.wasm"
        (bin/"tdx").write <<~EOS
          #!/bin/bash
          cd "#{libexec}" && exec ./tdx "$@"
        EOS
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-x64.zip"
      sha256 "61da7721736cc34b4e91be290a2c8d79b24785fa2e48e5e486e5390f23e60518"

      def install
        libexec.install "tdx-darwin-x64" => "tdx"
        libexec.install "yoga.wasm"
        (bin/"tdx").write <<~EOS
          #!/bin/bash
          cd "#{libexec}" && exec ./tdx "$@"
        EOS
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64.zip"
      sha256 "86fecf8e1a401f4bfeb00cdf64bb9ab202d550679827a08e9522b49d4337d0da"

      def install
        libexec.install "tdx-linux-arm64" => "tdx"
        libexec.install "yoga.wasm"
        (bin/"tdx").write <<~EOS
          #!/bin/bash
          cd "#{libexec}" && exec ./tdx "$@"
        EOS
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-x64.zip"
      sha256 "7cf688c4f965efcb91a0a8217c30f686bb8914bd2249eb4327e4438c87164462"

      def install
        libexec.install "tdx-linux-x64" => "tdx"
        libexec.install "yoga.wasm"
        (bin/"tdx").write <<~EOS
          #!/bin/bash
          cd "#{libexec}" && exec ./tdx "$@"
        EOS
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
