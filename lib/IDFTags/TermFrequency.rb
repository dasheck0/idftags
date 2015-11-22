
class TermFrequency

  attr_accessor :weight

  def initialize weight = :weight_raw
    raise Exception("Weight #{weight} is not defined. Available weights are #{weights}") unless weights.include? weight
    @weight = weight
  end

  def term_frequency term, document
    self.send(weight, term, document)
  end

  private

  def weights
    private_methods.select { |method|
      method.to_s.split('_').first == 'weight'
    }.map(&:to_sym)
  end

  def weight_binary term, document
    return 0 if document.nil? or term.nil?
    document.include?(term) ? 1 : 0
  end

  def weight_raw term, document
    Utilities.raw_frequency term, document
  end

  def weight_log_norm term, document
    return 0 if document.nil? or term.nil?
    Math.log(1 + weight_raw(term, document))
  end

  def weight_double_norm term, document, k = 0.5
    return 0 if document.nil? or term.nil?
    k + (1-k) * weight_raw(term, document).to_f / Utilities.max_frequency(document)
  end

end