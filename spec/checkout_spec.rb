require_relative '../lib/boot'

RSpec.describe Checkout do
  
  let!(:product1) { Product.new(code: '001', name: 'Lavender heart', price_cents: 925) }
  let!(:product2) { Product.new(code: '002', name: 'Personalised cufflinks', price_cents: 4500) }
  let!(:product3) { Product.new(code: '003', name: 'Kids T-shirt', price_cents: 1995) }
  
  describe '.new' do
    context 'No discounts provided' do
      subject { Checkout.new }
      it 'sets the internal global_discounts to {}' do
        expect(subject.send :global_discounts).to eq({})
      end
    end
    context 'Several discounts provided' do
      let(:discounts) { [
        GlobalDiscount.new(min_price_cents: 6000, discount_percent: 10),
        GlobalDiscount.new(min_price_cents: 20000, discount_percent: 15)
      ] }
      subject { Checkout.new(discounts) }
      it 'sets the internal global_discounts' do
        expect(subject.send :global_discounts).to eq({
          6000 => 10,
          20000 => 15
        })
      end
    end
  end
  
  describe '#scan' do
    subject { Checkout.new }
    context 'empty basket' do
      it 'adds the item to the basket with a quantity of 1' do
        subject.scan(product1)
        expect(subject.basket).to eq({product1 => 1})
      end
    end
    context 'basket contains another item' do
      before do
        subject.scan(product3)
      end
      it 'adds the item to the basket with a quantity of 1 and keeps the other item intact' do
        subject.scan(product1)
        expect(subject.basket).to eq({product1 => 1, product3 => 1})
      end
    end
    context 'item already in basket' do
      before do
        subject.scan(product1)
      end
      it 'increments the quantity' do
        subject.scan(product1)
        expect(subject.basket).to eq({product1 => 2})
      end
    end
  end
  
  describe '#subtotal' do
    context 'Checkout with no discounts' do
      subject { Checkout.new }
      it 'calculates the correct price' do
        subject.scan(product1) # £9.25
        subject.scan(product2) # £45
        subject.scan(product3) # £19.95
        subject.scan(product1) # £9.25
        expect(subject.send :subtotal).to eq(8345)
      end
    end
  end
  
  describe '#best_global_discount_for' do
    let(:discounts) { [
      GlobalDiscount.new(min_price_cents: 6000, discount_percent: 10),
      GlobalDiscount.new(min_price_cents: 20000, discount_percent: 15)
    ] }
    subject { Checkout.new(discounts) }
    it 'returns the best one for higher values' do
      expect(subject.send :best_global_discount_for, 25000).to eq(15)
    end
    it 'returns lower discounts if higher breakpoint not reached' do
      expect(subject.send :best_global_discount_for, 10000).to eq(10)
    end
    it 'returns 0 if no breakpoint reached' do
      expect(subject.send :best_global_discount_for, 4000).to eq(0)
    end
  end
  
  describe '#total' do
    # Discounts are the examples from the checkout.md, plus some other thresholds for test purposes
    let(:discounts) { [
      GlobalDiscount.new(min_price_cents: 6000, discount_percent: 10),
      GlobalDiscount.new(min_price_cents: 20000, discount_percent: 15)
    ] }
    subject { Checkout.new(discounts) }
    
    it 'applies the global discount if over the threshold' do
      subject.scan(product1)
      subject.scan(product2)
      subject.scan(product3)
      expect(subject.total.format).to eq('£66.78')
    end
    
    it 'applies a better global discount if over the higher threshold' do
      subject.scan(product2)
      subject.scan(product2)
      subject.scan(product2)
      subject.scan(product2)
      subject.scan(product2)
      expect(subject.total.format).to eq('£191.25')
    end
  end
  
end
