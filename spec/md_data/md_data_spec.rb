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

  it 'rules can be created with add' do
    class TestClass
      table_data { add "8t", "year == 1994" }
    end
    TestClass.select(:year => 1994).should == "8t"
  end

  it 'multiple rules can be created with add' do
    class TestClass
      table_data do
        add "8t", "year == 1994" 
        add "9t", "year == 1995"
      end
    end
    TestClass.select(:year => 1994).should == "8t"
    TestClass.select(:year => 1995).should == "9t"
  end

  it 'should create pull out item based on rules and attributes' do
    class TestClass
      table_data { add "8t" , "year == 1994" }
    end
    TestClass.select(:year => 1994).should == "8t"
  end

  it 'item can be anythinig' do
    class TestClass
      table_data { add TestClass.new , "year == 1994" }
    end
    TestClass.select(:year => 1994).class.should == TestClass
  end


  it 'rules can be created with add in context' do
    class TestClass
      table_data do
        context "time_of_day == :morning" do
          add "8t", "year == 1994" 
        end
      end
    end
    TestClass.select(:year => 1994, :time_of_day => :morning).should == "8t"
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
