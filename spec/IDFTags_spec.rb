require 'spec_helper'
require 'json'

describe IDFTags do

  before :each do
    @idftags = IDFTags::IDFTags.new
  end

  describe '#register_bad_word_lexicon' do
    context 'where bad word lexicon with same locale exists' do
      it 'should register the bad word lexicon' do
        lexicon = BadWordLexicon.new(:en, ['test'])
        @idftags.register_bad_word_lexicon lexicon
        expect(@idftags.instance_variable_get(:@bad_word_lexica)).to include(lexicon)
      end
    end

    context 'where bad word lexicon with same locale does not exist' do
      it 'should add the words' do
        lexicon1 = BadWordLexicon.new(:en, ['test'])
        lexicon2 = BadWordLexicon.new(:en, ['test1'])

        @idftags.register_bad_word_lexicon lexicon1
        @idftags.register_bad_word_lexicon lexicon2

        lexicon = @idftags.instance_variable_get(:@bad_word_lexica).select { |l| l.locale == :en }.first
        expect(lexicon.bad_words).to match_array(['test', 'test1'])
      end
    end
  end

  describe '#unregister_bad_word_lexicon' do

    it 'should not remove other locales' do
      lexicon1 = BadWordLexicon.new(:en)
      lexicon2 = BadWordLexicon.new(:de)

      @idftags.register_bad_word_lexicon lexicon1
      @idftags.register_bad_word_lexicon lexicon2

      expect(@idftags.instance_variable_get(:@bad_word_lexica)).to include(lexicon1)
      expect(@idftags.instance_variable_get(:@bad_word_lexica)).to include(lexicon2)

      @idftags.unregister_bad_word_lexicon :en

      expect(@idftags.instance_variable_get(:@bad_word_lexica)).to include(lexicon2)
    end

    context 'where locale is not registered' do
      it 'should do nothing' do
        @idftags.unregister_bad_word_lexicon :en
      end
    end

    context 'where locale is registered' do
      it 'should remove the locale' do
        lexicon = BadWordLexicon.new(:en)

        @idftags.register_bad_word_lexicon lexicon
        expect(@idftags.instance_variable_get(:@bad_word_lexica)).to include(lexicon)

        @idftags.unregister_bad_word_lexicon :en
        expect(@idftags.instance_variable_get(:@bad_word_lexica)).to_not include(lexicon)
      end
    end
  end

  describe '#tags' do

    context 'challenges' do

      before :each do
        challenges_raw = JSON.parse File.open('./spec/fixtures/challenges/challenges.json').read
        @challenges = challenges_raw.map { |v| v['challenge'] }
      end

      it 'should retrieve 6 tags' do
        @idftags.register_bad_word_lexicon BadWordLexicon.from_yml('./spec/fixtures/lexica/en.yml')
        tags = @idftags.tags @challenges.first, @challenges, 6
        expect(tags.count).to eq(6)

        puts tags
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

  describe '#extract_terms' do
    context 'where one bad word lexicon is nil' do
      it 'should skip this' do
        @idftags.register_bad_word_lexicon nil
        terms = @idftags.send(:extract_terms, 'This IS a DOCument')
        expect(terms).to eq(['this', 'is', 'a', 'document'])
      end
    end

    context 'without bad words' do
      it 'should split the document in terms' do
        terms = @idftags.send(:extract_terms, 'This IS a DOCument')
        expect(terms).to eq(['this', 'is', 'a', 'document'])
      end
    end

    context 'with a single bad word lexicon' do
      it 'should filter the terms' do
        @idftags.register_bad_word_lexicon BadWordLexicon.new(:en, ['THIS', 'document'])
        terms = @idftags.send(:extract_terms, 'This IS a DOCument')
        expect(terms).to eq(['is', 'a'])
      end
    end

    context 'with multiple bad word lexica' do
      it 'should filter the terms' do
        @idftags.register_bad_word_lexicon BadWordLexicon.new(:en, ['this', 'document'])
        @idftags.register_bad_word_lexicon BadWordLexicon.new(:de, ['is'])
        terms = @idftags.send(:extract_terms, 'This IS a DOCument')
        expect(terms).to eq(['a'])
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
