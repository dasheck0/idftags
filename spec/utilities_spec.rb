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

  describe '#document_frequency' do
    context 'where term is nil' do
      it 'should return 0' do
        result = Utilities.document_frequency nil, 'This is a document'
        expect(result).to eq(0)
      end
    end

    context 'where documents is nil' do
      it 'should return 0' do
        result = Utilities.document_frequency 'term', nil
        expect(result).to eq(0)
      end
    end

    context 'where document and term are set' do
      context 'where documents is empty' do
        it 'should return 0' do
          result = Utilities.document_frequency 'term', []
          expect(result).to eq(0)
        end
      end

      context 'where term is in no document' do
        it 'should return 0' do
          result = Utilities.document_frequency 'term', ['This is a document', 'This is another one']
          expect(result).to eq(0)
        end
      end

      context 'where term is in at least one document ' do
        it 'should return the number of documents where the term is found' do
          result = Utilities.document_frequency 'is', ['This is a document, which is not null', 'This is always one', 'This not']
          expect(result).to eq(2)
        end
      end
    end
  end
end