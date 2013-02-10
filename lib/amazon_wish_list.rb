class AmazonWishList
  require 'uri'
  require 'net/http'

  $search_url = URI.parse('http://www.amazon.com/gp/registry/search.html/ref=cm_wl_search_go?ie=UTF8&type=wishlist')
  $provider_name = 'Amazon'
  $provider_version = '0.5'

  $params = {'index' => 'us-xml-wishlist',
             'registry-error-page' => 'templates/search/us-xml-wishlist-result.html',
             'field-name' => '', 'x' => '0', 'y' => '0'}

  $subst_field = 'index'

  def self.search field
    $params[$subst_field] = field
    page = Net::HTTP.post_form($search_url, $params)
  end


end