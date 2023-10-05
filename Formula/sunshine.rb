require "language/node"

class Sunshine < Formula
  desc "Gamestream host/server for Moonlight"
  homepage "https://app.lizardbyte.dev"
  url "https://github.com/LizardByte/Sunshine.git"
  license all_of: ["GPL-3.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/LizardByte/Sunshine.git", branch: "nightly"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "ffmpeg"
  depends_on "node"
  depends_on "openssl"
  depends_on "opus"

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "git", "submodule", "update", "--remote", "--init", "--recursive"
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
      -DSUNSHINE_ASSETS_DIR=sunshine/assets
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args

    cd "build" do
      system "make", "-j"
      system "make", "install"
    end
  end
end
