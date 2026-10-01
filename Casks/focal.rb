cask "focal" do
  version "0.2.0,2"
  sha256 "424437b8419f1e3758296e6381d3e8aba5bd76754c9a732c38c8118cd1782bc9"

  url "https://github.com/niklas-heer/focal/releases/download/v#{version.csv.first}/Focal-#{version.csv.first}-#{version.csv.second}.zip"
  name "Focal"
  desc "Focused Markdown editor with live rendering, opened from the terminal"
  homepage "https://github.com/niklas-heer/focal"

  livecheck do
    url "https://github.com/niklas-heer/focal/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Focal.app"
  binary "#{appdir}/Focal.app/Contents/MacOS/focal"

  zap trash: [
    "~/Library/Application Support/Focal",
    "~/Library/Caches/com.niklasheer.focal",
    "~/Library/HTTPStorages/com.niklasheer.focal",
    "~/Library/Preferences/com.niklasheer.focal.plist",
  ]
end
