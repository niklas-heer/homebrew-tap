cask "focal" do
  version "0.6.0,6"
  sha256 "eaa811f155d7420787da46ab8b27ffead1e3ab85c9b01dbfab994fc5ad2d6ce5"

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
    "~/Library/WebKit/com.niklasheer.focal",
  ]
end
