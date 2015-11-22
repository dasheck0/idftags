require './Utilities'


class InverseDocumentFrequency

  attr_accessor :weight

  def initialize weight = :weight_inverse_frequency
    raise Exception("Weight #{weight} is not defined. Available weights are #{weights}") unless weights.include? weight
    @weight = weight
  end

  def inverse_document_frequency term, documents
    self.send(weight, term, documents)
  end

  private

  def weights
    private_methods.select { |method|
      method.to_s.split('_').first == 'weight'
    }.map(&:to_sym)
  end

  def weight_unary term, documents
    1
  end

  def weight_inverse_frequency term, documents
    return 0 if term.nil? or documents.nil? or documents.empty?
    Math.log(documents.length.to_f / (1 +Utilities.document_frequency(term, documents)))
  end

  def weight_inverse_frequency_smooth term, documents
    return 0 if term.nil? or documents.nil? or documents.empty?
    Math.log((1+documents.length.to_f) / (1+Utilities.document_frequency(term, documents)))
  end

  def weight_inverse_frequency_max term, documents

  end

  def weight_probabilistic_inverse_frequency term, documents
    return 0 if term.nil? or documents.nil? or documents.empty?
    nt = Utilities.document_frequency(term, documents)
    Math.log((documents.length.to_f - nt) / (1 + nt))

  end

end