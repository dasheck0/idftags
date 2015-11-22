require 'IDFTags/version'
require 'IDFTags/InverseDocumentFrequency'
require 'IDFTags/TermFrequency'

module IDFTags

  class IDFTags

    attr_accessor :tf, :idf

    def initialize td_weight = :weight_raw, idf_weight = :weight_inverse_frequency
      @tf = TermFrequency.new td_weight
      @idf = InverseDocumentFrequency.new idf_weight
    end

    def tags document, documents, tag_count = 5
      (prepare_document(document).split.uniq).map { |term|
        [term, tfidf(term, document, documents)]
      }.sort_by { |v| v.last}.reverse[0..(tag_count-1)].map(&:first)
    end

    private

    def prepare_document document
      document.downcase.gsub(/(\,|\.)/, '') if document
    end

    def tfidf term, document, documents
      @idf.inverse_document_frequency(term, documents) * @tf.term_frequency(term, document)
    end

  end

end
