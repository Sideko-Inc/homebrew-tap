class Sideko < Formula
  desc "CLI for Sideko"
  homepage "https://sideko.dev"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.0.2/sideko-aarch64-apple-darwin.tar.xz"
      sha256 "dfbd6b98924a3949724fc45bafebc56bd4ffac741a2767d6d904a30c880f987c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.0.2/sideko-x86_64-apple-darwin.tar.xz"
      sha256 "73bae5c503f4f2c1d80181e2990aec65df17cc6427be69255ab34235d5d34892"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Sideko-Inc/sideko/releases/download/v1.0.2/sideko-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8ab3b5349ebd41b3fbd1f0443886e9ad0ced65b644a29706bc191b9b71f5578a"
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
