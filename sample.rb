=begin
class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts "食べてます"
  end

  def speak
    puts "鳴いてます"
  end
end

class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      duck = new_animal("動物#{i}")
      @animals << animal
    end
  end

  def simulate_one_day
    @animals.each {|animal| animal.speak }
    @animals.each {|animal| animal.eat   }
    @animals.each {|animal| animal.sleep }
  end
end



class DuckPond < Pond # オブジェクトの生成をサブクラスに委譲する
  def new_animal(name)
    Duck.new(name)
  end
end

pond = DuckPond.new(3)
pond.simulate_one_day
=end

# ファクトリーとビルダーともにオブジェクトの生成について管理するもの

# ファクトリー → 単純なオブジェクトで有効、正しいオブジェクトを手に入れるのが目的、生成と実装の分離、生成するオブジェクトの指定方法をシンプルに
# 動作と生成管理を分離する方法です FactoryMethod内でオブジェクトの生成をすることで、生成を生成オブジェクト内にカプセル化


# そして、そのオブジェクト生成をするまでの過程が複雑であるほどビルダーのほうが便利になる →組み立ての複雑なオブジェクトで有効、オブジェクトを組み立てるの目的

# ここでいうオブジェクトは、ユーザーが使える準備ができたオブジェクトのこと



class SetDiscDrive
  def method_missing(name, *args)
    words = name.to_s.split('_')
    raise "undefine command error!" unless words.shift == 'add'
    words.each do |word|
      next if word == 'and'
      add_cd if word == 'cd'
      add_dvd if word == 'dvd'
    end
  end

  def add_cd
    puts "CDを加えました"
  end

  def add_dvd
    puts "DVDを加えました"
  end
end


disc_builder = SetDiscDrive.new
disc_builder.add_cd_andy















































