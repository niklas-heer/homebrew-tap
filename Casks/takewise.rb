cask "takewise" do
  version "0.3.0,6"
  sha256 "bbf166657540f7843c887edcb53c83c1eeb183b26db9ca8878badb45a450aa1e"

  url "https://github.com/niklas-heer/takewise/releases/download/v#{version.csv.first}/Takewise-#{version.csv.first}-#{version.csv.second}.zip"
  name "Takewise"
  desc "Record voiceover narration over a finished film, line by line"
  homepage "https://github.com/niklas-heer/takewise"

  livecheck do
    url :url
    regex(/^Takewise[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.zip$/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on arch: :arm64
  # The word checks run whisper-cli; ffmpeg prepares audio and exports.
  depends_on formula: ["whisper-cpp", "ffmpeg"]
  depends_on macos: :sonoma

  app "Takewise.app"
  binary "#{appdir}/Takewise.app/Contents/MacOS/takewise"

  zap trash: [
    "~/.local/share/takewise",
    "~/Library/Application Support/Takewise",
    "~/Library/Caches/com.niklasheer.takewise",
    "~/Library/HTTPStorages/com.niklasheer.takewise",
    "~/Library/Preferences/com.niklasheer.takewise.plist",
    "~/Library/Saved Application State/com.niklasheer.takewise.savedState",
  ]

  caveats <<~EOS
    The speech model (1.5 GB) is not included. Install it with:
      takewise models install
    or from the button the recording window shows while it is missing.
  EOS
end
