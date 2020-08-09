class Checkout
  
  attr_reader :basket
  
  def initialize(discounts=[])
    # NOTE: Basket is a hash that returns 0 for missing keys.
    # This way we can increment a missing value to get 1 without having to
    # create it first
    @basket = Hash.new(0)
  end
  
  # Add an item to the basket
  def scan(item)
    basket[item] += 1
  end
  
  protected
  
  # Get the subtotal - i.e. the total amount (including any BulkDiscounts) before
  # any GlobalDiscounts are applied. Returned as integer cents.
  def subtotal
    basket.inject(0) do |st, (item, quantity)|
      # add the total for each line in the basket to st (the total so far) and 
      # return it
      st + (item.price_cents * quantity)
    end
  end
end
