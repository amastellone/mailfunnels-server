class CartsCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      puts "FUCKFUCKFUCKFUCK"
        Mailfunn
    end
  end
end
