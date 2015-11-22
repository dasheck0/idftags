
class Utilities

  def self.max_frequency document
    return 0 if document.nil? or document.empty?
    document.split.map { |term| raw_frequency(term, document) }.max
  end

  def self.raw_frequency term, document
    return 0 if term.nil? or document.nil?
    document.split.map(&:strip).select { |t| t == term }.count
  end

end