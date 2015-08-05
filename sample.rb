=begin
# Name Space
module Japan
  module YEAR2013
    POPULATION = 127300000
  end
end

module America
  module YEAR2013
    POPULATION = 316740000
  end
end

Japan::YEAR2013::POPULATION   # => 127300000
America::YEAR2013::POPULATION # => 316740000
=end



class Duck
  def initialize(name)
    @name = name
  end
  def eat
    puts("アヒル #{@name}は食事中です")
  end
  def speak
    puts("アヒル #{@name}がガーガー鳴いています")
  end
  def sleep
    puts("アヒル #{@name}は静かに眠っています")
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
  def initialize(number_animals, animal_class, number_plants, plant_class)
    @animal_class = animal_class
    @plant_class = plant_class

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
    @plants.each  {|plant| plant.grow }
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