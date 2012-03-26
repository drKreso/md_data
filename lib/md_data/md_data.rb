module MdData
  def self.included(base)
    base.extend MdDataClassMethods
  end

  module MdDataClassMethods
    def table_data(&block)
      @table_data_block = block
    end

    def select(attributes)
      rules = load_rules
      prepared = prepare(rules, attributes)
      prepared.select { |rule| eval(rule[0]) }.map { |evaluated| evaluated[1] }[0]
    end

 private
    def load_rules
      @table_data_block.call
    end

    def prepare(rules, attributes)
      attributes.each do |key, value|
        rules.each do |rule| 
          rule[0].gsub!(key.to_s,value.to_s) 
        end
      end
      rules
    end
  end
end
