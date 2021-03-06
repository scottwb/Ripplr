module Ripplr
  class Criteria

    def initialize(klass, indexer=Ripplr::Indexers::Ripple)
      @indexer = indexer
      @target = klass
    end

    def where(condition)
      self.condition = condition
      self
    end

    def order_by(field)
      @order_by_field = @target.queryable_field(field)
      self
    end

    def limit(number_of_records)
      @limit = number_of_records
      self
    end

    def skip(number_of_rows)
      @skip = number_of_rows
      self
    end

    def ascending
      @order_by_direction = " asc"
      self
    end

    def descending
      @order_by_direction = " desc"
      self
    end

    def [](index)
      results[index]
    end

    def each(&block)
      results.each do |result|
        yield result
      end
    end

    def size
      results.size
    end
    alias :length :size
    alias :count :size

    def to_a
      results
    end

    def execute
      return Array.new if condition.nil?

      @indexer.search @target, query, options
    end

    def conditions
      condition
    end

    private
    def results
      @results ||= execute
      @results
    end

    def options
      {
        :start => @skip,
        :rows => @limit,
        :sort => ordering
      }.select{|k,v| v.present? }
    end

    def ordering
      sort = @order_by_field.to_s
      sort += @order_by_direction unless @order_by_direction.nil?
      sort
    end

    def condition
      @condition
    end

    def condition=(value)
      @condition = { @target.queryable_field(value.keys.first) => value.values.first }
    end

    def query
      "#{condition.keys.first}: \"#{condition.values.first}\""
    end

  end
end
