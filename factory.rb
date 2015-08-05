# 状況に応じて正しいクラスを選択する方法はたくさんあります

class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts("アヒル#{@name}は食事中です")
  end

  def speak
    puts("アヒル#{@name}がガーガー鳴いています")
  end

  def sleep
    puts("アヒル#{@name}は静かに眠っています")
  end
end

class Pond
  def initialize(number_ducks)
    @ducks = []
    number_ducks.times do |i|
      duck = Duck.new("アヒル#{i}")
      @ducks << duck
    end
  end

  def simulate_one_day
    @ducks.each { |duck| duck.speak }
    @ducks.each { |duck| duck.eat   }
    @ducks.each { |duck| duck.sleep }
  end
end

pond = Pond.new(3)
pond.simulate_one_day


class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts "カエル #{@name}は食事中なのです"
  end

  def speak
    puts "カエル #{@name}はゲロゲロ鳴いています"
  end

  def sleep
    puts "カエル #{@name}は眠りません。一晩中鳴いています。"
  end
end
# しかしPondクラスには問題がある、initializeで明示的にアヒルを持っている
# PondからDuckを取り除く必要がある

# Template Methodをもう一度

class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end
  end
  def simulate_one_day
    @animals.each { |animal| animal.speak }
    @animals.each { |animal| animal.eat   }
    @animals.each { |animal| animal.sleep }
  end
end

class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end

pond = FrogPond.new(3)
pond.simulate_one_day



# TemplateMethodを新しいオブジェクトの生成の問題に適用しただけ
# 汎用的な基底クラスを作る.そして基底クラスで残されたところをサブクラスが埋める
# ファクトリメソッドでは、サブクラスにクラスの選択をさせる
# からの部分を埋めることで、池に住まわせるオブジェクトを決める


class Algae
  def initialize(name)
    @name = name
  end

  def grow
    puts "藻は日光を浴びて育ちます"
  end
end

class WaterLily
  def initialize(name)
    @name = name
  end

  def grow
    puts "スイレン #{@name}は浮きながら日光を浴びて育ちます"
  end
end

