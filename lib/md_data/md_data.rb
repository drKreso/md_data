module MdData
  def self.included(base)
    base.extend MdDataClassMethods
  end

  module MdDataClassMethods
    def table_data(&block)
      @table_data_block = block
    end

    def select(attributes)
      @rules = []
      @current_context = nil
      load_rules
      prepared = prepare(@rules, attributes)
      pp prepared
      prepared.select { |rule| eval(rule[1]) }.map { |evaluated| evaluated[0] }[0]
    end

 private
    def load_rules
      @table_data_block.call
    end

    def prepare(rules, attributes)
      attributes.each do |key, value|
        rules.each do |rule| 
          rule[1].gsub!(key.to_s,value.to_s) 
        end
      end
      rules
    end

    def add(value, condition)
      context_condition = @current_context.nil? ? '' : " && #{@current_context} "
      @rules << ( [value , (condition + context_condition)] )
    end

    def context(condition, &block)
      @current_context = condition
      block.call
    end
    
  end
end
