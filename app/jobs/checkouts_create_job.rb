class CheckoutsCreateJob < ApplicationJob
  queue_as :default
  def perform(shop_domain:, webhook:)

  end
end


