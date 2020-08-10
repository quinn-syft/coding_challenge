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
    Money.new(total_cents)
  end
  
  protected
  
  attr_reader :global_discounts
  attr_reader :bulk_discounts
  
  # Get the subtotal - i.e. the total amount (including any BulkDiscounts) before
  # any GlobalDiscounts are applied. Returned as integer cents.
  def subtotal
    basket.inject(0) do |st, (item, quantity)|
      # add the total for each line in the basket to st (the total so far) and 
      # return it
      st + (price_for(item, quantity) * quantity)
    end
  end
  
  # Load the discounts into hashes for easy access
  def load_discounts(discounts)
    load_global_discounts discounts.select {|d| d.kind_of? GlobalDiscount}
    load_bulk_discounts discounts.select {|d| d.kind_of? BulkDiscount}
  end
  
  def load_global_discounts(discounts)
    @global_discounts = discounts.inject({}) do |h, discount|
      h[discount.min_price_cents] = discount.discount_percent
      h
    end
  end
  
  def load_bulk_discounts(discounts)
    @bulk_discounts = {}
    discounts.each do |discount|
      bulk_discounts[discount.product_code] ||= {}
      bulk_discounts[discount.product_code][discount.threshold] = discount.price_cents
    end
  end
  
  # Find the best discount (the one with the highest min_price_cents) for the
  # given amount. Returns 0 if there is no appropriate discount
  def best_global_discount_for(cents)
    key = global_discounts.keys.select {|k| k <= cents}.sort.last
    global_discounts[key] || 0
  end
  
  # Find the appropriate price for the given product and quantity, taking into account BulkDiscounts
  def price_for(product, quantity)
    # If we have bulk discounts for the given code
    if bulk_discounts.key?(product.code) &&
      # And there is a threshold lower than our quantity (pick the biggest)
      discount_key = bulk_discounts[product.code].keys.select {|k| k <= quantity}.sort.last
        # Return that price
        bulk_discounts[product.code][discount_key]
    else
      # In all other cases, return the product's usual price
      product.price_cents
    end
  end
end
