require 'md_data'

describe MdData do

  class TestClass; include MdData end

  it 'adds table_data class method when included' do
    TestClass.respond_to?(:table_data).should == true
  end

  it 'adds select class method when included' do
    TestClass.respond_to?(:select).should == true
  end

  it 'should store block for latter usage and allow change' do
    class TestClass
      table_data { "LATER" }
    end
    TestClass.send(:load_rules).should == "LATER"
    class TestClass
      table_data { "ALIGATOR" }
    end
    TestClass.send(:load_rules).should == "ALIGATOR"
  end

  it 'should create pull out item based on rules and attributes' do
    class TestClass
      table_data { [ ["year == 1994", "8t"] ] }
    end
    TestClass.select(:year => 1994).should == "8t"
  end

  it 'item can be anythinig' do
    class TestClass
      table_data { [ ["year == 1994", TestClass.new ] ] }
    end
    TestClass.select(:year => 1994).class.should == TestClass
  end

end


# class MaterialConsumption
#   include MdData
# 
#    table_data do
#      context "year == 1994, city == :buenos_aires" do
#        add "8t", "meterial == :coal"
#        add "5t", "meterial == :potassium"
#      end
# 
#      context "year == 1995, city == :buenos_aires" do
#        add "8t", "meterial == :coal"
#        add "5t", "meterial == :potassium"
#      end
#    end
# end
# 
# MaterialConsumption.select(:year => 1994, :city => :buenos_aires, :material => :coal) #=> '8t'
