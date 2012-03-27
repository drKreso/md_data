#md_data

An easy notation for describing multidimensional data.

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

Can be written down as:

```
class MaterialConsumption
  include MdData

  dimension :year, [:year_1994, :year_1995]
  dimension :city, [:buenos_aires, :zagreb]
  dimension :material, [:coal, :potassium]

  table_data do
    context 'year_1994 && buenos_aires' do
      add '8t', 'coal'
      add '5t', 'potassium'
    end
    context 'year_1995 && buenos_aires' do
      add '8t', 'coal'
      add '5t', 'potassium'
    end
  end
end

MaterialConsumption.select(:year => 1994, :city => :buenos_aires, :material => :coal) #=> '8t'
```
##Usage
By defining dimensions you get helper methods that can be used in 'context' and 'add' conditionals.

```
context 'year_1994 && buenos_aires'  do
  add '8t', 'coal'
end

```

eqauls

```
context 'year == :year_1994 && city == :buenos_aires' do
  add '8t', 'material == :coal'
end
```

Important thing here is that this is still just Ruby in quotes. You can add any conditionals that you need
while you still have basic scenario covered and simplified.

##Usage
For any type of ruled based queryingr, when you want to pull out specific data based on attributes and rules.

## Installation

Add this line to your application's Gemfile:

    gem 'md_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install md_data

## Limitations

* No nested context allowed(yet)
* Tests for misformed data definition
* Support for same dimension instance value and resolving of ambiguity

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
