cask "serialconverter" do
  arch arm: "arm64", intel: "intel"

  version "0.2.18"
  sha256 arm:   "4e43d93481be97e520cc1a7315b48ba91e27fe8f6c11d7e0de59807756804d59",
         intel: "22ee79f7c3606deceb147c1cb6b780e0a84c9dd9f70738387f63df8dcf926a77"

  url "https://github.com/seishio/homebrew-serialconverter/releases/download/v#{version}/SerialConverter-#{version}-macos-#{arch}.dmg"
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
  depends_on macos: :catalina

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
