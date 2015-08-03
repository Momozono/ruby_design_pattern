=begin
class TestMethodMissing
  def hello
    puts ("hello from real method")
  end

  def method_missing(name, *args)
    puts ("warning, unknown method error: #{name}")
    puts ("Arguments: #{args.join(' ')}")
  end
end

tmm = TestMethodMissing.new
tmm.hello
# tmm.method_missing
tmm.good_by('cruel', 'world')
=end

=begin
class BankAccount # 山田先生
  attr_reader :balance

  def initialize(starting_balance = 0)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

class BankAccountProxy # 代理人 全く同じインターフェイスを提供するが、金融の詳しいことは全く知りません 藤原先生 BankAcountから委譲されている。これだけならただの無駄な実装
  def initialize(real_object)
    @real_object = real_object
  end

  def balance
    @real_object.balance
  end

  def deposit(amount)
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    @real_object.withdraw(amount)
  end
end


proxy = BankAccountProxy.new(account)
proxy.deposit(50)
proxy.withdraw(10)


=end


=begin
class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def method_missing(name, *args)
    check_access
    @subject.send(name, *args)
  end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account"
    end
  end
end

AccountProtectionProxy.new("Fred", )


=end


class Hoge
  def initialize(subject)
    @subject = subject
  end

  def method_missing(name, *args)
  @subject.send(:uppcase).class.tap{|s| p s}
  end
end

hoge = Hoge.new
hoge.gggg