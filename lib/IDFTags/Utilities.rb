
class Utilities

  def self.max_frequency document
    return 0 if document.nil? or document.empty?
    document.split.map { |term| raw_frequency(term, document) }.max
  end

  def self.raw_frequency term, document
    return 0 if term.nil? or document.nil?
    document.split.map(&:strip).select { |t| t == term }.count
  end

  def self.document_frequency term, documents
    return 0 if term.nil? or documents.nil?
    documents.select { |document|
      raw_frequency(term, document) > 0
    }.count
  end

end