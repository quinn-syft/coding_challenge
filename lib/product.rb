class Product
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :code, :name, :price_cents
  
  validates :code, :name, presence: true
  validates_format_of :code, with: /\A\d{3}\Z/
  validates :price_cents, presence: true, numericality: {only_integer: true}
  
  def price
    Money.new(price_cents)
  end
  
end
