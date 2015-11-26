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

end