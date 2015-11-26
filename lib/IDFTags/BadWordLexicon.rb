
class BadWordLexicon

  attr_accessor :locale
  attr_reader :bad_words

  def initialize locale, bad_words = []
    @locale = locale
    @bad_words = bad_words
  end

  def add bad_word
    @bad_words << bad_word if bad_word
    @bad_words.uniq!
  end

  def add_all bad_words
    @bad_words += bad_words if bad_words
    @bad_words.uniq!
  end

end