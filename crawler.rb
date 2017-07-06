require 'anemone'
require 'fileutils'

URL = 'http://www.cocktailtype.com/cocktail/cocktail_name_n_0001.html'.freeze
HTML_DIR = File.expand_path('../html', __FILE__)

def save_filename(url_str)
  File.join(HTML_DIR, File.basename(url_str))
end

if $PROGRAM_NAME == __FILE__
  FileUtils.mkdir_p(HTML_DIR)

  Anemone.crawl(URL, depth_limit: 1, skip_query_strings: true, delay: 3) do |anemone|
    anemone.focus_crawl do |page|
      page.links.keep_if { |link|
        include_recipe = link.to_s.match(%r(/recipe/))
        not_crawl_html = !File.exist?(save_filename(link.to_s))

        include_recipe && not_crawl_html
      }
    end

    anemone.on_every_page do |page|
      p File.basename(page.url.to_s)
      File.write(save_filename(page.url.to_s), page.body.encode('UTF-8', 'Shift_JIS'))
    end
  end
end
