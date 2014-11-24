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

```irb
irb(main):031:0> def math(a, b)
irb(main):032:1>   yield(a, b)
irb(main):033:1> end
=> :math
irb(main):034:0> def teach_math(a, b, &operation)
irb(main):035:1>   puts "Let's start to culculation"
irb(main):036:1>   puts math(a, b, &operation)
irb(main):037:1> end
=> :teach_math
irb(main):038:0> teach_math(2, 3) {|x, y| x * y}
Let's start to culculation
6
=> nil
irb(main):039:0> teach_math(2, 3) {|x, y| x ** y}
Let's start to culculation
8
=> nil
irb(main):040:0> teach_math(2, 3)
Let's start to culculation
LocalJumpError: no block given (yield)
	from (irb):32:in `math'
	from (irb):36:in `teach_math'
	from (irb):40
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
```

```irb
irb(main):041:0> def my_method(&the_proc)
irb(main):042:1>   the_proc
irb(main):043:1> end
=> :my_method
irb(main):044:0> my_method {|age| "I'm #{age}" }
=> #<Proc:0x007f81628a3280@(irb):44>
irb(main):045:0> age = my_method {|age| "I'm #{age}" }
=> #<Proc:0x007f81630f1fe0@(irb):45>
irb(main):046:0> age.class
=> Proc
irb(main):047:0> age.call(20)
=> "I'm 20"
```

### proc to block

```irb
irb(main):048:0> my_age = proc { '20' }
=> #<Proc:0x007f81630b3998@(irb):48>
irb(main):049:0> def my_method(name)
irb(main):050:1>   puts "#{name} is #{yield}"
irb(main):051:1> end
=> :my_method
irb(main):053:0> my_method("Bob", &my_age)
Bob is 20
=> nil
```

- highlignはコンソールの入出力を自動化するgem

```irb
irb(main):054:0> require 'highline'
=> true
irb(main):055:0> hl = HighLine.new
=> #<HighLine:0x007f81629e7588 @input=#<IO:<STDIN>>, @output=#<IO:<STDOUT>>, @multi_indent=true, @indent_size=3, @indent_level=0, @wrap_at=nil, @page_at=nil, @question=nil, @answer=nil, @menu=nil, @header=nil, @prompt=nil, @gather=nil, @answers=nil, @key=nil>
irb(main):056:0> ages = hl.ask("Input your age", lambda {|age| age.split(',')})
Input your age
20,30,40
=> ["20", "30", "40"]
irb(main):057:0> ages
=> ["20", "30", "40"]
irb(main):058:0> ages.class
=> Array
```

### proc vs lambda

#### return (part1: lambda)

```irb
irb(main):059:0> def my_method(object)
irb(main):060:1>   object.call * 2
irb(main):061:1> end
=> :my_method
irb(main):062:0> l = lambda { return 5 }
=> #<Proc:0x007f81648ea458@(irb):62 (lambda)>
irb(main):063:0> my_method(l)
=> 10
irb(main):064:0> p = Proc.new { return 5 }
=> #<Proc:0x007f81648d5620@(irb):64>
irb(main):065:0> my_method(p)
LocalJumpError: unexpected return
	from (irb):64:in `block in irb_binding'
	from (irb):60:in `call'
	from (irb):60:in `my_method'
	from (irb):65
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
irb(main):075:0> p = Proc.new { 5 }
=> #<Proc:0x007f8163068ba0@(irb):75>
irb(main):076:0> my_method(p)
=> 10
```

returnがあるとLocalJumpErrorで死ぬ（トップレベルスコープからは戻る場所が無い）

#### return (part2: Proc)

```irb
irb(main):067:0* def another_my_method
irb(main):068:1>   p = Proc.new { return 5 }
irb(main):069:1>   result = p.call
irb(main):070:1>   return result * 2
irb(main):071:1> end
=> :another_my_method
irb(main):072:0> another_my_method
=> 5
```

5になっちゃう（`p`がcallされた時点でスコープから抜け出すため，`return result * 2`に届いていない）

### Kernel#proc

```irb
irb(main):078:0> proc { return }.call
LocalJumpError: unexpected return
	from (irb):78:in `block in irb_binding'
	from (irb):78:in `call'
	from (irb):78
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
```

### method

```irb
irb(main):001:0> class MyClass
irb(main):002:1>   def initialize(value)
irb(main):003:2>     @x = value
irb(main):004:2>   end
irb(main):005:1>
irb(main):006:1*   def my_method
irb(main):007:2>     @x
irb(main):008:2>   end
irb(main):009:1> end
=> :my_method
```

↑で普通のクラスを作って，↓でMethodオブジェクトを取り出す．

```irb
irb(main):011:0> object = MyClass.new(1)
=> #<MyClass:0x007ff16a834bf0 @x=1>
irb(main):012:0> m = object.method :my_method
=> #<Method: MyClass#my_method>
irb(main):013:0> m.call
=> 1
irb(main):014:0> m.class
=> Method
```

Methodオブジェクトは属するオブジェクトのスコープで評価される．

また，unbindで`UnboundMethod`オブジェクトを取り出し，UnboundMethodオブジェクトに再びbindすることも出来る．

```irb
irb(main):021:0* unbound = m.unbind
=> #<UnboundMethod: MyClass#my_method>
irb(main):022:0> another_object = MyClass.new(2)
=> #<MyClass:0x007ff16b041fa0 @x=2>
irb(main):023:0> m = unbound.bind(another_object)
=> #<Method: MyClass#my_method>
irb(main):024:0> m.call
=> 2
```

ただし，元のオブジェクトと同じクラスにしか使えず，別のクラスをbindしようとするとTypeErrorが生じた．

```irb
irb(main):037:0> m = unbound.bind(another_object)
TypeError: bind argument must be an instance of MyClass
	from (irb):37:in `bind'
	from (irb):37
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
```

