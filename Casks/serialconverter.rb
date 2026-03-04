cask "serialconverter" do
  version "0.2.16"
  sha256 arm:   "432e969af1edf4e41671df5372353afd0da3d32ab7aed9791d491c2e69bb4376",
         intel: "2e50f50806903e95d47bdb4404d28b5121ff543d6de8f61986351bb58e3d48ca"

  url "https://github.com/seishio/homebrew-serialconverter/releases/download/v#{version}/SerialConverter-#{version}-macos-#{Hardware::CPU.arm? ? "arm64" : "intel"}.dmg"
  name "SerialConverter"
  desc "Serial Converter is a powerful tool that extracts serial numbers from PDF files and converts certificate serial numbers."
  homepage "https://github.com/seishio/SerialConverter"
  
  depends_on macos: ">= :catalina"
  
  conflicts_with cask: [
    "serialconverter-beta",
    "serialconverter-dev",
  ]

  livecheck do
    url "https://github.com/seishio/homebrew-serialconverter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  app "SerialConverter.app"

  # Remove quarantine attribute to avoid security warnings
  postflight do
    system_command "xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/SerialConverter.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.serialconverter.*",
    "~/Library/Application Support/SerialConverter",
    "~/Library/Caches/dev.serialconverter",
    "~/Library/Logs/SerialConverter",
    "~/Library/Saved Application State/dev.serialconverter.savedState",
  ]
end
