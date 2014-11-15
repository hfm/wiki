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