## class definition

rubyにおいて，classキーワードは，オブジェクトの動作を規定することではなくコードを実行すること．

## method

### class method

`class << self`するとclassメソッド使えた．
http://magazine.rubyist.net/?0046-SingletonClassForBeginners#l3

```irb
irb(main):001:0> class Clazz
irb(main):002:1>   class << self
irb(main):003:2>     def hello
irb(main):004:3>       puts "hello world"
irb(main):005:3>     end
irb(main):006:2>   end
irb(main):007:1> end
=> :hello
irb(main):008:0> Clazz.hello
hello world
=> nil
irb(main):009:0> Clazz.hello
hello world
=> nil
irb(main):010:0> class Clazzz
irb(main):011:1>   def hello
irb(main):012:2>     puts "hello world"
irb(main):013:2>   end
irb(main):014:1> end
=> :hello
irb(main):015:0> Clazzz.hello
NoMethodError: undefined method `hello' for Clazzz:Class
	from (irb):15
	from /Users/usr0600296/.rbenv/versions/2.1.4/bin/irb:11:in `<main>'
```

### class instance variables

```irb
irb(main):001:0> class MyCLass
irb(main):002:1>   @my_var = 1
irb(main):003:1> end
=> 1
```

```irb
irb(main):004:0> class MyClass
irb(main):005:1>   @my_var = 1
irb(main):006:1>
irb(main):007:1*   def self.read
irb(main):008:2>     @my_var
irb(main):009:2>   end
irb(main):010:1>
irb(main):011:1*   def write
irb(main):012:2>     @my_var = 2
irb(main):013:2>   end
irb(main):014:1>
irb(main):015:1*   def read
irb(main):016:2>    @my_var
irb(main):017:2>   end
irb(main):018:1> end
=> :read
irb(main):019:0> object = MyClass.new
=> #<MyClass:0x007ff80287f440>
irb(main):020:0> object.read
=> nil
irb(main):021:0> object.write
=> 2
irb(main):022:0> object.read
=> 2
irb(main):024:0> MyClass.read
=> 1
```

#### class variables

```irb
irb(main):038:0> class MyClass3rd < MyClass2nd
irb(main):039:1>   def my_method
irb(main):040:2>     @@var
irb(main):041:2>   end
irb(main):042:1> end
=> :my_method
irb(main):043:0> MyClass3rd.new.my_method
=> 1
irb(main):044:0> class MyClass4st < MyClass3rd
irb(main):045:1>   @@var = 2
irb(main):046:1> end
=> 2
irb(main):047:0> MyClass3rd.new.my_method
=> 2
irb(main):050:0> MyClass4st.new.my_method
=> 2
```

クラス変数はクラスではなくクラス階層に属していることが分かる．

## minitest

