##########################################################
class Employee #単に従業員数のデータを保持しているだけ  
  attr_reader :name
  attr_accessor :title, :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end
end

fred = Employee.new("Momozono Tarou", "Engineer", 211200)

fred.salary = 250000

##########################################################


class Payroll
  def update(changed_employee)
    puts "#{changed_employee.name}の為に小切手を切ります"
    puts "彼の給料は今#{changed_employee.salary}です！"
  end
end

class Employee
  attr_reader :name, :title
  attr_reader :salary 

  def initialize(name, title, salary, payroll)
    @name = name
    @title = title
    @salary = salary
    @payroll = payroll
  end

  def salary=(new_salary)
    @salary = new_salary
    @payroll.update(self) 
  end
end

payroll = Payroll.new

fred = Employee.new('Momozono', 'Engineer', 30000, payroll)
fred.salary = 35000


##########################################################

class Payroll # 給与名簿クラス
  def update(changed_employee)
    puts "#{changed_employee.name}の為に小切手を切ります"
    puts "彼の給料は今#{changed_employee.salary}です！"
  end
end

class Taxman
  def update(changed_employee)
    puts "#{changed_employee.name}に新しい税金の請求書を送ります!"
  end
end


class Employee #　従業員デーセットクラス
  attr_reader :name, :title
  attr_reader :salary 

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end
end

momozono = Employee.new('Momozono', 'Engineer', 30000)

payroll = Payroll.new
taxman  = Taxman.new

momozono.add_observer(payroll) 
momozono.add_observer(taxman)

momozono.salary = 35000 # payroll.update(momozono)

# Employeeクラスのインスタンスはオブザーバがあってもなくてもうまく動作する　これ大事
#　これで、Fredの給与変更を受け取りたいオブジェクトはどんなものでも、Employeeオブジェクトにオブザーバとして登録できる

#　具体的に言うと、サブジェクトクラスにコンストラクタで空配列を作る事により、オブザーバとして管理をするオブジェクトを格納する
#  新聞に例えると、新聞を発行して配達するひとのほうが、新聞を読むだけの人よりもずっと大変なのです
# このままだとEmployeeサブジェクトクラスに業務が集積しすぎている

#　サブジェクトクラスに必要なのは次の要素
# 1. オブザーバを格納する為の配列
# 2. 配列を管理する為のメソッド
# 3. そして変更が発生したときの為の通知用メソッド

##########################################################
class Subject # 基底クラス
  def initialize
    @observers = []
  end

  def add_observers(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

class Employee < Subject
  attr_reader :name, :address
  attr_reader :salary

  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end
# 単一継承 継承は奥の手 一度スーパークラスを使ってしまえば、おわり
# これを解決するのがモジュール

##########################################################

module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

class Employee
  include Subject

  attr_reader :name, :address
  attr_reader :salary

  def initialize(name, title, salary)
    super() #moduleのinitialize呼び出し
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end
##########################################################
# Rubyのオブザーバブルモジュールはコードブロックに対応していない
require 'observer'

class Employee
  include Observable

  def salary
    p changed
    notify_observers(self)
  end
end

e = Employee.new
e.salary
##########################################################

module Subject
  def initialize
    @observers = []
  end

  def add_observer(&observer) #ここでobserverにコードブロックが入る
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
        observer.call(self)
    end
  end
end

class Employee
  include Subject

  attr_accessor :name, :title, :salary

  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def title=(new_title)
    old_title = @title
    @title = new_title
    if old_title != new_title
      notify_observers
    end
  end

  def salary=(new_salary)
    old_salary = @salary
    @salary = new_salary
    if old_salary != new_salary
      notify_observers
    end
  end
end

CHANGED_EMPLOYEE = lambda do |changed_employee|
  puts "Cut a new check for #{changed_employee.name}!"
  puts "His salary is now #{changed_employee.salary}!"
  puts "#{changed_employee.title}"
end

momozono = Employee.new("Momozono", "Crane Operator", 12345)

momozono.add_observer(&CHANGED_EMPLOYEE) 

momozono.salary = 123452
momozono.title = "Engineer"

##########################################################

module Subject
  def initialize
    @observers = []
  end

  def add_observer(&observer) #ここでobserverにコードブロックが入る
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
        observer.call(self)
    end
  end
end

class Employee
  include Subject

  attr_accessor :name, :title, :salary

  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def title=(new_title)
    old_title = @title
    if old_title != new_title
      @title = new_title
    end
  end

  def salary=(new_salary)
    old_salary = @salary
    if old_salary != new_salary
      @salary = new_salary
    end
  end

  def changes_complete
    notify_observers
  end
end

CHANGED_EMPLOYEE = lambda do |changed_employee|
  puts "従業員の名前が変更されました: #{changed_employee.name}さん"
  puts "給料: #{changed_employee.salary}"
  puts "職業: #{changed_employee.title}になりました"
end

momozono = Employee.new("Momozono", "Crane Operator", 12345)

momozono.add_observer(&CHANGED_EMPLOYEE) 

momozono.salary = 123452
momozono.title = "無職"

momozono.changes_complete
