class Checkout
  
  attr_reader :basket
  
  def initialize(discounts=[])
    # NOTE: Basket is a hash that returns 0 for missing keys.
    # This way we can increment a missing value to get 1 without having to
    # create it first
    @basket = Hash.new(0)
    load_discounts discounts
  end
  
  # Add an item to the basket
  def scan(item)
    basket[item] += 1
  end
  
  # Returns a Money for the total, after all discounts applied
  def total
    st = subtotal
    global_discount = best_global_discount_for(st)
    total_cents = st * (1.0 - global_discount.to_f / 100)
    Money.new(total_cents, 'GBP')
  end
  
  protected
  
  attr_reader :global_discounts
  
  # Get the subtotal - i.e. the total amount (including any BulkDiscounts) before
  # any GlobalDiscounts are applied. Returned as integer cents.
  def subtotal
    basket.inject(0) do |st, (item, quantity)|
      # add the total for each line in the basket to st (the total so far) and 
      # return it
      st + (item.price_cents * quantity)
    end
  end
  
  # Load the discounts into a hash for easy access
  def load_discounts(discounts)
    load_global_discounts discounts.select {|d| d.kind_of? GlobalDiscount}
  end
  
  def load_global_discounts(discounts)
    @global_discounts = discounts.inject({}) do |h, discount|
      h[discount.min_price_cents] = discount.discount_percent
      h
    end
  end
  
  # Find the best discount (the one with the highest min_price_cents) for the
  # given amount. Returns 0 if there is no appropriate discount
  def best_global_discount_for(cents)
    key = global_discounts.keys.select {|k| k <= cents}.sort.last
    global_discounts[key] || 0
  end
end
