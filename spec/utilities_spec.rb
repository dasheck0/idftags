require 'spec_helper'

context Utilities do

  describe '#raw_frequency' do
    context 'where term is nil' do
      it 'should return 0' do
        result = Utilities.raw_frequency nil, 'This is a document'
        expect(result).to eq(0)
      end
    end

    context 'where document is nil' do
      it 'should return 0' do
        result = Utilities.raw_frequency 'term', nil
        expect(result).to eq(0)
      end
    end

    context 'where document and term are set' do
      context 'where term is not in document' do
        it 'should return 0' do
          result = Utilities.raw_frequency 'term', 'This is a document'
          expect(result).to eq(0)
        end
      end

      context 'where term is in document ' do
        it 'should return the frequency' do
          result = Utilities.raw_frequency 'is', 'This is a document, which is not null'
          expect(result).to eq(2)
        end
      end
    end
  end

  describe '#max_frequency' do
    context 'where document is nil' do
      it 'should return 0' do
        result = Utilities.max_frequency nil
        expect(result).to eq(0)
      end
    end

    context 'where document is not nil' do
      context 'and document is empty' do
        it 'should return 0' do
          result = Utilities.max_frequency ''
          expect(result).to eq(0)
        end
      end

      context 'and the document is not empty' do
        it 'should return the most frequent word count' do
          result = Utilities.max_frequency 'This is a document, which is not null'
          expect(result).to eq(2)
        end
      end
    end
  end
end