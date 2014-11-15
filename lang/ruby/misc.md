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