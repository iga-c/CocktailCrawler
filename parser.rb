require_relative 'cocktail'

HTML_DIR = File.expand_path('../html', __FILE__)

if $PROGRAM_NAME == __FILE__
  my_materials = File.read(File.expand_path('../my_materials.txt', __FILE__)).strip.split("\n").map(&:strip)
  cocktails = Dir.glob(File.join(HTML_DIR, '*recipe*'))
                 .map {|html| Cocktail.new(html) }
                 .select {|cocktail| cocktail.create?(my_materials) }

  cocktails.each{|cocktail| print("#{cocktail.recipe}\n") }
end
