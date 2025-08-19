class Sideko < Formula
  desc "CLI for Sideko"
  homepage "https://sideko.dev"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.6.0/sideko-aarch64-apple-darwin.tar.xz"
      sha256 "a1f8bd556492e6c44facfb95a63848f4be6f27db96174fc995fee4b2018a1be9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.6.0/sideko-x86_64-apple-darwin.tar.xz"
      sha256 "0c17f1afd6f63429ddf9da5c9d24bad07fa3d1d86d6e291b80e102dd061f1152"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Sideko-Inc/sideko/releases/download/v1.6.0/sideko-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b05eb84fda01752f671672a0827ed98a7d9c3eb02560ad5c8a340b373e555620"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "sideko" if OS.mac? && Hardware::CPU.arm?
    bin.install "sideko" if OS.mac? && Hardware::CPU.intel?
    bin.install "sideko" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
