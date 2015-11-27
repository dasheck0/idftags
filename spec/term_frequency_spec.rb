require 'spec_helper'

describe IDFTags::TermFrequency do

  before :each do
    @term_frequency = IDFTags::TermFrequency.new
  end

  describe '#initialize' do
    context 'where term frequency is instanciated with inproper weight' do
      it 'should raise an error' do
        expect { term_frequency = IDFTags::TermFrequency.new :unknown }.to raise_error
      end
    end

    context 'where term frequency is instanciated with a proper weight' do
      it 'should return a term frequency object' do
        term_frequency = IDFTags::TermFrequency.new :weight_binary
        expect(term_frequency).to be_an_instance_of IDFTags::TermFrequency
      end

      it 'should set the weight properly' do
        term_frequency = IDFTags::TermFrequency.new :weight_log_norm
        expect(term_frequency.instance_variable_get(:@weight)).to eq(:weight_log_norm)
      end
    end
  end

  describe '#term_frequency' do
    it 'should call the weigth' do
      expect(@term_frequency).to receive(:weight_raw).with('term', 'document')
      @term_frequency.term_frequency 'term', 'document'
    end
  end

  describe '#weights' do
    it 'should return the weights' do
      result = @term_frequency.send(:weights)
      expect(result).to match_array([:weight_binary, :weight_raw, :weight_log_norm, :weight_double_norm])
    end
  end

  describe '#weight_binary' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_binary, nil, 'This is a document')
        expect(result).to eq(0)
      end
    end

    context 'where document is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_binary, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where term and document are set' do
      context 'where term is in document' do
        it 'should return the correct weight' do
          result = @term_frequency.send(:weight_binary, 'is', 'This is a document, which is set')
          expect(result).to eq(1)
        end
      end

      context 'where term is not in document' do
        it 'should return 0' do
          result = @term_frequency.send(:weight_binary, 'term', 'This is a document')
          expect(result).to eq(0)
        end
      end
    end
  end

  describe '#weight_raw' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_raw, nil, 'This is a document')
        expect(result).to eq(0)
      end
    end

    context 'where document is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_raw, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where term and document are set' do
      context 'where term is in document' do
        it 'should return the correct weight' do
          result = @term_frequency.send(:weight_raw, 'is', 'This is a document, which is set')
          expect(result).to eq(2)
        end
      end

      context 'where term is not in document' do
        it 'should return 0' do
          result = @term_frequency.send(:weight_raw, 'term', 'This is a document')
          expect(result).to eq(0)
        end
      end
    end
  end

  describe '#weight_log_norm' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_log_norm, nil, 'This is a document')
        expect(result).to eq(0)
      end
    end

    context 'where document is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_log_norm, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where term and document are set' do
      context 'where term is in document' do
        it 'should return the correct weight' do
          result = @term_frequency.send(:weight_log_norm, 'is', 'This is a document, which is set')
          expect(result).to eq(1.0986122886681098)
        end
      end

      context 'where term is not in document' do
        it 'should return 0' do
          result = @term_frequency.send(:weight_log_norm, 'term', 'This is a document')
          expect(result).to eq(0)
        end
      end
    end
  end

  describe '#weight_double_norm' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_double_norm, nil, 'This is a document')
        expect(result).to eq(0)
      end

    end

    context 'where document is nil' do
      it 'should return 0' do
        result = @term_frequency.send(:weight_double_norm, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where term and document are set' do
      context 'where term is in document' do
        it 'should return the correct weight' do
          result = @term_frequency.send(:weight_double_norm, 'is', 'This is a document, which is set')
          expect(result).to eq(1)
        end
      end

      context 'where term is not in document' do
        it 'should return k' do
          result = @term_frequency.send(:weight_double_norm, 'term', 'This is a document')
          expect(result).to eq(0.5)
        end
      end
    end
  end
end