```rb
class Loan
  def initialize(book)
    @book = book
    @time = Loan.time_class.now
  end

  def self.time_class
    @time_class || Time
  end

  def to_s
    "#{@book.upcase} loaned on #{@time}"
  end
end
```

```rb
class FakeTime
  def self.now
    'Sun Nov 23 18:19:00'
  end
end

require_relative 'book'
require 'minitest/autorun'

class TestLoan < Minitest::Test
  def test_conversion_to_string
    Loan.instance_eval { @time_class = FakeTime }
    loan = Loan.new('War and Peace')
    assert_equal 'WAR AND PEACE loaned on Sun Nov 23 18:19:00', loan.to_s
  end
end
```

```console
$ ruby book_test.rb
Run options: --seed 5712

# Running:

.

Finished in 0.001332s, 750.7508 runs/s, 750.7508 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

### Class.new

```irb
irb(main):001:0> c = Class.new(Array) do
irb(main):002:1*   def my_method
irb(main):003:2>     'Hello!'
irb(main):004:2>   end
irb(main):005:1> end
=> #<Class:0x007f850b080ce0>
irb(main):006:0> MyClass = c
=> MyClass
irb(main):007:0> MyClass.new.my_method
=> "Hello!"
```

## singleton method

```irb
irb(main):008:0> str = 'just a regular string'
=> "just a regular string"
irb(main):009:0> def str.title?
irb(main):010:1>   self.upcase == self
irb(main):011:1> end
=> :title?
irb(main):012:0> str.title?
=> false
irb(main):014:0> str.methods.grep /title?/
=> [:title?]
irb(main):015:0> str.singleton_methods
=> [:title?]
```

## Class macro

### attr_accessor

ミミックメソッドとattr_accessorを比べてみる

```irb
irb(main):001:0> class MyClass
irb(main):002:1>   def my_attribute=(value)
irb(main):003:2>     @my_attribute = value
irb(main):004:2>   end
irb(main):005:1>
irb(main):006:1*   def my_attribute
irb(main):007:2>     @my_attribute
irb(main):008:2>   end
irb(main):009:1> end
=> :my_attribute
irb(main):010:0> object = MyClass.new
=> #<MyClass:0x007fb321992e98>
irb(main):011:0> object.my_attribute = 'x'
=> "x"
irb(main):012:0> object.my_attribute
=> "x"
```

```irb
irb(main):001:0> class MyClass
irb(main):002:1>   attr_accessor :my_attribute
irb(main):003:1> end
=> nil
irb(main):004:0> object = MyClass.new
=> #<MyClass:0x007fa3628b7e20>
irb(main):005:0> object.my_attribute = 'x'
=> "x"
irb(main):006:0> object.my_attribute
=> "x"
```

## deprecate method

```irb
irb(main):014:0> class MyClass
irb(main):015:1>   def self.deprecate(old_method, new_method)
irb(main):016:2>     define_method(old_method) do |*args, &block|
irb(main):017:3*       warn "Warning: #{old_method}() is deprecated. Use #{new_method}()."
irb(main):018:3>       send(new_method, *args, &block)
irb(main):019:3>     end
irb(main):020:2>   end
irb(main):021:1>
irb(main):022:1*   def title
irb(main):023:2>   end
irb(main):024:1>
irb(main):025:1*   deprecate :GetTitle, :title
irb(main):026:1> end
=> :GetTitle
irb(main):027:0> MyClass.new.GetTitle
Warning: GetTitle() is deprecated. Use title().
=> nil
```

```irb
irb(main):001:0> object = Object.new
=> #<Object:0x007ff3b41a34c0>
irb(main):002:0> eigenclass = class << object
irb(main):003:1>   self
irb(main):004:1> end
=> #<Class:#<Object:0x007ff3b41a34c0>>
irb(main):005:0> eigenclass.class
=> Class
irb(main):006:0> def object.my_singleton
irb(main):007:1> end
=> :my_singleton
irb(main):009:0> eigenclass.instance_methods.grep /my_/
=> [:my_singleton]
```

### eigenclass 

```irb
irb(main):001:0> class C
irb(main):002:1>   def a_method
irb(main):003:2>     'C#a_method()'
irb(main):004:2>   end
irb(main):005:1> end
=> :a_method
irb(main):006:0> class D < C; end
=> nil
irb(main):007:0> object = D.new
=> #<D:0x007fd0728968a0>
irb(main):008:0> class << object
irb(main):009:1>   def a_singleton_method
irb(main):010:2>     'object#a_singleton_method()'
irb(main):011:2>   end
irb(main):012:1> end
=> :a_singleton_method
irb(main):013:0> class Object
irb(main):014:1>   def eigenclass
irb(main):015:2>     class << self
irb(main):016:3>       self
irb(main):017:3>     end
irb(main):018:2>   end
irb(main):019:1> end
=> :eigenclass
irb(main):020:0> object.eigenclass
=> #<Class:#<D:0x007fd0728968a0>>
irb(main):021:0> object.eigenclass.superclass
=> D
```

```
                     +----------+
                     |  Object  |
                     +----------+
                          ^
                     +----------+
                     |    C     |
                     + -------- +
                     | a_method |
                     +----------+
                          ^
                        +---+
                        | D |
                        +---+
                          ^
               +--------------------+
