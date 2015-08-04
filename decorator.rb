# オブジェクトの責務を変えたい場合は？
# それぞれの状況ごとに必要なオブジェクトを作成する
# 必ずしもヒーローになるかはわからない

class EnhancedWriter
  attr_reader :check_sum

  def initialize(path)
    @file = File.open(path, "w")
    @check_sum = 0
    @line_number = 1
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def checksumming_write_line(data)
    data.each_byte { |byte| @check_sum = (@check_sum + byte ) % 256 }
    @check_sum += "\n"[0] % 256
    write_line(data)
  end

  def timestamping_write_line(data)
    write_line("#{Time.new}: #{data}")
  end

  def numbering_write_line(data)
    write_line("#{@line_number}: #{data}")
    @line_number += 1
  end

  def close
    @file.close
  end
end

writer = EnhancedWriter.new('out.txt')
writer.write_line("努力にうらみなかりしか")

writer.checksumming_write_line('チェックサム付き')
puts("チェックサムは#{writer.check_sum}")

writer.timestamping_write_line('タイムスタンプ付き')
writer.numbering_write_line('行番号付き')

# 全てが同じクラスに詰め込まれてる



#############################################################
class SimpleWriter
  def initialize(path)
    @file = File.open(path, "w")
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end

class WriterDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
  end
end

class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.now}: #{line}")
  end
end

writer = NumberingWriter.new(TimeStampingWriter.new(SimpleWriter.new('final.txt'))) # 機能をオプションはここでつける
writer.write_line('おはよう')



# 正式なDecoratorパターン
# WriterDecoratorクラスはおきまりパターンになっていて、次のライタ
require 'forwardable'

class WriterDecorator
  extend Forwardable

  def_delegators :@real_writer, :write_line, :rewind, :pos, :close

  def initialize(real_writer)
    @real_writer = real_writer
  end
end


w = SimpleWriter.new('out')

class << w
  alias old_write_line write_line
  def write_line(line)
    old_write_line("#{Time.new}: #{line}")
  end
end

module TimeStampingWriter
  def write_line(line)
    super("#{Time.new}: #{line}")
  end
end

module NumeberingWriter
  attr_reader :line_number

  def write_line(line)
    @line_number = 1 unless @line_number
    super("#{line_number}: #{line}")
    @line_number += 1
  end
end

w = SimpleWriter.new('out')
w.extend(NumberingWriter)
w.extend(TimeStampingWriter)

w.write_line('hello')



# Rubyはインスタンスクラスの振る舞いをいつでも変える事ができる

class Hoge
  def printName(name)
    print name
  end
end

hoge = Hoge.new

module Huga
  def printHuga
    puts "hugahuga"
  end
end

hoge.extend(Huga)
hoge.printHuga
# こういった形ででコレータを実装できる しかしでコレータを取り除く事はできません
# 使う人にとって煩雑になりがちなのがDecoratorの欠点


# aliasはデバッグがしにくくなる
# オブジェクト生成回数はかなり多くなってしまう デコレータがデコレータに渡しているので


def write_line(line)
  puts line
end
def write_line_with_timestamp(line)
  write_line_without_timestamp("#{Time.new}: #{line}")
end
alias_method_chain :write_line, :timestamp


def write_line_with_numbering(line)
  @number = 1 unless @number
  write_line_without_numbering("#{@number}: #{line}")
  @number += 1
end

alias_method_chain :write_line, :numbering



module Logging
  def log(message)
    puts message
  end

  def log_with_timestamp(message)
    log_without_timestamp("#{Time.now}: #{message}")
  end

  alias_method :log_without_timestamp, :log
  alias_method :log, :log_with_timestamp
end

include Logging
log('hello')

# より綺麗に書くと。。。

# Railsでのみ有効ActiveSupportライブラリのメソッド
module Logging
  def log(message)
    puts message
  end

  def log_with_timestamp(message)
    log_without_timestamp("#{Time.now}: #{message}")
  end

  alias_method_chain :log, :timestamp
end

include Logging
log('Heeloo')


# alias_methodはRubyメソッド、alias_method_chainはRailsのActiveSupportのメソッドである


