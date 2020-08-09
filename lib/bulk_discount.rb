# A BulkDiscount is a rule that says when the basket gets over
# a certain number of a given product, its price is to be reduced
# to the given price_cents
class BulkDiscount
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :product_code, :threshold, :price_cents
  validates :product_code, presence: true
  validates :threshold, :price_cents, presence: true, numericality: {only_integer: true}
end