+--------+     |       #object      |
| object | --> + ------------------ +
+--------+     | a_singleton_method |
               +--------------------+
出典：「メタプログラミングRuby」p.162 図4-4 メソッド探索と特異クラスより
```

## eigenclass and inheritance

```irb
irb(main):001:0> class C
irb(main):002:1>   class << self
irb(main):003:2>     def a_class_method
irb(main):004:3>       'C.a_class_method()'
irb(main):005:3>     end
irb(main):006:2>   end
irb(main):007:1> end
=> :a_class_method
irb(main):008:0> class Object
irb(main):009:1>   def eigenclass
irb(main):010:2>     class << self
irb(main):011:3>       self
irb(main):012:3>     end
irb(main):013:2>   end
irb(main):014:1> end
=> :eigenclass
irb(main):015:0> C.eigenclass
=> #<Class:C>
irb(main):016:0> class D < C; end
=> nil
irb(main):017:0> D.eigenclass
=> #<Class:D>
irb(main):018:0> D.eigenclass.superclass
=> #<Class:C>
irb(main):019:0> C.eigenclass.superclass
=> #<Class:Object>
```

```
                     +----------+     +----------------+
                     |  Object  | --> |     #Object    |
                     +----------+     +----------------+
                          ^s                  ^s
                     +----------+     +----------------+
                     |    C     |     |       #C       |
                     + -------- + --> + -------------- +
                     | a_method |     | a.class_method |
                     +----------+     +----------------+
                          ^s                  ^s
                        +---+       c       +----+
                        | D | ------------> | #D |
                        +---+               +----+
                          ^s
               +--------------------+      s: superclass
+--------+     |       #object      |      c: (eigen)class
| object | --> + ------------------ +
+--------+     | a_singleton_method |
               +--------------------+
出典：「メタプログラミングRuby」p.163 図4-5 クラスの特異クラス
```

## Ruby Seven Rule

メタプログラミングRuby p.164-165より引用

1. オブジェクトは1種類しかない．それが通常のオブジェクトかモジュールになる．
1. モジュールは1種類しかない　．それが通常のモジュール，クラス，特異クラス，プロキシクラスのいずれかになる．
1. メソッドは1種類しかない．メソッドはモジュール（大半はクラス）に住んでいる．
1. 全てのオブジェクトは，クラスも含め，「本物のクラス」を持っている．それは，通常のクラスか特異クラスになる
1. すべてのクラスはスーパークラスを持っている．ただし，BasicObjectにはスーパークラスは無い．あらゆるクラスがBasicObjectに向かって1本の継承チェーンを持っている．
1. オブジェクトの特異クラスのスーパークラスは，オブジェクトのクラスである．クラスの特異クラスのスーパークラスはクラスのスーパークラスの特異クラスである．
1. メソッドを呼び出す時，Rubyはレシーバの本物のクラスに向かって「右へ」進み，継承チェーンを「上へ」進む．

## module and eigenclass

- クラスがモジュールをインクルードすると，モジュールのインスタンスメソッドが手に入る．
  - クラスメソッドではない
  - クラスメソッドはモジュールの特異クラスの中にいる

```irb
irb(main):001:1> module MyModule
irb(main):002:1>   def self.my_method
irb(main):003:2>     'hello'
irb(main):004:2>   end
irb(main):005:1> end
=> :my_method
irb(main):006:0> class MyClass
irb(main):007:1>   class << self
irb(main):008:2>     include MyModule
irb(main):009:2>   end
irb(main):010:1> end
=> #<Class:MyClass>
irb(main):011:0> MyClass.my_method
NoMethodError: undefined method `my_method' for MyClass:Class
	from (irb):11
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
```

