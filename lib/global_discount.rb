# A GlobalDiscount is one that is applied to the whole basket.
#
# If the value of the basket goes over min_price_cents, deduct
# discount_percent from the total
class GlobalDiscount
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :min_price_cents, :discount_percent
  validates :min_price_cents, :discount_percent, presence: true, numericality: {only_integer: true}
end
