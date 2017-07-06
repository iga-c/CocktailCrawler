require 'nokogiri'
require 'find'

Material = Struct.new(:name, :volume)

class Cocktail
  attr_reader :name, :make, :materials

  def initialize(html)
    doc = Nokogiri::HTML(File.read(html))

    @name = doc.xpath('//div[@class="cnt"]/strong').text
    @make = doc.xpath('/html/body/table/tr/td[2]/div[8]/table/tr/td[2]').text
    @materials = doc.xpath('//table/tr/td[@width="50"]/div[@align="center"]/../../../tr')[1..-1]
                    .map { |item| item.xpath('td') }
                    .map { |td| Material.new(td[0].text.strip, td[1..-1].text) }
  end

  def create?(my_materials)
    @materials.map(&:name).all? { |item| my_materials.include?(item) }
  end

  def recipe
    print("カクテル名：#{@name}\n")
    print("材料：\n")
    @materials.each { |material| print("#{material.name}：#{material.volume}\n") }
    print("作り方：\n")
    print("#{@make}\n")
  end
end
