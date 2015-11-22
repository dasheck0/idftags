require '../IDFTags'
require './TermFrequency'
require './InverseDocumentFrequency'
require 'json'

challenges_raw = JSON.parse File.open('../../spec/fixtures/challenges/challenges.json').read
challenges = challenges_raw.map { |v| v['challenge'] }

[:weight_binary, :weight_raw, :weight_log_norm, :weight_double_norm].map { |tfw|

  [:weight_unary, :weight_inverse_frequency, :weight_inverse_frequency_smooth, :weight_probabilistic_inverse_frequency].map { |idfw|

    idftags = IDFTags::IDFTags.new tfw, idfw
    puts "#{tfw}, #{idfw} Tags: #{idftags.tags(challenges.first, challenges)}"
  }
}

