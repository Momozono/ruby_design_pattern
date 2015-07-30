array = %w[hoge huga foobar]
# 内部イテレータ Enumarator#eachの中身みたいなもの
def for_each_method(array)
  i = 0
  while i < array.length
    p array[i]
    i += 1
  end
end

for_each_method(array)

a = [10, 20, 30]

a.each do |a|
  puts a  
end


class Account
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=> (other)
    balance <=> other.balance
  end
end

class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def add_account(account)
    @accounts << account
  end
end

momozono = Account.new("momozono", 12345)
my_portfolio = Portfolio.new
my_portfolio.add_account(momozono)
my_portfolio.any? { |account| account.balance > 2000}.tap{|a|p a}


def subclasses_of(superclass)
  subclass = []
  ObjectSpace.each_object(Class) do |k|
    next if !k.ancestors.include?(superclass) || superclass == k || k.to_s.include?('::') || subclasses.include?(k.to_s)
    subclasses << k.to_s
  end
  subclasses
end