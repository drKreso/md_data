module MdData
  #raise this if you cant find appropriate rule
  class NoRuleFound < StandardError ; end

  def self.included(base)
    base.extend MdDataClassMethods
  end

  def attributes
    @attributes
  end

  def attributes=(value)
    @attributes = value
  end

  def define_helpers_methods(dimensions, attributes)
    dimensions.merge(attributes).each_key { |key| define_helper(key) }
  end

  def define_helper(key)
    Kernel.send(:define_method, key) do
      (instance_variable_get "@attributes")[key]
    end
  end
  
  module MdDataClassMethods
    def table_data(&block)
      @table_data_block = block
    end

    def select(attributes, parent = nil)
      @rules = []
      @current_context = nil
      load_rules
      if (parent.nil?)
        container = self.new
      else
        container = self.new(parent)
      end
      container.attributes = attributes
      container.define_helpers_methods(dimensions, attributes)
      define_dimension_values_methods
      define_select_from_rules
      container.select_from_rules(@rules)
    end

    def dimension(name, allowed_values)
      dimensions[name] = allowed_values
    end

    def dimensions
      @dimensions ||= {}
    end

    private
    def load_rules
      @table_data_block.call
    end

    def add(value, condition)
      if @current_context.nil?
        context_condition = ''
      else
        context_condition = " && #{@current_context} "
      end
      @rules << ( [value , (condition + context_condition)] )
    end

    def context(condition, &block)
      @current_context = condition
      block.call
    end


    def define_dimension_values_methods
      unless @dimensions.nil?
        @dimensions.each do |name, values|
          values.each { |value| equal?(name, value) }
        end
      end
    end

    def equal?(name, value)
      self.send(:define_method, value) do
        instance_eval "#{name} == :#{value}"
      end
    end

    def define_select_from_rules
      self.send(:define_method, :select_from_rules) do |rules|
        result = nil
        rules.each do |rule|
          rule_is_satisfied = instance_eval(rule[1])
          if rule_is_satisfied
            result = rule[0]
            break
          end
        end
        result.nil? ? raise(NoRuleFound.new('No rule found')) : result
      end
    end
  end #MdDataClassMethods
end #MdData
