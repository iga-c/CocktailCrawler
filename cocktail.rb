require 'nokogiri'
require 'set'
require 'find'

Material = Struct.new(:name, :volume)

class Cocktail
  def initialize(file_path)
    doc = Nokogiri::HTML(File.read(file_path))
    @name = doc.xpath('//div[@class="cnt"]/strong').text
    material_list = doc.xpath('//table/tr/td[@width="50"]/div[@align="center"]/../../../tr')
    @make = doc.xpath("/html/body/table/tr/td[2]/div[8]/table/tr/td[2]").text
    @materials = []

    material_list[1..-1].map{|item| item.xpath("td") }.each do |material|
      material_name = material[0].text
      material_volume = material[1..-1].text
      @materials.push(Material.new(material_name, material_volume))
    end
  end

  def create?(material_set)
    size_1 = material_set.size()
    
    for material in @materials
      material_set.add(material.name)
    end
    
    size_2 = material_set.size()
    size_1 == size_2
  end

  def print
    puts "カクテル名："
    puts "#{@name}"
    puts "材料："
    for material in @materials
      puts material.name + ":" + material.volume
    end
    puts "作り方："
    puts "#{@make}"
    puts "\n"
  end
end

cocktail_list = []

Find.find('./datas'){|f|
  if f == "./datas"
    next
  end
  
  cocktail_list.push(Cocktail.new(f))
}

my_materials_set = Set.new()
my_materials_file = open("my_materials.txt")
my_materials_file.each{|my_material|
  my_materials_set.add(my_material.strip)
}

for cocktail in cocktail_list
  cocktail.print() if cocktail.create?(my_materials_set.clone())
end
