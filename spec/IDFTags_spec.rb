require 'spec_helper'
require 'json'

describe IDFTags do

  before :each do
    @idftags = IDFTags::IDFTags.new
  end

  describe '#tags' do

    context 'challenges' do

      before :each do
        challenges_raw = JSON.parse File.open('./spec/fixtures/challenges/challenges.json').read
        @challenges = challenges_raw.map { |v| v['challenge'] }
      end

      it 'should retrieve 6 tags' do
        tags = @idftags.tags @challenges.first, @challenges, 6
        expect(tags.count).to eq(6)
      end

      it 'should retrieve the proper tags' do
        tags = @idftags.tags @challenges.first, @challenges, 6
        expect(tags).to match_array(['the',
                                     'belt',
                                     'championship',
                                     'win',
                                     'rumble',
                                     'rails'])
      end
    end

    context 'faust' do
      before :each do
        faust_raw = JSON.parse File.open('./spec/fixtures/faust/faust.json').read
        @faust = faust_raw.map { |v| v['document'] }
      end

      it 'should retrieve 6 tags' do
        tags = (IDFTags::IDFTags.new :weight_raw, :weight_inverse_frequency).tags @faust.first, @faust, 20
        puts tags
        #expect(tags.count).to eq(6)
      end

      it 'should retrieve 6 tags' do
        tags = (IDFTags::IDFTags.new :weight_log_norm, :weight_probabilistic_inverse_frequency).tags @faust.first, @faust, 20
        puts tags
        #expect(tags.count).to eq(6)
      end
    end

  end

  describe '#prepare_document' do
    context 'where document is nil' do
      it 'should return nil' do
        result = @idftags.send(:prepare_document, nil)
        expect(result).to be_nil
      end
    end

    context 'where document is set' do
      it 'should remove comma and dots' do
        result = @idftags.send(:prepare_document, 'this is a, capitalized string.')
        expect(result).to eq('this is a capitalized string')
      end

      it 'should downcase the string' do
        result = @idftags.send(:prepare_document, 'This is a CApitalized String.')
        expect(result).to eq('this is a capitalized string')
      end
    end
  end

  describe '#tfidf' do
    it 'should call the proper methods' do
      expect(@idftags.instance_variable_get(:@tf)).to receive(:term_frequency).with('Faust', 'This is faust').and_return(0.5)
      expect(@idftags.instance_variable_get(:@idf)).to receive(:inverse_document_frequency).with('Faust', ['This is faust1', 'This is Fausr2']).and_return(0.5)

      result = @idftags.send(:tfidf, 'Faust', 'This is faust', ['This is faust1', 'This is Fausr2'])
      expect(result).to eq(0.25)
    end
  end

end
