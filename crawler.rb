require 'anemone'

URL = "http://www.cocktailtype.com/cocktail/cocktail_name_n_0001.html"

Anemone.crawl( URL, :depth_limit => 1, :skip_query_strings => true, :delay => 2 ) do | anemone |
    anemone.focus_crawl do |page|
        page.links.keep_if { |link|
            link.to_s.match(/\/recipe\//)
        }
    end

    datas_path = "./datas/"
    FileUtils.mkdir_p(datas_path) unless File.exists?(datas_path)

    anemone.on_every_page do | page |
        p File.basename(page.url.to_s)
        File.write(datas_path + File.basename(page.url.to_s), page.body.encode("UTF-8","Shift_JIS"))
    end
end
