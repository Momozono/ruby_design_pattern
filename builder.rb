class Computer
  attr_accessor :display
  attr_accessor :motherboard
  attr_reader :drives

  def initialize(display=:crt, motherboard=Motherboard.new, drives=[])
    @motherboard =motherboard
    @drives = drives
    @display = display
  end
end

class CPU
  # CPU共通のコード
end

class BasicCPU < CPU
  # あまり高速ではないCPUに関するたくさんのコード
end

class TurboCPU < CPU
  # 超高速のCPUに関するたくさんのコード
end

class Motherboard
  attr_accessor :cpu
  attr_accessor :memory_size
  def initialize(cpu = BasicCPU.new, memory_size = 1000)
    @cpu = cpu
    @memory_size = memory_size
  end
end

class Drive
  attr_reader :type # :hard_diskか:cdか:dvd
  attr_reader :size # MB
  attr_reader :writable # ドライブから書き込み可能ならばtrue

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end

motherboard = Motherboard.new(TurboCPU.new, 4000)

drives = []
drives << Drive.new(:hard_drive, 200000, true)
drives << Drive.new(:cd, 760, true)
drives << Drive.new(:dvd, 4700, false)

computer = Computer.new(:lcd, motherboard, drives)

# Builderパターンの考え方は、この種の構築ロジックをあるクラスにカプセル化してしまおうという単純なものです
# ビルダはnewメソッドを複数に分けたものです、コンストラクタの細分化
# 構築ロジックをクラスにカプセル化
# 隠蔽と分離は同じ




class ComputerBuilder
  attr_reader :computer

  def initialize
    @computer = computer
  end

  def turbo(has_turbo_cpu = true)
    @computer.motherboard.cpu = TurboCPU.new
  end

  def display=(display)
    @computer.display = display
  end

  def memory_size=(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end

  def add_cd(writer = false)
    @computer.drives << Drive.new(:cd, 760, writer)
  end

  def add_dvd(writer = false)
    @computer.drives << Drive.new(:dvd, 4000, writer)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << Drive.new(:hard_disk, size_in_mb, true)
  end
end

builder = ComputerBuilder.new
builder.turbo
builder.add_cd(true)
builder.add_dvd
builder.add_hard_disk(100000)
# 最終的にピカピカの新しいComputerインスタンスを手に入れられます
computer = builder.computer
# ComputerBuilderクラスを使うことで、個々のクラスがどれを指すのかを意識しなくて済む
#️ 必要なコンピュータの構成はビルダーに全て任せればいいのです

# builderをファクトリと比較することで、ファクトリはオブジェクトを見つけることが目的だったが、ビルダはオブジェクトを
# 構成することに焦点を置いている

# ラップトップっも開発することになりました

# つまり２種の製品を扱うことになったのです


class DesktopComputer < Computer
  # デスクトップの詳細に関するたくさんのコード
end

class LaptopComputer < Computer
  def initialze(motherboard = Motherboard.new, drives = [])
    super(:lcd, motherboard, drives)
  end

  # ラップトップの小j際に関するたくさんのコード
end
# 邪魔なオブジェクト生成に関するすべて分離するのが、ビルダの役割です

# とはいえ、もしビルダをオブジェクトの生成に使えば、ビルダはクラスの選択をする際にも便利に使うことができます

class ComputerBuilder
  attr_reader :computer

  def turbo(has_turbo_cpu = true)
    @computer.motherboard.cpu = TurboCPU.new
  end

  def memory_size=(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end
end


class DesktopBuilder < ComputerBuilder
  def initialize
    @computer = DesktopComputer.new
  end

  def display=(display)
    @display = display
  end
  def add_cd(writer = false)
    @computer.drives << Drive.new(:cd, 760, writer)
  end

  def add_dvd(writer = false)
    @computer.drives << Drive.new(:dvd, 40000, writer)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << Drive.new(:hard, size_in_mb, true)
  end
end

class LaptopBuilder < ComputerBuilder
  def initialize
    @computer = LaptopComputer.new
  end

  def display=(display)
    raise "Laptop display must be lcd" unless display == :lcd
  end

  def add_cd(writer = false)
    @computer.drives << LaptopDrive.new(:cd, 760, writer)
  end

  def add_dvd(writer = false)
    @computer.drives << LaptopDrive.new(:dvd, 4000, writer)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << LaptopDrive.new(:hard_disk, size_in_mb, true)
  end
end

def computer
  raise "Not enough memory" if @computer.motherboard.memory_size < 250
  raise "Too many drives" if @computer.drives.size > 4
  hard_disk = @computer.drives.find{ |drive| drive.type == :hard_disk }
  raise "No hard disk." unless hard_disk
  @computer
end


if !hard_disk
  raise "No room to add hard disk." if @computer.drives.size >= 4
  add_hard_disk(100000)
end


builder = LaptopBuilder.new
builder.add_hard_disk(10000)
builder.turbo

computer1 = builder.computer
computer2 = builder.computer

class LaptopBuilder

  def reset
    @computer = LaptopComputer.new
  end
end


# 私たちのビルダは確かにオブジェクトの生成や構成、検証のコードまで網羅し、アプリケーションのあらゆる部分を改善しています
# とはいえ、新しいコンピュータを用意するプロセスが上品だとは言えません

# マジックメソッド

builder.add_dvd_and_harddisk

builder.add_turbo_and_dvd_and_harddisk

def method_missing(name, *args)
  words = name.to_s.split('_')
  return super(name, *args) unless words.shift == 'add'
  words.each do |word|
    next if word == 'and'
    add_cd if word == 'cd'
    add_dvd if word == 'dvd'
    add_hard_disk(100000) if word == 'harddisk'
    turbo if word == 'turbo'
  end
end



# Builderパターンの必要性はアプリケーションが複雑になるにつれ大きくなります
# ビルダの汎用性はかなり高い

# 同じオブジェクトを生成するコードを探せば良い

# 実例 MailFactory
# MailFactory はメッセージを作るのにビルダ風のよいインターフェイスを提供することで
# 複雑さを乗り切ります

require 'rubygems'
require 'mailfactory'

mail_builder = MialFactory.new
mail_builder.to = 'russ@russolsen.com'
mail_builder.from = 'russ@russolsen.com'
mail_builder.subject = 'The document'
mail_builder.text = 'Here is that document you wanted'
mail_builder.attach = ('book.doc')

# ActiveRecordのfind系メソッドが実例
# Employee.find_by_firstname_and_lastname('John', 'Smith')

# Builder オブジェクトを作り出すのが難しい場合や、オブジェクトを構成するのに大量のコードを書かないといけない場合に、
# それらの生成コードを別クラスに、すなわちビルダに分離しようというもの

# ビルダーパターンでは、あるオブジェクト、すなわちビルダを用意して新しいオブジェクトの複数に別れた詳細を管理させ、オブジェクト生成に関する複雑な
# 部分を処理させます

# オブジェクトの構成を制御していることから、無効なオブジェクトを作ってしまうことを予防できたりもします
# ビルダーはオブジェクト生成に関わるところで最後のパターン















