- MyClassの特異クラスのインスタンスメソッド`my_method`は，MyClassのクラスメソッドである．
  - クラス拡張と呼ばれる技術

### Object#extend

```irb
irb(main):001:0> module MyModule
irb(main):002:1>   def my_method
irb(main):003:2>     'hello'
irb(main):004:2>     end
irb(main):005:1>   ned
irb(main):006:1>   end
NameError: undefined local variable or method `ned' for MyModule:Module
	from (irb):5:in `<module:MyModule>'
	from (irb):1
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
irb(main):007:0> module MyModule
irb(main):008:1>   def my_method
irb(main):009:2>     'hell'
irb(main):010:2>     end
irb(main):011:1>   end
=> :my_method
irb(main):012:0> object = Object.new
=> #<Object:0x007ffb9b87a818>
irb(main):013:0> object.extend MyModule
=> #<Object:0x007ffb9b87a818>
irb(main):014:0> object.my_method
=> "hell"
irb(main):015:0> class MyClass
irb(main):016:1>   extend MyModule
irb(main):017:1>   end
=> MyClass
irb(main):018:0> MyClass.my_method
=> "hell"
```

## alias

- aliasを使えば再定義されたメソッドの，元のメソッドも呼び出せる

```irb
irb(main):019:0> class String
irb(main):020:1>   alias :real_length :length
irb(main):021:1>
irb(main):022:1*   def length
irb(main):023:2>     real_length > 5 ? 'long' : 'short'
irb(main):024:2>   end
irb(main):025:1> end
=> :length
irb(main):026:0> 'War and Peace'.length
=> "long"
irb(main):027:0> 'War and Peace'.real_length
=> 13
```

## around alias

- sample:
  - https://github.com/rubygems/rubygems/blob/v1.3.3/lib/rubygems/custom_require.rb

`gem_original_require`というaliasで元の`require`を呼び出せるようにしている．
で，再定義した`require`の最初で`gem_original_require`を呼び出し，ダメならrescueで拾う．なるほど．

```rb
module Kernel
  ...
  alias gem_original_require require
  ...

  def require(path) # :doc:
    gem_original_require path
  rescue LoadError => load_error
    if load_error.message =~ /#{Regexp.escape path}\z/ and
       spec = Gem.searcher.find(path) then
      Gem.activate(spec.name, "= #{spec.version}")
      gem_original_require path
    else
      raise load_error
    end
  end
  ...
end
```

### private and alias

```irb
irb(main):028:0> class C
irb(main):029:1>   def x; 'OK'; end
irb(main):030:1>
irb(main):031:1*   alias :y :x
irb(main):032:1>   private :x
irb(main):033:1> end
=> C
irb(main):034:0> C.new.y
=> "OK"
irb(main):035:0> C.new.x
NoMethodError: private method `x' called for #<C:0x007ffb9d84d618>
	from (irb):35
	from /Users/hfm/.rbenv/versions/2.1.5/bin/irb:11:in `<main>'
```

- around aliasはいわゆるモンキーパッチで，既存のコードを壊す可能性があるので注意
- around aliasは２度読み込むと，メソッド呼び出し時に例外が発生する可能性がある

### custom Fixnum#+()

メタプログラミングRuby p176のテストコードを書いてみたけど，test-unit使ってテストしようとすると，test-unit中のFixnumが壊れてテスト出来ない...とほほ

```ruby
class Fixnum
  alias :old_plus :+

  def +(value)
    self.old_plus(value).old_plus(1)
  end
end

require 'test/unit'

class TestBrokenPlus < Test::Unit::TestCase
  def test_broken_plus
    assert_equal 3, 1 + 1
    assert_equal 1, -1 + 1
    assert_equal 110, 100 + 10
  end
end
```


## eval

```irb
irb(main):009:0> eval "@x", b
=> 1
irb(main):010:0> eval("[10, 20] << 30")
=> [10, 20, 30]
```

### eval family: instance_eval

```irb
irb(main):012:0> arr = ['a', 'b']
=> ["a", "b"]
irb(main):013:0> arr.instance_eval "self[2] = 'c'"
=> "c"
irb(main):014:0> arr
=> ["a", "b", "c"]
```

