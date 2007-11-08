#!/usr/bin/env ruby

# usage: ruby install.rb [-n] [--destdir=DESTDIR] [--vendor]
# options:
#  -n : don't install
#  --destdir=DESTDIR
#  --vendor
#
# Author: Tanaka Akira <akr@m17n.org>

require 'optparse'
require 'fileutils'

def target_directory(vendor)
  pat = vendor ? %r{/vendor_ruby/[\d.]+\z} : %r{/site_ruby/[\d.]+\z}
  $:.each {|loc|
    if pat =~ loc
      return loc
    end
  }
  raise "could not find target install directory"
end

CVS_FILES = {}
def cvs_files(dir)
  return CVS_FILES[dir] if CVS_FILES.include? dir
  if File.directory? "#{dir}/CVS"
    result = {}
    File.foreach("#{dir}/CVS/Entries") {|line|
      case line
      when %r{\A/([^/]+)/} then result[$1] = true
      when %r{\AD/([^/]+)/} then result[$1] = true
      end
    }
  else
    result = nil
  end
  CVS_FILES[dir] = result
  result
end

def each_target(&block)
  target_set = {}
  cvs = cvs_files('.')
  Dir.glob("*.rb") {|filename|
    next if /\Atest-/ =~ filename
    next if /\Ainstall/ =~ filename
    next if cvs && !cvs.include?(filename)
    target_set[filename] = true
    yield filename
    each_require(filename, target_set, &block)
  }
end

def each_require(file, target_set, &block)
  File.foreach(file) {|line|
    next if /\A\s*require\s+['"]([^'"]+)['"]/ !~ line
    feature = $1
    filename = "#{feature}.rb"
    next if target_set.include? filename
    next if !File.exist?(filename)
    target_set[filename] = true
    yield filename
    each_require(filename, target_set, &block)
  }
end

def collect_target
  result = []
  each_target {|filename| result << filename }
  result.sort!
  result
end

def install_file(src, dst)
  ignore_exc(Errno::ENOENT) { return if FileUtils.compare_file src, dst }
  # check shadow
  ignore_exc(Errno::ENOENT) { File.unlink dst }
  FileUtils.mkdir_p(File.dirname(dst), :mode=>0755)
  FileUtils.cp(src, dst, :verbose => true)
  File.chmod(0644, dst)
end

def ignore_exc(exc)
  begin
    yield
  rescue exc
  end
end

$opt_n = false
$opt_destdir = ""
$opt_vendor = false
ARGV.options {|q|
  q.banner = 'ruby install.rb [opts]'
  q.def_option('--help', 'show this message') {puts q; exit(0)}
  q.def_option('-n', "don't install") { $opt_n = true }
  q.def_option('--destdir=DESTDIR', "specify DESTDIR") {|destdir| $opt_destdir = destdir }
  q.def_option('--vendor', 'install to vendor directory') { $opt_vendor = true }
  q.parse!
}

if $opt_n
  dir = target_directory($opt_vendor)
  collect_target.each {|filename|
    puts "-> #{$opt_destdir}#{dir}/#{filename}"
  }
  exit
else
  File.umask 022
  dir = target_directory($opt_vendor)
  collect_target.each {|filename|
    install_file filename, "#{$opt_destdir}#{dir}/#{filename}"
  }
end

