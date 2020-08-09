require_relative '../lib/boot'

RSpec.describe Checkout do
  
  let!(:product1) { Product.new(code: '001', name: 'Lavender heart', price_cents: 925) }
  let!(:product2) { Product.new(code: '002', name: 'Personalised cufflinks', price_cents: 4500) }
  let!(:product3) { Product.new(code: '003', name: 'Kids T-shirt', price_cents: 1995) }
  
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
  
end
