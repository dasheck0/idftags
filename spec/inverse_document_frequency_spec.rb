require 'spec_helper'

describe IDFTags::InverseDocumentFrequency do

  before :each do
    @inverse_document_frequency = IDFTags::InverseDocumentFrequency.new
  end

  describe '#initialize' do
    context 'where term frequency is instanciated with inproper weight' do
      it 'should raise an error' do
        expect { inverse_document_frequency = IDFTags::InverseDocumentFrequency.new :unknown }.to raise_error
      end
    end

    context 'where term frequency is instanciated with a proper weight' do
      it 'should return a term frequency object' do
        inverse_document_frequency = IDFTags::InverseDocumentFrequency.new :weight_inverse_frequency
        expect(inverse_document_frequency).to be_an_instance_of IDFTags::InverseDocumentFrequency
      end

      it 'should set the weight properly' do
        inverse_document_frequency = IDFTags::InverseDocumentFrequency.new :weight_inverse_frequency
        expect(inverse_document_frequency.instance_variable_get(:@weight)).to eq(:weight_inverse_frequency)
      end
    end
  end

  describe '#inverse_document_frequency' do
    it 'should call the weigth' do
      expect(@inverse_document_frequency).to receive(:weight_inverse_frequency).with('term', ['document1', 'document2'])
      @inverse_document_frequency.inverse_document_frequency 'term', ['document1', 'document2']
    end
  end

  describe '#weights' do
    it 'should return the weights' do
      result = @inverse_document_frequency.send(:weights)
      expect(result).to match_array([:weight_unary, :weight_inverse_frequency, :weight_inverse_frequency_max, :weight_inverse_frequency_smooth, :weight_probabilistic_inverse_frequency])
    end
  end

  describe '#weight_unary' do
    it 'should return 1' do
      result = @inverse_document_frequency.send(:weight_unary, 'term', [])
      expect(result).to eq(1)
    end
  end

  describe '#weight_inverse_frequency' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency, nil, ['This id document 1', 'This is document 2'])
        expect(result).to eq(0)
      end
    end

    context 'where documents are nil' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where documents are empty' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency, 'term', [])
        expect(result).to eq(0)
      end
    end

    context 'where term and documents are set' do
      it 'should return the proper weighted inverse document frequency' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency, 'term', ['this is  the first document, which contains term', 'And this is not'])
        expect(result).to eq(0)
      end
    end
  end

  describe '#weight_inverse_frequency_smooth' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency_smooth, nil, ['This id document 1', 'This is document 2'])
        expect(result).to eq(0)
      end
    end

    context 'where documents are nil' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency_smooth, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where documents are empty' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency_smooth, 'term', [])
        expect(result).to eq(0)
      end
    end

    context 'where term and documents are set' do
      it 'should return the proper weighted inverse document frequency' do
        result = @inverse_document_frequency.send(:weight_inverse_frequency_smooth, 'term', ['this is  the first document, which contains term', 'And this is not'])
        expect(result).to eq(0.4054651081081644)
      end
    end
  end

  describe '#weight_inverse_frequency_max' do
    context 'where term is nil' do
      it 'should return 0' do
        pending("Not implemented yet")
        result = @inverse_document_frequency.send(:weight_inverse_frequency_max, nil, ['This id document 1', 'This is document 2'])
        expect(result).to eq(0)
      end
    end

    context 'where documents are nil' do
      it 'should return 0' do
        pending("Not implemented yet")
        result = @inverse_document_frequency.send(:weight_inverse_frequency_max, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where documents are empty' do
      it 'should return 0' do
        pending("Not implemented yet")
        result = @inverse_document_frequency.send(:weight_inverse_frequency_max, 'term', [])
        expect(result).to eq(0)
      end
    end

    context 'where term and documents are set' do
      it 'should return the proper weighted inverse document frequency' do
        pending("Not implemented yet")
        result = @inverse_document_frequency.send(:weight_inverse_frequency_max, 'term', ['this is  the first document, which contains term', 'And this is not'])
        expect(result).to eq(0)
      end
    end
  end

  describe '#weight_probabilistic_inverse_frequency' do
    context 'where term is nil' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_probabilistic_inverse_frequency, nil, ['This id document 1', 'This is document 2'])
        expect(result).to eq(0)
      end
    end

    context 'where documents are nil' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_probabilistic_inverse_frequency, 'term', nil)
        expect(result).to eq(0)
      end
    end

    context 'where documents are empty' do
      it 'should return 0' do
        result = @inverse_document_frequency.send(:weight_probabilistic_inverse_frequency, 'term', [])
        expect(result).to eq(0)
      end
    end

    context 'where term and documents are set' do
      it 'should return the proper weighted inverse document frequency' do
        result = @inverse_document_frequency.send(:weight_probabilistic_inverse_frequency, 'term', ['this is  the first document, which contains term', 'And this is not'])
        expect(result).to eq(-0.6931471805599453)
      end
    end
  end
end