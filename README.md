# IDFTags

IDFTags extracts tags (or significant words) from a string using the inverse document frequency algorithm. You can find more about this [here](https://en.wikipedia.org/wiki/Tf%E2%80%93idf#Definition)

In summary the algorithm considers a document, which is a string a and computes the weighted frequency within that document. This tells us how common the word is. In fact the more interesting value is the inverse document frequency. For this we consider a list of documents and calculate the weighted frequency of a term in all that documents. Multiply this values for the term and you have the tdidf value. Based on this value you can rank the terms of a document and pick the first n values, which are your tags.

### What is this?

This is a library to generate tags from a document based on other documents to calculate the meaning of a word. So you have to provide a list of documents to get proper results. This applies very well to titles or content of form posts (like for example stackoverflow). This gem is not meant to extract tags using self learning algorithms, which are solely based on the single document itself. Keep that in mind. There will be an example to showcase the gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'IDFTags'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install IDFTags

## Usage
### Basic 
IDFtags needs a document and a list of documents to calculate both the document frequency and inverse document freuency of terms. So let be the document and documents respectively

```ruby
document = 'This is a document'
documents = ['A sample sentence', 'Another sample sentence']
```

Then you can retrieve the three most prominent tags of the document by 

```ruby
require 'idftags'

idftags = IDFTags::IDFTags.new
tags = idftags.tags document, documents, 3
```

### Custom weights
You can also use custom weights to refine the output. This is especially useful when dealing with longer documents.

```ruby
require 'idftags'

idftags = IDFTags::IDFTags.new :weight_log_norm, :weight_probabilistic_inverse_frequency
tags = idftags.tags 'document', ['document1', 'document2']
```
Currently available weights:

| document frequency | inverse document frequency             |
|--------------------|----------------------------------------|
| weight_binary      | weight_unary                           |
| weight_raw         | weight_inverse_frequency               |
| weight_log_norm    | weight_inverse_frequency_smooth        |
| weight_double_norm | weight_probabilistic_inverse_frequency |

Take a look at https://en.wikipedia.org/wiki/Tf%E2%80%93idf#Term_frequency_2 for a more in depth explanation and recommendation of what weights you should choose.

### Bad words
Usually you want to exclude certain words from the parsing process since they do not carry any information whatsoever. An exmaple of such words are 'a', 'and', 'I', 'to' and so on. You can exclude them by providing a so called bad word lexicon. Currently we support bad word lexica by locale.

```ruby
require 'idftags'

lexicon = IDFTags::BadWordLexicon.new :en, ['a', 'to']
lexicon.add('I')
lexicon.add_all(['my', 'me'])

idftags = IDFTags::IDFTags.new 
idftags.register_bad_word_lexicon lexicon

idftags.tags 'I want to see me', [....] # -> ['see', 'want']
```
You can also create bad word lexica from yaml files.
```ruby
require 'idftags'

lexicon = IDFTags::BadWordLexicon.from_yml 'path/to/file.yml'
```
whereas a yml file should look like this
```yaml
en:
    common:
        yes: 'yes'
        no: 'no'
    test:
        nested:
            cool: 'cool'
        nested2:
            nice: 'nice'
```
To unregister a bad word lexicon simply do 
```ruby
idftags.unregister_bad_word_lexicon :en
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/IDFTags. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

