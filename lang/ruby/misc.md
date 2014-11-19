## instance variables

Rubyにおいて，オブジェクトのインスタンス変数は値を代入された時に現れる．

```irb
irb(main):001:0> class MyClass
irb(main):002:1>   def my_method
irb(main):003:2>     @v = 1
irb(main):004:2>   end
irb(main):005:1> end
=> :my_method
irb(main):006:0> obj = MyClass.new
=> #<MyClass:0x007f9f831927e0>
irb(main):007:0> obj.instance_variables
=> []
irb(main):008:0> obj.my_method
=> 1
irb(main):009:0> obj.instance_variables
=> [:@v]
```

`MyClass`をnewした時点では，objのinstance_variablesは何もないが，my_method実行後に`@v`が現れていることが分かる．

## path to constant

```irb
irb(main):029:0> module M
irb(main):030:1>   class C
irb(main):031:2>     X = 'a constant'
irb(main):032:2>   end
irb(main):033:1>
irb(main):034:1*   C::X
irb(main):035:1> end
=> "a constant"
irb(main):036:0> M::C::X
=> "a constant"
irb(main):037:0> M.constants
=> [:C]
irb(main):038:0> module M
irb(main):039:1>   Y = 'other constant'
irb(main):040:1>
irb(main):041:1*   class C
irb(main):042:2>     ::M::Y
irb(main):043:2>   end
irb(main):044:1> end
=> "other constant"
irb(main):045:0> M.constants
=> [:C, :Y]
```

## object

オブジェクトとは，インスタンス変数の集まりにクラスへのリンクが付いたもの．
オブジェクトのメソッドは，オブジェクトのクラスにいる．
クラスのインスタンスメソッドとも呼ばれる．
（「メタプログラミングRuby p.53」）

## class

クラスとは，オブジェクトにインスタンスメソッドの一覧とスーパークラスへのリンクが付いたもの．
ClassクラスはModuleクラスのサブクラス．
（「メタプログラミングRuby p.53」）

```irb
irb(main):050:0> Class.superclass
=> Module
```

```irb
irb(main):056:0> Object.class
=> Class
irb(main):057:0> Module.superclass
=> Object
irb(main):058:0> Class.class
=> Class
irb(main):059:0> class MyClass; end
=> nil
irb(main):060:0> obj = MyClass.new
=> #<MyClass:0x007f9f831bc888>
irb(main):061:0> obj.instance_variable_set
obj.instance_variable_set
irb(main):061:0> obj.instance_variable_set("@x", 10)
=> 10
```

## self

```irb
irb(main):001:0> class MyClass
irb(main):002:1>   def testing_self
irb(main):003:2>     @var = 10
irb(main):004:2>     my_method
irb(main):005:2>     self
irb(main):006:2>   end
irb(main):007:1>
irb(main):008:1*   def my_method
irb(main):009:2>     @var = @var + 1
irb(main):010:2>   end
irb(main):011:1> end
=> :my_method
irb(main):012:0> obj = MyClass.new
=> #<MyClass:0x007fc40420e070>
irb(main):013:0> obj.testing_self
=> #<MyClass:0x007fc40420e070 @var=11>
```

irbはmainというオブジェクトの内部から実行されている．

```irb
irb(main):016:0> self
=> main
irb(main):017:0> self.class
=> Object
```

`MyClass`のserfは当然`MyClass`

```irb
irb(main):019:0> class MyClass
irb(main):020:1>   self
irb(main):021:1> end
=> MyClass
```

### public, private

明示的な`self`を使ってprivateメソッドは呼べないが，暗黙的なレシーバ`self`なら可能．

```irb
irb(main):001:0> class A
irb(main):002:1>   def public_method
irb(main):003:2>     self.private_method
irb(main):004:2>   end
irb(main):005:1>
irb(main):006:1*   private
irb(main):007:1>
irb(main):008:1*   def private_method; end
irb(main):009:1> end
=> :private_method
irb(main):010:0> A.new.public_method
NoMethodError: private method `private_method' called for #<A:0x007fc0fb1c8838>
        from (irb):3:in `public_method'
        from (irb):10
        from /Users/hfm/.rbenv/versions/2.1.3/bin/irb:11:in `<main>'
