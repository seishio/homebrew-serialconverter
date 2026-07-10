cask "serialconverter" do
  version "0.2.18"
  sha256 "608b72b928704a37685b743568aa7524c9581cddcd341bf2f5e3e540b4e851eb"

  url "https://github.com/seishio/homebrew-serialconverter/releases/download/v#{version}/SerialConverter-#{version}-macos-arm64.dmg"
  name "SerialConverter"
  desc "Extracts serial numbers from PDF files and converts certificate serial numbers"
  homepage "https://github.com/seishio/homebrew-serialconverter"

  livecheck do
    url "https://github.com/seishio/homebrew-serialconverter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  conflicts_with cask: [
    "serialconverter-beta",
    "serialconverter-dev",
  ]
  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "SerialConverter.app"

  # Remove quarantine attribute to avoid security warnings
  postflight do
    system_command "xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/SerialConverter.app"]
  end

  zap trash: [
    "~/Library/Application Support/SerialConverter",
    "~/Library/Caches/dev.serialconverter",
    "~/Library/Logs/SerialConverter",
    "~/Library/Preferences/com.serialconverter.*",
    "~/Library/Saved Application State/dev.serialconverter.savedState",
  ]
end
