#md_data

This is easy notation for describing multidimensional data.

For example:

```
1994      
  BuenosAires
    Coal
      19t
    Potassium
      5t
1995 
  BuenosAires
    Coal  
      8t
    Potassium
      6t
```

This can be written down as:
```
class MaterialConsumption
  include MdData

   table_data do
     context "year == 1994, city == :buenos_aires" do
       add "8t", "meterial == :coal"
       add "5t", "meterial == :potassium"
     end

     context "year == 1995, city == :buenos_aires" do
       add "8t", "meterial == :coal"
       add "5t", "meterial == :potassium"
     end
   end
end

MaterialConsumption.select(:year => 1994, :city => :buenos_aires, :material => :coal) #=> '8t'
```

## Installation

Add this line to your application's Gemfile:

    gem 'md_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install md_data

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
