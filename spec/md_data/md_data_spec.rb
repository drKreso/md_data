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


  it 'rules can be created with add in precondition' do
    class TestClass
      table_data do
        context "time_of_day == :morning" do
          add "8t", "year == 1994" 
        end
      end
    end
    TestClass.select(:year => 1994, :time_of_day => :morning).should == "8t"
  end

  it 'rules can be created to comapre with string' do
    class TestClass
      table_data do
        context "time_of_day == 'morning'" do
          add "8t", "year == 1995" 
          add "6t", "year == 1994" 
        end
      end
    end
    TestClass.select(:year => 1994, :time_of_day => 'morning').should == "6t"
  end

  it 'can have multiple contexts' do
    class TestClass
      table_data do
        context "time_of_day == :morning" do
          add "18t", "year == 1995" 
          add "16t", "year == 1994" 
        end
        context "time_of_day == :evening" do
          add "8t", "year == 1995" 
        end
      end
    end
    TestClass.select(:year => 1995, :time_of_day => :morning).should == "18t"
    TestClass.select(:year => 1995, :time_of_day => :evening).should == "8t"
  end

  it 'is aware of dimensions' do
    class TestClass
      dimension :year, [:year_1994, :year_1995]
      dimension :time_of_day, [:morning, :evening]
    end

    TestClass.dimensions.should == {:year => [:year_1994, :year_1995],
                                   :time_of_day => [:morning, :evening] }
  end


  it 'is creates helper methods for dimensions values' do
    class TestClass

      dimension :year, [:year_1994, :year_1995]
      dimension :time_of_day, [:morning, :evening]

      table_data do
        context "morning" do
          add "18t", "year_1995" 
          add "16t", "year_1994" 
        end
        context "evening" do
          add "8t", "year_1995" 
        end
      end
    end
    TestClass.select(:year => :year_1995, :time_of_day => :morning).should == "18t"
  end


  it 'is shuld create helper methods for dimensions even if atttibute not sent' do
    class TestClassIsolated
      include MdData
      dimension :year, [:year_1994, :year_1995]
      dimension :my_time_of_day, [:morning, :evening]

      table_data do
        context "my_time_of_day == :evening" do
          add "8t", "year_1995" 
          add "7t", "year_1994" 
        end
        context "morning" do
          add "8t", "year_1995" 
          add "6t", "year_1994" 
        end
        context "true" do
          add "16t", "year_1995" 
        end
      end

    end

    TestClassIsolated.select({:year => :year_1995}).should == "16t"
    TestClassIsolated.select({:year => :year_1995}).should == "16t"
    TestClassIsolated.select({:year => :year_1995, :my_time_of_day => :morning}).should == "8t"
    TestClassIsolated.select({:year => :year_1994, :my_time_of_day => :evening}).should == "7t"
  end


  it 'is shuld create helper methods for dimensions even if atttibute not sent and using delegator' do
    class TestClassIsolated
      include MdData
      dimension :year, [:year_1994, :year_1995]
      dimension :my_2_time_of_day, [:morning, :evening]

      table_data do
        context "my_2_time_of_day == :evening" do
          add "8t", "year_1995" 
          add "7t", "year_1994" 
        end
        context "morning" do
          add "8t", "year_1995" 
          add "6t", "year_1994" 
        end
        context "true" do
          add "16t", "year_1995" 
        end
      end

    end

    class Testing
      attr_reader :table
      def initialize
        @table = TestClassIsolated
      end
    end

    t = Testing.new
    t.table.select({:year => :year_1995}).should == "16t"
    t.table.select({:year => :year_1995}).should == "16t"
    t.table.select({:year => :year_1995, :my_2_time_of_day => :morning}).should == "8t"
    t.table.select({:year => :year_1994, :my_2_time_of_day => :evening}).should == "7t"
  end

end
