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
      container = self.new
      attributes.each do |key,value|
        self.send(:define_method, key) do
          value
        end
      end
      self.send(:define_method, :select_from_rules) do |rules|
        result = nil
        rules.each do |rule|
          begin 
            rule_is_satisfied = eval(rule[1])
            if rule_is_satisfied
              result = rule[0]
              break
            end
          rescue
            #nasty, allows me not to define dimensions for now TODO: fix
          end
        end
        result
      end
      container.select_from_rules(@rules)
    end

 private
    def load_rules
      @table_data_block.call
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
