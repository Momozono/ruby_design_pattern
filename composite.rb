class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end

class AddDryIngredientsTask < Task #　葉クラス
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0 # 小麦粉と砂糖を加えるのに１分
  end
end

class MixTask < Task # 葉クラス
  def initialize
    super('Mix that batter up')
  end

  def get_time_required
    3.0
  end
end

class MakeBatterTask < Task #３つの子タスクから構成されている
  def initialize
    super('Make batter')
    @sub_tasks = []
    add_sub_task( AddDryIngredientsTask.new )
    add_sub_task( AddLiquidsTask.new )
    add_sub_task( MixTask.new )
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required #ここで子タスクの時間を全て合計している
    time = 0.0
    @sub_tasks.each {|task| time += task.get_time_required }
    time
  end
end


#####################################



class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end

class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    time = 0.0
    @sub_tasks.each { |task| time += task.get_time_required}
    time
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    add_sub_task( AddDryIngredientsTask.new )
    add_sub_task( AddLiquidsTask.new )
    add_sub_task( MixTask.new )
  end
end

class MakeCakeTask < CompositeTask
  def initialize
    super('Make cake')
    add_sub_task( MakeBatterTask.new )
    add_sub_task( FilePanTask.new )
    add_sub_task( BakeTask.new )
    add_sub_task( FrostTask.new )
    add_sub_task( LickSpoonTask.new )
  end
end 
#####################################
class Task
  attr_accessor :name, :parent

  def initialize(name)
    @name = name
    @parent = nil
  end

  def get_time_required
    0.0
  end
end

class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
  end

  def get_time_required
    time = 0.0
    @sub_tasks.each { |task| time += task.get_time_required }
    time
  end
end

#####################################

class Entry
  def get_name
  end

  def ls_entry(prefix)
  end

  def remove
  end
end

class FileEntry < Entry
  def initialize(name)
    @name = name
  end

  def get_name
    @name
  end

  def ls_entry(prefix)
    puts prefix + "/" + get_name
  end

  def remove
    puts @name + "削除しました"
  end
end

class DirEntry < Entry
  def initialize(name)
    @name = name
    @directory = Array.new
  end

  def get_name
    @name
  end

  def add(entry)
    @directory.push(entry)
  end

  def ls_entry(prefix) #ファイルディレクトリのパスを返す
    puts prefix + "/" + get_name
    @directory.each do |e|
      e.ls_entry(prefix + "/" + @name)
    end
  end

  def remove
    @directory.each do |i|
      i.remove
    end
    puts @name + "削除しました"
  end
end

  root = DirEntry.new("root") #nameだけセットした状態
  tmp = DirEntry.new("tmp") #nameだけセットした状態

  tmp.add(FileEntry.new("conf"))#nameだけセットした状態
  tmp.add(FileEntry.new("data"))#nameだけセットした状態 #@directoryにはFileEntryオブジェクト配列

  root.add(tmp)

  root.ls_entry("")
























