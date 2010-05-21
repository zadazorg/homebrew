require 'formula'

class Python3 <Formula
  url 'http://www.python.org/ftp/python/3.1.2/Python-3.1.2.tar.bz2'
  homepage 'http://www.python.org/'
  md5 '45350b51b58a46b029fb06c61257e350'

  # Python 2.6.5 will build against OS X's libedit,
  # but let's keep using GNU readline.
  depends_on 'readline' => :optional
  # http://docs.python.org/library/gdbm.html
  depends_on 'gdbm' => :optional
  # http://docs.python.org/library/sqlite3.html
  depends_on 'sqlite' => :optional

  def options
    [
      ["--framework", "Do a 'Framework' build instead of a UNIX-style build."],
      ["--universal", "Build for both 32 & 64 bit Intel."],
      ["--test", "Perform test after build"]
    ]
  end

  def skip_clean? path
    path == bin+'python3' or path == bin+'python3.1' or # if you strip these, it can't load modules
    path == lib+'python3' # save a lot of time
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-framework" if ARGV.include? '--framework'
    
    # Note --intel is an old flag, supported here for back compat.
    if ARGV.include? '--universal' or ARGV.include? '--intel'
      args.push "--enable-universalsdk=/", "--with-universal-archs=intel"
    end
    
    system "./configure", *args
    system "make"
    
    # Perform tests after building, is good idea.
    if ARGV.include? '--test'
      system "make test"
    end
    
    system "make install"
  end
end
