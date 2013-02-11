class AmazonWishList
  require 'uri'
  require 'mechanize'

  $search_url = 'http://www.amazon.com/gp/wishlist'
  $root_url = 'http://amazon.com'
  $provider_name = 'Amazon'
  $provider_version = '0.1'

  $search_field_name = 'field-name'
  $search_form_name = 'search-box'

  $subst_field = 'field-name'

  def initialize
    @agent = Mechanize.new()
  end

  def search(field)
    find_wish_lists field
  end

  def items(url)
    get_items url
  end

  private

  def get_items(url)
    @agent.get url
    items = @agent.page.search('tbody[class="itemWrapper"]')
    parse_items items if items
  end

  def parse_items(items)
    @items = Array.new()

    items.each do |item|
      i = Hash.new()
      i[:title] = item.search('span[class="small productTitle"] a').text
      i[:url] = item.search('span[class="small productTitle"] a')[0][:href]
      i[:price] = item.search('.wlPriceBold strong').text
      i[:added] = item.search('.commentBlock .commentBlock nobr').text
      i[:priority] = item.search('.priorityValueText').text.strip
      i[:quantity] = item.search('.quantityValueText').text.strip
      i[:img_url] = item.search('.productImage img')[0]['src']
      @items << i
    end
  end

  def find_wish_lists(field)
    @agent.get($search_url)
    form = @agent.page.form_with(name: $search_form_name)
    form[$search_field_name] = field
    if form.submit()
      parse_lists
    end
  end

  def parse_lists
    lists = @agent.page.search('//div[starts-with(@id, "regListsList")]')
    $wish_lists = Array.new

    puts "Found #{lists.count} wish lists."

    lists.each do |list|
      wish_list = Hash.new()
      wish_list[:name] = list.search('.regListUnsel').text
      wish_list[:url] = $root_url + list.search('a')[0]['href']
      wish_list[:items] = list.search('.regListCount').text

      $wish_lists << wish_list
    end

    $wish_lists
  end
end