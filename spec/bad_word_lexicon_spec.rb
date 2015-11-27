require 'spec_helper'

describe BadWordLexicon do

  before :each do
    @bad_word_lexicon = BadWordLexicon.new :de
  end

  describe '#initialize' do
    it 'should set the locale' do
      bad_word_lexicon = BadWordLexicon.new :en
      expect(bad_word_lexicon.instance_variable_get(:@locale)).to eq(:en)
    end

    it 'should set the bad words' do
      bad_word_lexicon = BadWordLexicon.new :en, ['test']
      expect(bad_word_lexicon.instance_variable_get(:@bad_words)).to match_array(['test'])
    end
  end

  describe '#add' do
    context 'where bad word is nil' do
      it 'should not add the bad word' do
        @bad_word_lexicon.add nil
        expect(@bad_word_lexicon.bad_words).to_not include(nil)
      end
    end

    context 'where bad word is set' do
      context 'and bad word is already present' do
        it 'should not add the word twice' do
          @bad_word_lexicon.add 'test'
          expect(@bad_word_lexicon.bad_words).to match_array(['test'])

          @bad_word_lexicon.add 'test'
          expect(@bad_word_lexicon.bad_words).to match_array(['test'])
        end
      end

      context 'and bad word is not present yet' do
        it 'should add the word' do
          @bad_word_lexicon.add 'test'
          expect(@bad_word_lexicon.bad_words).to match_array(['test'])
        end
      end
    end
  end

  describe '#add_all' do
    context 'where bad words is nil' do
      it 'should not add the bad words' do
        @bad_word_lexicon.add_all nil
        expect(@bad_word_lexicon.bad_words).to_not include(nil)
      end
    end

    context 'where bad words is set' do
      context 'and bad words is already present' do
        it 'should not add words twice' do
          @bad_word_lexicon.add_all ['test']
          expect(@bad_word_lexicon.bad_words).to match_array(['test'])

          @bad_word_lexicon.add_all ['test1', 'test']
          expect(@bad_word_lexicon.bad_words).to match_array(['test1', 'test'])
        end
      end

      context 'and bad words is not present yet' do
        it 'should add the words' do
          @bad_word_lexicon.add_all ['test', 'test1']
          expect(@bad_word_lexicon.bad_words).to match_array(['test', 'test1'])
        end
      end
    end
  end

  describe '#from_yml' do
    it 'should check if the file exists' do
      expect(File).to receive(:exist?)
      BadWordLexicon.from_yml '.'
    end

    it 'should create a bad word lexicon instance' do
      lexicon = BadWordLexicon.from_yml './spec/fixtures/lexica/en.yml'
      expect(lexicon).to be_an_instance_of BadWordLexicon
    end

    it 'should set the locale properly' do
      lexicon = BadWordLexicon.from_yml './spec/fixtures/lexica/en.yml'
      expect(lexicon.locale).to eq(:en)
    end

    it 'should set the bad words properly' do
      lexicon = BadWordLexicon.from_yml './spec/fixtures/lexica/en.yml'
      expect(lexicon.bad_words).to match_array(%w(I a am an by he in it my no she since the you))
    end
  end

end