cask "focal" do
  version "0.6.1,7"
  sha256 "541efc12896f0ef6e0ec5a3d7a6e08f573204c050e6bb8a2e0080b0b124b5aeb"

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
