require 'yaml'

module IDFTags
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

    def self.from_yml filename
      if File.exist? filename
        content = YAML.load_file(filename)

        result = BadWordLexicon.new content.keys.first.to_sym
        result.traverse(content) { |node|
          result.add node
        }

        result
      end
    end

    def traverse hash, &blk
      case hash
        when Hash
          hash.each { |_, v| traverse(v, &blk) }
        when Array
          hash.each { |v| traverse(v, &blk) }
        else
          blk.call(hash)
      end

    end

  end
end