require "language/node"

class Sunshine < Formula
  desc "Gamestream host/server for Moonlight"
  homepage "https://app.lizardbyte.dev"
  url "https://git.sumsha.io/sumsha/Sunshine.git"
    # is tag required? won't be available until after a release is published
    #tag:      "v0.20.0",
    # revision: "11ebb47b3eed5ba397ecea639d137d3804f63d36"
  license all_of: ["GPL-3.0", "BSD-3-Clause", "MIT"]
  head "https://git.sumsha.io/sumsha/Sunshine.git", branch: "nightly"
  version "nightly"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "ffmpeg"
  depends_on "node"
  depends_on "openssl"
  depends_on "opus"

  def install
    #system "git", "checkout", "nightly"
    system "npm", "install", *Language::Node.local_npm_install_args
    system "git", "submodule", "update", "--remote", "--init", "--recursive"
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
      -DSUNSHINE_ASSETS_DIR=sunshine/assets
      -DCMAKE_CXX_COMPILER=g++
      -DCMAKE_C_COMPILER=gcc
    ]
# forced to use gcc bundled with Xcode-beta(which is basically apple clang) 
# because I'm using a preview version of Sonoma
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args

    cd "build" do
      system "make", "-j"
      system "make", "install"
    end
  end

#  test do
#    # test that version numbers match
#    assert_match version.to_s, shell_output("#{bin}/sunshine --version").strip
#  end
end
