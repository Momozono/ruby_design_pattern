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

# クライアントがオブジェクトを要求したとき、確かに一つオブジェクトを返します
# その返されたオブジェクトは、ユーザが期待したオブジェクトそのものではありません
# そのオブジェクトは本当に期待したオブジェクトと同じような外見をし、同じような動作をしますが、実は偽物です
# その偽物オブジェクトは本物オブジェクトへの参照を保持します
# クライアントがプロキシ上のメソッドを呼び出したときは、プロキシは本物のオブジェクトに要求を送るだけです『要求を転送する』

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
    @real_object.withdraw(Amount)
  end
end

account = BankAccount.new(100) # accountは本物のオブジェクトすなわち本物のオブジェクト
account.deposit(50)
account.withdraw(10)

proxy = BankAccountProxy.new(account)
proxy.deposit(50)
proxy.withdraw(10)

# これを防御プロキシに作り変えましょう
# 検査ロジックを追加するだけ

require 'etc'

class Accountprotectionproxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def deposit(amount)
    check_access
    return @subject.deposit(amount)
  end

  def withdraw(amount)
    check_access
    return @subject.withdraw(amount)
  end

  def balance
    check_access
    return @subject.balance
  end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account."
    end
  end
end

# 本物の銀行口座オブジェクトが知る必要があるのは、その銀行口座だけです

# 銀行口座オブジェクトの前にプロキシをかませることにより、簡単にセキュリティの実装をしたり、仕様を変更できたりする
# サブジェクトを違うプロキシでラップするなどができる
# また全てのラップを削除して解除したり、ラッパーを入れ替えたりできる
# なので、BankAccountに全く踏み込むことなくBankAccountの実装を変更することができます
# 1.上記のように、ラッパーの仕様変更が楽
# 2.本物オブジェクトの責務から、防御機能をきれいに取り除くことにより、防御壁を通過して重要な機能が漏れるのを防ぐことができる

# リモートプロキシ、防御プロキシ
# 関心ごとの分離
# プロキシーを利用することで、作成コストがかかるオブジェクトの生成をほんとうに必要になるときだけ、できるだけ遅延できます
# 入金操作のように、ユーザが準備完了するまでBankAccountオブジェクトは生成したくないものです
# 仮装プロキシは最大の嘘つき
# 本当のオブジェクトを装いますが、クライアントコードがメソッドを呼び出すときだけ、仮装プロキシは慌ててオブジェクトへの参照を作るか、アクセスを行います



class VirtualAccountProxy
  def initialize(starting_balance = 0)
    @starting_balance = starting_balance
  end

  def deposit(amount)
    s = subject
    return s.deposit(amount)
  end

  def withdraw(amount)
    s = subject
    return s.withdraw(amount)
  end

  def balance
    s = subject
    return s.balance
  end

  def subject
    @subject || (@subject = BankAccount.new(@starting_balance))
  end
end
# しかしこれだと銀行口座オブジェクトの生成責務がプロキシにあることになる
## @subjectが空かどうかチェックして、もしまだ生成されてなければ新しいオブジェクトを作ります


class VirtualAccountproxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def subject
    @subject || (@subject = @creation_block.call)
  end## 
end

# account = VirtualAccountProxy.new { BankAccount.new(10) }
# これで、本物の
# BankAccountオブジェクトは預け入れと引き落としを行い、一方でVirtualAccountProxyがBankAccountインスタンス生成の問題を取り扱います


# account.deposit(13)
# これはメソッド呼び出しというよりは、Rubyのような動的言語では、メッセージ送信であり、「depositメッセージをaccountオブジェクトに送る」と理解すべき
# Rubyでは、depositというメッセージを送信しときに、なにもおこなわなかったり、他のメソッドを実行したりすることもできる


# Rubyはまずaccountのdepositメソッドを探しに、次にスーパークラスを探し、メソッドが見つかるか、スーパークラスがなくなるまで繰り返す

# depositメソッドがないときは、method_missingメソッドが呼び出される
# みつからなければObjectクラスまで遡ります
# Object#method_missingはNomethodErrorを引き起こすだけ

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


class AccountProxy
  def initialize(real_account)
    @subject = real_account
  end
end
##################################################
class AccountProxy
  def initialize(real_account)
    @subject = real_account
  end

  def method_missing(name, *args)
    puts("Delegating#{name} message to subject.")
    @subject.send(name, *args)
  end
end

##################################################
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
# 銀行口座オブジェクトにどれだけ委譲すべきメソッドがあってもこれは15行

##################################################


class VirtualProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def method_missing(name, *args)
    s = subject
    s.send(name, *args)
  end

  def subject
    @subject = @creation_block.call unless @subject
    @subject
  end
end
array = VirtualProxy.new{ Array.new }
array << 'hello'
array << 'out'
array << 'there'