irb(main):011:0> class B
irb(main):012:1>   def public_method
irb(main):013:2>     private_method
irb(main):014:2>   end
irb(main):015:1>
irb(main):016:1*   private
irb(main):017:1>
irb(main):018:1*   def private_method; end
irb(main):019:1> end
=> :private_method
irb(main):020:0> B.new.public_method
=> nil
```

### include order

重複したdef名がある場合，includeの順序によっては継承チェーンの関係で，想定とは異なるメソッドが呼ばれてしまう可能性がある．

```irb
irb(main):001:0> module Printable
irb(main):002:1>   def print
irb(main):003:2>     puts "print"
irb(main):004:2>   end
irb(main):005:1>
irb(main):006:1*   def prepare_cover
irb(main):007:2>     puts "prepare_cover"
irb(main):008:2>   end
irb(main):009:1> end
=> :prepare_cover
irb(main):010:0> module Document
irb(main):011:1>   def print_to_screen
irb(main):012:2>     prepare_cover
irb(main):013:2>     format_for_screen
irb(main):014:2>     print
irb(main):015:2>   end
irb(main):016:1>
irb(main):017:1*
irb(main):018:1*   def format_for_screen
irb(main):019:2>     puts "format_for_screen"
irb(main):020:2>   end
irb(main):021:1>
irb(main):022:1*   def print
irb(main):023:2>     puts "Document print"
irb(main):024:2>   end
irb(main):025:1> end
=> :print
irb(main):026:0> class Book
irb(main):027:1>   include Document
irb(main):028:1>   include Printable
irb(main):029:1>
irb(main):030:1*   puts "Book"
irb(main):031:1> end
Book
=> nil
irb(main):032:0> b = Book.new
=> #<Book:0x007ff7fc0cf548>
irb(main):033:0> b.print_to_screen
prepare_cover
format_for_screen
print
=> nil
irb(main):034:0> Book.ancestors
=> [Book, Printable, Document, Object, Kernel, BasicObject]
irb(main):043:0> class Neobook
irb(main):044:1>   include Printable
irb(main):045:1>   include Document
irb(main):046:1>
irb(main):047:1*   puts "NeoBook"
irb(main):048:1> end
NeoBook
=> nil
irb(main):049:0> n = Neobook.new
=> #<Neobook:0x007ff7fb8541e8>
irb(main):050:0> n.print_to_screen
prepare_cover
format_for_screen
Document print
=> nil
```

## call method dynamically

```irb
irb(main):001:0> class MyClass
irb(main):002:1>   def my_method(args)
irb(main):003:2>     args * 2
irb(main):004:2>   end
irb(main):005:1> end
=> :my_method
irb(main):006:0> obj = MyClass.new
=> #<MyClass:0x007fce6a852808>
irb(main):007:0> obj.my_method(3)
=> 6
irb(main):008:0> obj.send(:my_method, 3)
=> 6
```

```irb
irb(main):001:0> 1.send(:+, 3)
=> 4
```

## override method_missing

```irb
irb(main):001:0> class Lawyer
irb(main):002:1>   def method_missing(method, *args)
irb(main):003:2>     puts "#{method}(#{args.join(',')})を呼び出した"
irb(main):004:2>     puts "(ブロックを渡した)" if block_given?
irb(main):005:2>   end
irb(main):006:1> end
=> :method_missing
irb(main):007:0> bob = Lawyer.new
=> #<Lawyer:0x007fa6d39b6320>
irb(main):008:0> bob.talk_simple('a', 'b') do
irb(main):009:1*   puts "talk!"
irb(main):010:1> end
talk_simple(a,b)を呼び出した
(ブロックを渡した)
=> nil
```

### ruport

```irb
irb(main):011:0> require 'ruport'
=> true
irb(main):012:0> table = Ruport::Data::Table.new :column_names => ["country", "wine"],
irb(main):013:0*                                 :data => [["France", "Bordeaux"],
irb(main):014:1*                                           ["Italy", "Chianti"]]
=> #<Ruport::Data::Table:0x007fa6d3874fe8 @column_names=["country", "wine"], @record_class="Ruport::Data::Record", @data=[#<Ruport::Data::Record:0x007fa6d3874368 @attributes=["country", "wine"], @data={"country"=>"France", "wine"=>"Bordeaux"}>, #<Ruport::Data::Record:0x007fa6d38738c8 @attributes=["country", "wine"], @data={"country"=>"Italy", "wine"=>"Chianti"}>]>
irb(main):015:0> puts table.to_text
+--------------------+
| country |   wine   |
+--------------------+
| France  | Bordeaux |
| Italy   | Chianti  |
+--------------------+
=> nil
talk_simple(a,b)を呼び出した
(ブロックを渡した)
=> nil
irb(main):011:0> require 'ruport'
=> true
irb(main):012:0> table = Ruport::Data::Table.new :column_names => ["country", "wine"],
irb(main):013:0*                                 :data => [["France", "Bordeaux"],
irb(main):014:1*                                           ["Italy", "Chianti"]]
=> #<Ruport::Data::Table:0x007fa6d3874fe8 @column_names=["country", "wine"], @record_class="Ruport::Data::Record", @data=[#<Ruport::Data::Record:0x007fa6d3874368 @attributes=["country", "wine"], @data={"country"=>"France", "wine"=>"Bordeaux"}>, #<Ruport::Data::Record:0x007fa6d38738c8 @attributes=["country", "wine"], @data={"country"=>"Italy", "wine"=>"Chianti"}>]>
irb(main):015:0> puts table.to_text
+--------------------+
| country |   wine   |
+--------------------+
| France  | Bordeaux |
| Italy   | Chianti  |
+--------------------+
=> nil
irb(main):016:0>
irb(main):017:0* table.rows_with
table.rows_with
irb(main):017:0* table.rows_with_country("France")
=> [#<Ruport::Data::Record:0x007fa6d3874368 @attributes=["country", "wine"], @data={"country"=>"France", "wine"=>"Bordeaux"}>]
irb(main):018:0> table.rows_with_country("France").each do |row|
irb(main):019:1*   puts row.to_csv
irb(main):020:1> end
France,Bordeaux
=> [#<Ruport::Data::Record:0x007fa6d3874368 @attributes=["country", "wine"], @data={"country"=>"France", "wine"=>"Bordeaux"}>]
```

### openstruct

```irb
irb(main):023:0> icecream = OpenStruct.new
=> #<OpenStruct>
irb(main):024:0> icecream.flavor = 'ストロベリー'
=> "ストロベリー"
irb(main):025:0> icecream.flavor
=> "ストロベリー"

irb(main):001:0> class MyOpenStruct
irb(main):002:1>   def initialize
irb(main):003:2>     @attributes = {}
irb(main):004:2>   end
irb(main):005:1>
irb(main):006:1*   def method_missing(name, *args)
irb(main):007:2>     attribute = name.to_s
irb(main):008:2>     if attribute =~ /=$/
irb(main):009:3>       @attributes[attribute.chop] = args[0]
irb(main):010:3>     else
irb(main):011:3*       @attributes
irb(main):012:3>     end
irb(main):013:2>   end
irb(main):014:1> end
=> :method_missing
irb(main):015:0> icecream = MyOpenStruct.new
=> #<MyOpenStruct:0x007fbdf298b8d8 @attributes={}>
irb(main):016:0> icecream.flavor = 'バニラ'
=> "バニラ"
irb(main):017:0> icecream.flavor
=> {"flavor"=>"バニラ"}
```

### benchmark normalmethod vs ghostmethod

```ruby
2.1.5 (main)> require 'benchmark'
 => true
2.1.5 (main)> class String
2.1.5 (main)>   def method_missing(method, *args)
2.1.5 (main)>     method == :ghost_reverse ? reverse : super
2.1.5 (main)>   end
2.1.5 (main)> end
 => :method_missing
2.1.5 (main)> Benchmark.bm do |b|
2.1.5 (main)>   b.report "Normal method" do
2.1.5 (main)>     1000000.times { "abc".reverse }
2.1.5 (main)>   end
2.1.5 (main)>
2.1.5 (main)>   b.report "Ghost method" do
2.1.5 (main)>     1000000.times { "abc".ghost_reverse }
2.1.5 (main)>   end
2.1.5 (main)> end
       user     system      total        real
Normal method  0.280000   0.000000   0.280000 (  0.274860)
Ghost method  0.420000   0.000000   0.420000 (  0.423145)
 => [
    [0] #<Benchmark::Tms:0x007fc44cb71908 @label="Normal method", @real=0.27486, @cstime=0.0, @cutime=0.0, @stime=0.0, @utime=0.27999999999999997, @total=0.27999999999999997>,
    [1] #<Benchmark::Tms:0x007fc44caf21f8 @label="Ghost method", @real=0.423145, @cstime=0.0, @cutime=0.0, @stime=0.0, @utime=0.42000000000000004, @total=0.42000000000000004>
]
```

ブランクスレート

- Objectクラスよりもメソッドの少ないクラスのこと（「メタプログラミングRuby」 P97）

## CleanRoom

```irb
irb(main):001:0> class CleanRoom
irb(main):002:1>   def complex_calculation
irb(main):003:2>     # some codes
irb(main):004:2*     10
irb(main):005:2>   end
irb(main):006:1>
irb(main):007:1*   def do_something
irb(main):008:2>     # some codes
irb(main):009:2*   end
irb(main):010:1> end
=> :do_something
irb(main):011:0>
irb(main):012:0* clean_room = CleanRoom.new
=> #<CleanRoom:0x007f8162979470>
irb(main):013:0> clean_room.instance_eval do
irb(main):014:1*   if complex_calculation > 10
irb(main):015:2>     do_something
irb(main):016:2>   end
irb(main):017:1> end
=> nil
irb(main):023:0> clean_room.instance_eval do
irb(main):024:1*   if complex_calculation > 9
irb(main):025:2>     do_something
irb(main):026:2>     puts "over 9"
irb(main):027:2>   end
irb(main):028:1> end
over 9
=> nil
```

## Proc

```irb
irb(main):029:0> inc = Proc.new {|x| x + 1}
=> #<Proc:0x007f81630da8e0@(irb):29>
irb(main):030:0> inc.call(3)
=> 4
```
