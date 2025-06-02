class Sideko < Formula
  desc "CLI for Sideko"
  homepage "https://sideko.dev"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.4.0/sideko-aarch64-apple-darwin.tar.xz"
      sha256 "1c8d8b6126fd38bff0eb802b202e157d120f5805479f6b952063e594d8c8467d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.4.0/sideko-x86_64-apple-darwin.tar.xz"
      sha256 "b7749ca083e4903e31fa8a476ea8d68b73e2f7aa9baa5a08433835d2a0afb077"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Sideko-Inc/sideko/releases/download/v1.4.0/sideko-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1b0ef73ec1e3c434811bb2dfffba4951876646fc7b4a2518cc50e40a30a9efe5"
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