### test

```ruby
require 'test/unit'

class Person
end

class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    add_checked_attribute(Person, :age)
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end
  
  def test_refuses_nil_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = nil
    end
  end

  def test_refuses_false_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = false
    end
  end
end

# use eval()
def add_checked_attribute(clazz, attribute)
  eval "
    class #{clazz}
      def #{attribute}=(value)
        raise 'Invalid attribute' unless value
        @#{attribute} = value
      end
    end

    def #{attribute}()
      @#{attribute}
    end
  "
end

# use class_eval
def add_checked_attribute(clazz, attribute)
  clazz.class_eval do
    define_method "#{attribute}=" do |value|
      raise 'Invalid attribute' unless value
      instance_variable_set("@#{attrubite}", value)
    end

    define_method "#{attribute}" do
      instance_variable_get "@#{attrubite}"
    end
  end
end
```

上のやつを改良して，validationを追加したもの

```ruby
require 'test/unit'

class Person
end

class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    add_checked_attribute(Person, :age) { |v| v >= 18 }
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_invalid_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = 17
    end
  end
end

def add_checked_attribute(clazz, attribute, &validation)
  clazz.class_eval do
    define_method "#{attribute}=" do |value|
      raise 'Invalid attribute' unless validation.call(value)
      instance_variable_set("@#{attribute}", value)
    end

    define_method "#{attribute}" do
      instance_variable_get "@#{attribute}"
    end
  end
end
```

attr_checkedメソッド

```ruby
require 'test/unit'

class Class
  def attr_checked(attribute, &validation)
    define_method "#{attribute}=" do |value|
      raise 'Invalid attribute' unless validation.call(value)
      instance_variable_set("@#{attribute}", value)
    end

    define_method "#{attribute}" do
      instance_variable_get "@#{attribute}"
    end
  end
end

class Person
  attr_checked :age do |v|
    v >= 18
  end
end

class TestCheckedAttributes < Test::Unit::TestCase
  def setup
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_invalid_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = 17
    end
  end
end
```

## Binding

```irb
n):001:0> class MyClass
irb(main):002:1>   def my_method
irb(main):003:2>     @x = 1
irb(main):004:2>     binding
irb(main):005:2>     end
irb(main):006:1>   end
=> :my_method
irb(main):007:0> MyClass.new.my_method
=> #<Binding:0x007fe65a9a1da0>
irb(main):008:0> b = MyClass.new.my_method
=> #<Binding:0x007fe65a9df380>
```

## hook method

### Class#inherited()

- Class#inherited()はデフォルトでは何もしない

```irb
irb(main):001:0> class String
irb(main):002:1>   def self.inherited(subclass)
irb(main):003:2>     puts "#{self} inherited #{subclass}"
irb(main):004:2>   end
irb(main):005:1> end
=> :inherited
irb(main):006:0> class MyString < String; end
String inherited MyString
=> nil
```

### Module#included()

```irb
irb(main):001:0> module M
irb(main):002:1>   def self.included(mod)
irb(main):003:2>     puts "#{self} included in #{mod}"
irb(main):004:2>     end
irb(main):005:1>   end
=> :included
irb(main):006:0> module Enumerable
irb(main):007:1>   include M
irb(main):008:1>   end
M included in Enumerable
=> Enumerable
irb(main):009:0> class C
irb(main):010:1>   include M
irb(main):011:1>   end
M included in C
=> C
```

```irb
irb(main):001:0> module M; end
=> nil
irb(main):002:0> class C
irb(main):003:1>   def self.include(*modules)
irb(main):004:2>     puts "Called: C.include(#{modules})"
irb(main):005:2>     super
irb(main):006:2>   end
irb(main):007:1>
irb(main):008:1*   include M
irb(main):009:1> end
Called: C.include([M])
=> C
```

### Module#extend_object()

- Module#method_added()
- Module#method_removed()
- Module#method_undefined()

```irb
irb(main):006:0> module M
irb(main):007:1>   def self.method_added(method)
irb(main):008:2>     puts "New method: M##{method}"
irb(main):009:2>   end
irb(main):010:1>
irb(main):011:1*   def my_method; end
irb(main):012:1> end
New method: M#my_method
=> :my_method
```

### 