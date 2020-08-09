require_relative '../lib/boot'

RSpec.describe Product do
  
  subject { Product.new(code: '001', name: 'Lavender heart', price_cents: 925) }
  
  describe '#valid?' do
    context 'valid product' do
      it 'is true' do
        expect(subject).to be_valid
      end
      it 'sets errors.messages to blank' do
        subject.valid?
        expect(subject.errors.messages).to be_blank
      end
    end
    context 'invalid product' do
      subject { Product.new(code: 'abc', price_cents: 9.25) }
      it 'is false' do
        expect(subject).not_to be_valid
      end
      it 'sets errors accordingly' do
        subject.valid?
        expect(subject.errors.messages).to eq({
          code: ["is invalid"],
          name: ["can't be blank"],
          price_cents: ["must be an integer"]
        })
      end
    end
  end
  
  describe '#price' do
    it 'converts the integer to pounds and pence' do
      expect(subject.price.format).to eq('£9.25')
    end
  end
    
end
