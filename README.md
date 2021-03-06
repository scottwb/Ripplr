Ripplr (Think Ripple/Solr)
======
Ripplr assists with indexing your Ripple documents stored in Riak. Ripplr currently supports simple full text indexing
using Riak's Solr capabilities. This will evolve to support 2i as well. 

Dependencies
============
Ripplr is dependant on `ripple` and `riak-client`. Ripplr is available on RubyGems and can be installed by adding `ripplr` to your Gemfile.

It's simple to use!
===================
Once you've installed the Ripplr gem using bundler you can begin setting up your Ripple Documents to be queryable.

To make a document queryable, `include Ripplr::Queryable` and then describe which fields you would like to be queryable by using a `queryable` block.

For example you can define a class as queryable like this:
```ruby
class Wod
  include Ripple::Document
  include Ripplr::Queryable
  property :description, String
  property :notes, String
  property :performed_at, Time
  
  queryable do
    text :description
    text :notes
    time :performed_at
  end
end
```
And then create, index and search for your documents like so:
```ruby
todays_wod = Wod.create :description => 'Lawnmower 8x35lbs. Sqt Jumps 10x. Lunge Twist 20x10lbs ...', :performed_at = Time.now 
todays_wod.index #add the index for your document
criteria = Wod.where(:description => "jumps") # Builds a criteria object
# Iterating over a criteria object, calling count(size, or length), or calling to_a executes the search
```

You can also limit, skip and order your search results, allowing you to paginate!
```ruby
Wod.where(:description => "plyo").limit(10) # returns up to 10 matching results
Wod.where(:description => "plyo").skip(5) # skips the first 5 results
Wod.where(:description => "plyo").order_by(:created_at).descending # orders by created_at (Field must be defined as queryable!

# Chain it all together!
Wod.where(:description => 'kick ass').limit(10).skip(10).order_by(:created_at)
```

Find more details about specifying query params in the specs: https://github.com/validas/Ripplr/blob/master/spec/ripplr/criteria_spec.rb
