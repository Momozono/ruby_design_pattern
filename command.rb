#########################################################
class SlickButton
  #
  # ボタンの描画と管理の為のコード
  # コード省略
  # 
  def on_button_push
    # 
    # ボタンが押されたときに行う事
    #
  end
end

class SaveButton < SlickButton
  def on_button_push
    #
    # 現在の文書を保存
    #
  end
end

class NewDocumentButton < SlickButton
  def on_button_push
    #
    #　新しい文書を作成
    #
  end
end
# アプリケーションが巨大になると、SlickButtonサブクラスが膨大な数になる
# また、継承には柔軟性がない

#########################################################
# 委譲ベースの構築

class SlickButton
  attr_accessor :command

  def initialize(command)
    @command = command
  end
  # ボタンの描画と管理のためのコード
  #
  #
  def on_button_push
    @command.execute if @command
  end
end

class SaveCommand
  def execute
    # 現在の文書を保存
    #
    #
  end
end


save_button = SlickButton.new(SaveCommand.new)
# 実行クラスを渡す

#########################################################

# Rubyのコードブロックを利用したケース

class SlickButton
  attr_accessor :command

  def initialize(&block)
    @command = block
  end

  #
  # ボタンの描画と管理のためのコード
  #
  #
  def on_button_push
    @command.call if @command
  end
end


new_button = SlickButton.new do
  # 
  # 新しい文書を作成
  #
end


#########################################################
# 記録するコマンド
# Commandパターンは既に行った事のある履歴を残しておくことに使われます

# インストールプログラム ファイルの作成　コピー　移動　削除を行う



require 'fileutils'

class Command #基底コマンドクラス
  attr_accessor :description

  def initialize(description)
    @description = description
  end

  def execute
  end
end

class CreateFile < Command
  def initialize(path, contents)
    super("Create file: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end
end

class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    File.delete(@path)
  end
end

class CopyFile < Command
  include FileUtils
  def initialize(source, target)
    super("Copy file: #{source} to #{target}")
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end
end

# ここからどんどんクラスを増殖させることもできますが、いったん止めておきましょう
# 履歴を残す為にクラスをまとめあげるクラスが必要になってくるからです。

class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def execute
    @commands.each { |cmd| cmd.execute }
  end

  def description
    description = ''
    @commands.each { |cmd| description += cmd.description + "\n" }
    description
  end
end

cmds = CompositeCommand.new

cmds.add_command(CreateFile.new('file1.txt', "hello, world\n"))
cmds.add_command(CopyFile.new('file1.txt', 'file2.txt'))
cmds.add_command(DeleteFile.new('file1.txt'))

cmds.execute
puts cmds.description

#######################################


class Command #基底コマンドクラス
  attr_accessor :description

  def initialize(description)
    @description = description
  end

  def execute
  end
end


class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def execute
    @commands.each { |cmd| cmd.execute }
  end

  def unexecute #追加
    @commands.reverse.each { |cmd| cmd.unexecute }
  end

  def description
    description = ''
    @commands.each { |cmd| description += cmd.description + "\n" }
    description
  end
end

class CreateFile < Command
  def initialize(path, contents)
    super "Create file: #{path}"
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end

  def unexecute
    File.delete(@path)
  end
end

class DeleteFile < Command
  def initialize(path)
    super "Delete file: #{path}"
    @path = path
  end

  def execute
    if File.exists?(@path)
      @contents = File.read(@path)
    end
    f = File.delete(@path)
  end

  def unexecute
    #if @contents
      f = File.open(@path, "w")
      f.write(@contents)
      f.close
    #end
  end
end

#file = CreateFile.new('hoge.rb', "ほげほげ〜〜〜")
#file.execute

#delete_file = DeleteFile.new('hoge.rb')
#delete_file.execute
#delete_file.unexecute




class FileDeleteCommand
  def initialize(path)
    @path = path
  end

  def execute
    File.delete(@path)
  end
end

  fdc = FileDeleteCommand.new('foo.dat')
  fdc.execute



# Commandパターンのポイントは、何を行うかの決定と、それの実行を分離できる事です
# Rubyではかんたんに書けるが、複雑になることが多い
# その複雑さが本当に必要か検討する必要あり

# GUIフレームワークでよく使われる

# ActiveRecordはCommandパターンの典型例

class CreateBookTable < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.column :title, :string
      t.column :author, :string
    end
  end

  def self.down
    drop_table :books
  end
end


require 'madeleine'

class Employee
  attr_accessor :name, :number, :address

  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end

  def to_s
    "Employee: name: #{name}, num: #{number}, addr: #{address}"
  end
end

class EmployeeManager
  def initialize
    @employees = {}
  end

  def add_employee(e)
    @employees[e.number] = e
  end

  def change_address(number, address)
    employee = @employees[number]
    raise "No such employee" if not employee
    employee.address = address
  end

  def delete_employee(number)
    @employees.remove(number)
  end

  def find_employee(number)
    @employees[number]
  end
end

momozono = Employee.new("momozono", 1, "Machida")
employee_list = EmployeeManager.new
employee_list.add_employee(momozono)

puts employee_list.find_employee(1)

class AddEmployee
  def initialize(employee)
    @employee = employee
  end

  def execute(system)
    system.add_employee(@employee)
  end
end

class DeleteEmployee
  def initialize(number)
    @number = number
  end

  def execute(system)
    system.delete_employee(@number)
  end
end

class ChangeAddress
  def initialize(number, address)
    @number = number
    @address = address
  end

  def execute(system)
    system.change_address(@number, @address)
  end
end

class FindEmployee
  def initialize(number)
    @number = number
  end
  def execute(system)
    system.find_employee(@number)
  end
end


store = SnapshotMadeleine.new('employees') { EmployeeManager.new }

Thread.new do
  while true
    sleep(20)
    madeline.take_snapshot
  end
end

tom = Employee.new('tom', '1001', '1 Division Street')
harry = Employee.new('harry', '1002', '3435 Sunnyside Ave')

store.execute_command(AddEmployee.new(tom))
store.execute_command(AddEmployee.new(harry))

puts (store.execute_command(FindEmployee.new('1001')))
puts (store.execute_command(FindEmployee.new('1002')))


