class Pond
  def initialize(number_animals, number_plants)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.each do |i|
      plant = new_plant("植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each { |plant| plant.grow }
    @animals.each { |animal| animal.speak }
    @animals.each { |animal| animal.eat   }
    @animals.each { |animal| animal.sleep }
  end
end

class DuckWaterLilyPond < Pond
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end

class FrogAlgaePond < Pond
  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end

# このように扱いにくい実装になってしまったのは、作り出すオブジェクトの型によってメソッドを分けてしまったからです
# つまりカエルやアヒルを作るnew_animalやnew_plantがあるせいです

# ファクトリメソッドをひとつだけ作り,そのファクトリメソッドには作るべきオブジェクトの型を知らせるパラメータを受け取るようにすることです.
# 引数で渡されたシンボルによって動物と植物どちらも作り出すことができます


########################################################
class Duck
  def initialize(name)
    @name = name
  end
  def eat
    puts("アヒル#{@name}は食事中です")
  end
  def speak
    puts("アヒル#{@name}がガーガー鳴いています")
  end
  def sleep
    puts("アヒル#{@name}は静かに眠っています")
  end
end

class WaterLily
  def initialize(name)
    @name = name
  end
  def grow
    puts "スイレン #{@name}は浮きながら日光を浴びて育ちます"
  end
end

class Algae
  def initialize(name)
    @name = name
  end
  def grow
    puts "藻は日光を浴びて育ちます"
  end
end

class Pond
  def initialize(number_animals, number_plants)
    @animals = []
    number_animals.times do |i|
      animal = new_organism(:animal, "動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = new_organism(:plant, "植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each {|plant| plant.grow}
  end
end

class DuckWaterLilyPond < Pond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    elsif type == :plant
      WaterLily.new(name)
    else
      raise "Unknown organism type #{type}"
    end
  end
end

#ひょっとすると池には魚がいるかもしれない。そういうときに役立ちます
duck = DuckWaterLilyPond.new(0, 1)
duck.simulate_one_day

class Pond
  def initialize(number_animals, animal_class, number_plants, plant_class)
    @animal_class = animal_class
    @plant_class = plant_class

    @animal = []
    number_animals.times do |i|
      animal = new_organism(:animal, "動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.each do |i|
      plant = new_organism(:plant, "植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each  {|plant| plant.glow }
    @animals.each {|animal| animal.speak }
    @animals.each {|animal| animal.eat   }
    @animals.each {|animal| animal.sleep }
  end

  def new_organism(type, name)
    if type == :animal
      @animal_class.new(name)
    elsif type == :plant
      @plant_class.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

pond = Pond.new(3, Duck, 2, WaterLily)
pond.simulate_one_day
# Pondクラスに動物植物クラスを収納しました。




class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts "カエル #{@name}は食事中なのです"
  end

  def speak
    puts "カエル #{@name}はゲロゲロ鳴いています"
  end

  def sleep
    puts "カエル #{@name}は眠りません。一晩中鳴いています。"
  end
end

class Algae
  def initialize(name)
    @name = name
  end
  def grow
    puts "藻は日光を浴びて育ちます"
  end
end

class Tiger
  def initialize(name)
    @name = name
  end

  def eat
    puts "トラ #{@name}は食べたいものをなんでも食べます"
  end

  def speak
    puts "トラ#{@name}はガオーと吠えています"
  end

  def sleep
    puts "トラ#{@name}は眠くなったら眠ります"
  end
end

class Tree
  def initialize(name)
    @name = name
  end

  def grow
    puts "#{@name}が高く育っています"
  end
end

class PondOrganismFactory
  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end

class JungleOrganismFactory
  def new_animal(name)
    Tiger.new(name)
  end

  def new_plant(name)
    Tree.new(name)
  end
end

class Habitat
  def initialize(number_animals, number_plants, organism_factory)
    @organism_factory = organism_factory

    @animals = []
    number_animals.times do |i|
      animal = @organism_factory.new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = @organism_factory.new_plant("植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each  {|plant| plant.grow }
    @animals.each {|animal| animal.speak }
    @animals.each {|animal| animal.eat   }
    @animals.each {|animal| animal.sleep }
  end
end

jungle = Habitat.new(1,4, JungleOrganismFactory.new)
jungle.simulate_one_day

pond = Habitat.new(2,4, PondOrganismFactory.new)
pond.simulate_one_day

class OrganismFactory
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class =animal_class
  end

  def new_animal(name)
    @animal_class.new(name)
  end

  def new_plant(name)
    @plant_class.new(name)
  end
end

# 複数の異なる関連したクラスがあり、その中から選ばなければいけない場合のみ使用しましょう

jungle_organism_factory = OrganismFactory.new(Tree, Tiger)

jungle = Habitat.new(1, 4, jungle_organism_factory)
jungle.simulate_one_day

"YAGNI You Ain't Gonna Need It"
# エンジニアはカヌーで大丈夫なところにクイーンメリー号を作ってしまう傾向にある
# 実際にRubyで動いているFactoryパターンは少ない


class Base
  def self.sqlite_connection(config)
    puts "start sqlite connection #{config}envirnment"
  end
end

adapter = "mysql"
method_name = "#{adapter}_connection"
Base.send(method_name, config)


# Factory Method & Abstract Factoryの２パターンがある
# どちらもどのクラスを選ぶのかという問いに答えるためのクラス

 # Abstract Factoryパターンは、矛盾のないオブジェクトの組みを作りたいときに用いる
 # カエルとシマウマや、ユリとトラが一緒になったりしないようにするもの





class DuckTyping
  def self.mysql_connection(time)
    puts "Successfully connected. #{time}"
  end
end

adapter = "MySQL"
method_name = adapter.downcase + "_connection"

DuckTyping.send(method_name, Time.now)































