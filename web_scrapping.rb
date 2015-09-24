require 'wombat'
require "./vptwitter"

class WebScrapping
  def initialize
    @page = Wombat.crawl do
      base_url("https://vpcspartans.herokuapp.com/")
      path "games/2"

      main_tittle xpath: "//h1"
      main_tittle2({xpath: "//h2"})

      tables do
        results "css=ol#results > li", :iterator do
          players "css=a.player", :list
          result "css=small"
          time "css=time"
        end

        ratings "css=table#ratings > tbody > tr", :iterator do
          name 'css=td[1]'
          rating 'css=td[2]'
          wins 'css=td[3]'
          loses 'css=td[4]'
        end
      end
    end

    def publish
      rating = @page["tables"]["ratings"].first
      Vptwitter.new.post_twt("This is first position: #{rating["name"]}")
    end
  end
end

WebScrapping.new.publish
