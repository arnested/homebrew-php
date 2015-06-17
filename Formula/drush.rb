require File.expand_path("../../Requirements/php-meta-requirement", __FILE__)

class Drush < Formula
  desc "A command-line shell and scripting interface for Drupal"
  homepage "https://github.com/drush-ops/drush"
  url "https://github.com/drush-ops/drush/archive/7.0.0.tar.gz"
  sha256 "05b7c95902614812978559280a6af86fc7ad3946c11217fe4a14f9df7500d1dc"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-php"
    cellar :any
    sha256 "65bc8364ae4d985489ad3ae3b49dc76b7b77ab108301d585d07b10907df9e0d2" => :yosemite
    sha256 "6685f49b9ff95133e540a5d82b74dba9f19245eb090a26510667dd3d6678719e" => :mavericks
    sha256 "057f14845035fcd9e4e64dc78714f146e6210ff42e2f6134bbc198fd04301cfb" => :mountain_lion
  end

  head do
    url "https://github.com/drush-ops/drush.git"
  end

  depends_on PhpMetaRequirement
  depends_on "composer" => :build
  depends_on "php53" if Formula["php53"].linked_keg.exist?
  depends_on "php54" if Formula["php54"].linked_keg.exist?
  depends_on "php55" if Formula["php55"].linked_keg.exist?
  depends_on "php56" if Formula["php56"].linked_keg.exist?

  def install
    system "composer", "install"

    prefix.install_metafiles
    File.delete "drush.bat"
    libexec.install Dir["*"]
    (bin+"drush").write <<-EOS.undent
      #!/bin/sh

      export ETC_PREFIX=${ETC_PREFIX:=#{HOMEBREW_PREFIX}}
      export SHARE_PREFIX=${SHARE_PREFIX:=#{HOMEBREW_PREFIX}}

      exec "#{libexec}/drush" "$@"
    EOS
    bash_completion.install libexec/"drush.complete.sh" => "drush"
  end

  test do
    system "drush", "version"
  end
end
