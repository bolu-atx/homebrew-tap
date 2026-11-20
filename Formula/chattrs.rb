class Chattrs < Formula
  desc "Distributed client/server messaging for cross-agent coordination"
  homepage "https://github.com/bolu-atx/chattrs"
  version "0.5.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bolu-atx/chattrs/releases/download/v0.5.0/chattrs-aarch64-apple-darwin.tar.xz"
    sha256 "34e48c2ea2fb9aafbb07075890ca3a4cdf034e19e39aab6e514766bca0f73608"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.5.0/chattrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ad0f412242c7bf19126aa0e1a223e143a32d6d6d1ecb05704868045e69fc3b75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.5.0/chattrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a65690b4ea3283ebbf71908cfc7623250175ba76837d211242279885d9245ca6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "chattrs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "chattrs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "chattrs"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
