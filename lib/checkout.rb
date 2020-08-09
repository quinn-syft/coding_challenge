class Checkout
  
  attr_reader :basket
  
  def initialize(discounts=[])
    # Basket is a hash that autofills missing keys with a value of zero
    @basket = Hash.new(0)
  end
  
  # Add an item to the basket
  def scan(item)
    basket[item] += 1
  end
end
