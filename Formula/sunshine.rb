class Sunshine < Formula
  desc "Gamestream host/server for Moonlight"
  homepage "https://app.lizardbyte.dev"
  url "https://github.com/LizardByte/Sunshine.git",
      # is tag required? won't be available until after a release is published
      tag:      "v0.19.1",
      revision: "d70d084f9fbb4e0150977a89d94937418a3ccf9c"
  license all_of: ["GPL-3.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/LizardByte/Sunshine.git"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "npm"
  depends_on "openssl@1.1"
  depends_on "opus"

  def install
    system "npm", "install"
    args = %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
      -DSUNSHINE_ASSETS_DIR=sunshine/assets
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args

    cd "build" do
      system "make", "-j"
      system "make", "install"
    end
  end

  test do
    # test that version numbers match
    assert_match "Sunshine version: v0.19.1", shell_output("#{bin}/sunshine --version").strip
  end
end