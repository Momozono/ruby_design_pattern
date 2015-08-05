
class ClassVariableTester
  @@class_count = 0

  def initialize
    @instance_count = 0
  end

  def increment
    @@class_count = @@class_count + 1
    @instance_count = @instance_count + 1
  end

  def to_s
    "class_count: #{@@class_count} instance_count: #{@instance_count}"
  end
end

c1 = ClassVariableTester.new

c1.increment
c1.increment

puts ("c1: #{c1}")

c2 = ClassVariableTester.new
puts ("c2: #{c2}")

class SomeClass
  def a_method
    puts "hello from a method"
  end
end

SomeClass.a_method


class SimpleLogger
  attr_accessor :level

  ERROR = 1
  WARNING = 2
  INFO = 3

  def initialize
    @log = File.open("log.txt", "w")
    @level = WARNING
  end

  def error(msg)
    @log.puts(msg)
    @log.flush
  end

  def warning(msg)
    @log.puts(msg) if @level >= WARNING
    @log.flush
  end

  def info(msg)
    @log.puts(msg) if @level >= INFO
    @log.flush
  end
end
logger = SimpleLogger.new
logger.level = SimpleLogger::INFO
# インスタンスを持ち回りながら使う
logger.info('1番目の処理を実行')
logger.info('2番目の処理を実行')

# ロガーのようなオブジェクトをそこらじゅうに引きづり回さなくて済む
# SimpleLoggerにただ一つのインスタンスを管理させる責務を負わせる

###############################################################
### ただ一つのインスタンスを管理する ###



class SimpleLogger
  #
  #
  #
  @@instance = SimpleLogger.new

  def self.instance
    return @@instance
  end
end

logger1 = SimpleLogger.instance
logger2 = SimpleLogger.instance
logger3 = SimpleLogger.new
p logger1.object_id # 70354806787840 same
p logger2.object_id # 70354806787840 same
p logger3.object_id # 70354806787560 other




class SimpleLogger
  @@instance = SimpleLogger.new
  def self.instance
    return @@instance
  end
  private_class_method :new
end
# これでシングルトンの実装は完了です
SimpleLogger.new # => これで唯一のインスタンスしか作れなくなる

# シングルトンモジュール




require 'singleton'

class SimpleLogger
  include Singleton # これでクラス変数を定義して、シングルトンインスタンスで初期化して、self.instanceというクラスレベルメソッドを作りnewメソッドをプライベート化してくれる
  #
  #
  #
end

SimpleLogger.new # => private method `new' called for SimpleLogger:Class (NoMethodError)
SimpleLogger.instance # => #<SimpleLogger:0x007f97b9a7e510>

# 遅延シングルトンと積極的シングルトン
class SimpleLogger
  #
  #
  #
  @@instance = SimpleLogger.new
  #
  #
  #
end
# 必要になる前に作るのを積極的インスタンス化 → クラス変数タイプ
# instanceメソッドが呼ばれて初めて作成されるのが遅延インスタンス化 →モジュールタイプ

# グローバル変数をシングルトンとして使うことができる
# グローバル変数はあとで変更されてしまうのでシングルトン
# 無理やり定数に入れるか？

class ClassBasedLogger
  ERROR = 1
  WARNING = 2
  INFO = 3
  @@log = File.open('log.txt', 'w')
  @@level = WARNING
  def self.error(msg)
    @@log.puts(msg)
    @@log.flush
  end

  def self.warning(msg)
    @@log.puts(msg) if @@level >= WARNING
    @@log.flush
  end

  def self.info(msg)
    @@log.puts(msg) if @@level >= INFO
    @@log.flush
  end

  def self.level=(new_level)
    @@level = new_level
  end
end

ClassBasedLogger.level = ClassBasedlogger::INFO

ClassBasedLogger.info('コンピュータがチェスゲームに勝ちました')
ClassBasedLogger.warning('ユニットが故障しました')
ClassBasedLogger.error('機能停止、緊急動作を実行します')

# シングルトンクラス技法のいいところは、二つ目のインスタンスを作れないことに確信が持てるからです
# 遅延初期化の解決はできない
# このクラスが初期化されるのは、require などでロードされたとき

# モジュールの共通点を利用するというのがあります

module ModuleBasedLogger
  ERROR = 1
  WARNING = 2
  INFO = 3
  @@log = File.open('log.txt', 'w')
  @@level = WARNING
  def self.error(msg)
    @@log.puts(msg)
    @@log.flush
  end

  def self.warning(msg)
    @@log.puts(msg) if @@level >= WARNING
    @@log.flush
  end

  def self.info(msg)
    @@log.puts(msg) if @@level >= INFO
    @@log.flush
  end

  def self.level=(new_level)
    @@level = new_level
  end
end
# この形式で作っても、クラス定義したときと同様にどこからでも呼び出すことができる
ModuleBasedLogger.level = 3
ModuleBasedLogger.info('お知らせがあります〜〜〜') # お知らせがあります〜〜〜と書き込まれます
# モジュールを使うことによって、インスタンスを作る目的なのではないと明示することができる

a_second_logger = ModuleBasedLogger.clone
a_second_logger.error('二つ目のロガー')

# シングルトンとグローバル変数は同じか？
# たったひとつしか存在しないオブジェクトをグローバルスコープに作っています
# 幅広く散らばったプログラムがグローバル変数を通して密結合してしまう
# 適切に使われるならシングルトンはグローバル変数などではない
# 間違いなく一度しか現れないということをモデル化するのが目的です
# 一度しか現れないからこそ、シングルトンをプログラムの部分間をつなぐユニークなコミュニケーションのパイプとして使うことができる →これはダメ

class PreferenceManager
  def initialize
    @reader = PrefReader.new
    @writer = PrefWriter.new
    @preferences = { :display_splash => false, :background_color => :blue }
  end

  def save_preferences
    preferences = {}
    @writer.write(@preferences)
  end

  def get_preferences
    @preferences = @reader.read
  end
end

class PrefWriter
  def write(preferences)
    connection = DatabaseConnectionManager.instance.get_connection
    # プリファレンス情報を書き出す
  end
end

class PrefReader
  def read
    connection = DatabaseConnectionManager.instance.get_connection
    # プリファレンス情報を読みだしてそれを返す...
  end
end






























