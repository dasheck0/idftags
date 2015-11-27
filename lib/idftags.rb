require 'IDFTags/version'
require 'IDFTags/inverse_document_frequency'
require 'IDFTags/term_frequency'
require 'IDFTags/bad_word_lexicon'

module IDFTags

  class IDFTags

    attr_accessor :tf, :idf

    def initialize td_weight = :weight_raw, idf_weight = :weight_inverse_frequency
      @tf = TermFrequency.new td_weight
      @idf = InverseDocumentFrequency.new idf_weight
      @bad_word_lexica = []
    end

    def tags document, documents, tag_count = 5
      extract_terms(document).map { |term|
        [term, tfidf(term, document, documents)]
      }.sort_by { |v| v.last}.reverse[0..(tag_count-1)].map(&:first)
    end

    def register_bad_word_lexicon bad_word_lexicon
      lexicon = @bad_word_lexica.select { |l| l.locale == bad_word_lexicon.locale }.first

      if lexicon
        lexicon.add_all bad_word_lexicon.bad_words
      else
        @bad_word_lexica << bad_word_lexicon
      end
    end

    def unregister_bad_word_lexicon locale
      @bad_word_lexica.delete_if { |l| l.locale == locale }
    end

    private

    def extract_terms document
      prepare_document(document).split.uniq - @bad_word_lexica.map{ |l| l.nil? ? [] : l.bad_words.map(&:downcase) }.flatten.uniq
    end

    def prepare_document document
      document.downcase.gsub(/(\,|\.)/, '') if document
    end

    def tfidf term, document, documents
      @idf.inverse_document_frequency(term, documents) * @tf.term_frequency(term, document)
    end

  end

end
