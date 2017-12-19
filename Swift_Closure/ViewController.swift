//
//  ViewController.swift
//  Swift_Closure
//
//  Created by meitianhui2 on 2017/12/12.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    typealias AddClosure = (Int,Int) ->(Int)
    
    var x = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        //
//        closureFundation()
        testClosureCaptureStaticValue()
//        //
//        testTrailingClosure()
//        //
//        testCaptureValue()
//        // 测试 逃逸闭包
//        testEscapingClosure()
//        // 测试 自动闭包
//        testAutomaticClosure()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Closure Foundation  闭包的定义
    private func closureFundation() {
        
        //
        let calAdd:(Int,Int) ->(Int) = {
            (a:Int,b:Int) -> Int in
             return a + b
        }
        //
        print(calAdd(100,150))
        
        //单行表达式闭包可以隐式返回，如下，省略return
        let calAdd3:(Int,Int) ->(Int) = {
            (a,b) in a+b;
        }
        print(calAdd3(100,150))
        
        //单行表达式闭包 非隐式返回，如下 不省略return
        let calAdd4:(Int,Int) ->(Int) = {
            (a,b) in return a+b;
        }
        print(calAdd4(100,150))
        
        // 省略括号 不省略 return
        let calAdd2:(Int,Int) ->(Int) = {
            a,b in  return a+b
        }
        print(calAdd2(100,150))
        
        // 省略括号 省略 return
        let calAdd6:(Int,Int) ->(Int) = {
            a,b in a+b
        }
        print(calAdd6(100,150))
        
        //如果闭包没有参数，可以直接省略“in”
        let calAdd5:() ->Int = {
            return 100+150;
        }
        print(calAdd5())
        
        //  没有参数的情形 省略 in
        let calAdd7:() ->Void = {
            print("Hello World");
        }
        calAdd7()
        
        // 使用 typealias 的类型
        let Add:AddClosure = {
            a,b in  a+b
        }
        let result = Add(100,150)
        print("result = \(result)")
        
    }
    
    //MARK: - 尾随闭包
    func testTrailingClosure()  {
        //
        trailingClosure(testBlock: {
            print("正常写法 没省略()")  // 和 OC 中的Block 写法类似
        })
        // closure 没有参数没有返回值
        trailingClosure {
            print("这是 尾随闭包的推荐写法 省略形式参数标签 ,省略()")
        }
        
        // 尾随闭包 有返回值 不能省略 ()
        trailingClosureTwo(amout: 3) { () -> Int in
            return 4;
        }
        trailingClosureTwo(amout: 3) { () -> Int in
            4;
        }
        
        // 这个 虽然是 没参数的closure 但是没法 省略in
        //        trailingClosureTwo(amout: 3) { () -> Int in
        //
        //        }
    }
    
    // 若将闭包作为函数最后一个参数，可以省略参数标签,然后将闭包表达式写在函数调用括号后面
    // 正常写法
    func trailingClosure(testBlock:()->Void) {
        testBlock()  // 调用block
    }
    
    func trailingClosureTwo(amout:Int,testBlock:()->Int)  {
        let result = amout + testBlock()
        print("result is \(result)")
    }
    
    //MARK: - 值捕获
    // 函数形式返回
    func captureValue(sums amount:Int) -> ()->Int{
        var total = 0
        func incrementer()->Int{
            total += amount
            return total
        }
        return incrementer
    }
   
    // 闭包形式返回
    func captureValue2(sums amount:Int) -> ()->Int {
        var total = 0
        let AddBlock:() ->Int = {
            total += amount
            return total
        }
        return AddBlock
    }
    
    func testCaptureValue() {
        
        // 闭包可以在其被定义的上下文中捕获常量或变量。Swift中，可以捕获值的闭包的最简单形式是嵌套函数，也就是定义在其他函数的函数体内的函数
        // 返回的 闭包也要调用  打印"10 10 10"
        print(captureValue(sums: 10)())
        print(captureValue(sums: 10)())
        print(captureValue(sums: 10)())
        
        // 这里没有值捕获的原因是，没有去用一个常量或变量去引用函数，所以每次使用的函数都是新的。有点类似于OC中的匿名对象。
        // 这里值捕获了，是因为函数被引用了，所以没有立即释放掉。所以函数体内的值可以被捕获
        //打印"10 20 30"
        let  refrenceFunc = captureValue(sums: 10);
        print(refrenceFunc())
        print(refrenceFunc())
        print(refrenceFunc())
        
        //
        let testBlock = captureValue2(sums: 100)
        print(testBlock())
        print(testBlock())
        print(testBlock())
        print(captureValue2(sums: 100)())
        print(captureValue2(sums: 100)())
        print(captureValue2(sums: 100)())
    }
    
    var  num:Int = 100
    //    static var b:Int = 100
    func  testClosureCaptureStaticValue()  {
        //
        var number:Int = 100
        let closure:(Int) ->(Int) = {
            a in a+number
        }
        print("局部变量改变number值\(closure(100))")
        number = 50
        print("局部变量改变number值\(closure(100))")
        
        let closure2:(Int) ->(Int) = {
            a in a+self.num
        }
        
        print("全局变量改变number值\(closure2(100))")
        num = 50
        print("全局变量改变number值\(closure2(100))")
    }
    
    //MARK: - 逃逸闭包
    /*
     当一个闭包作为参数传到一个函数中，需要这个闭包在函数返回之后才被执行，我们就称该闭包从函数种逃逸。一般如果闭包在函数体内涉及到异步操作，但函数却是很快就会执行完毕并返回的，闭包必须要逃逸掉，以便异步操作的回调。
     逃逸闭包一般用于异步函数的回调，比如网络请求成功的回调和失败的回调。语法：在函数的闭包行参前加关键字“@escaping”。
     */
    func doSomething(some: @escaping ()->Void) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            some()
        }
        print("do Something Function Body")
    }
    
    func doSomethingDelayWithNoneEscaping(some:()->Void) {
        // 这种会有类似的提醒 编译器  提醒加 escaping
        // Closure use of non-escaping parameter 'some' may allow it to escape
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
//            some()
//        }
//      IDE 编译优化  这种显式的我们能避免  我们在 TestViewController
        some()
        print("do Something Function Body")
    }
    
    var completionHandler:()->String = {
        "DeLongYang"
    }
    
    func doSomething2(some: @escaping ()->String)  {
        completionHandler = some
    }
    
    var completionHandlers:[()->Void] = []
    // 逃逸
    func someFunctionWithEscapingClosure(completionHandler: @escaping ()->Void)  {
        completionHandlers.append(completionHandler)
    }
    
    // 非逃逸
    func someFunctionWithNonescaping(closure:()->Void) {
        // 提醒要加 @escaping
//        completionHandlers.append(closure)
        closure()
    }
    
    // 测试一个逃逸闭包
    func testEscapingClosure()  {
        doSomething {
            print("---------")
        }
        
        doSomething2 { () -> String in
            return "CutomDoSomething2"
        }
        
        print(completionHandler())
        
        //将一个闭包标记为@escaping意味着你必须在闭包中显式的引用self。
        //其实@escaping和self都是在提醒你，这是一个逃逸闭包，
        //别误操作导致了循环引用！而非逃逸包可以隐式引用self。
        // 
        someFunctionWithEscapingClosure {
            self.x = 100
            // 这里需要使用 self.x
        }
        
        someFunctionWithNonescaping {
            x = 200
            //  这里可以用 x 可以不用self.x
        }
        print("\(x)")
        
    }
   
    // MARK: - 自动闭包
    /*
     顾名思义，自动闭包是一种自动创建的闭包，封装一堆表达式在自动闭包中，然后将自动闭包作为参数传给函数。而自动闭包是不接受任何参数的，但可以返回自动闭包中表达式产生的值。
     自动闭包让你能够延迟求值，直到调用这个闭包，闭包代码块才会被执行。说白了，就是语法简洁了，有点懒加载的意思。
     */
    var array = ["I","have","a","apple"]
    func testAutomaticClosure(){
        print(array.count)
        let removeBlock:()->() = {
            // array 需要加 self
            self.array.remove(at: 3)
        }
        //
        print("remove at index \(removeBlock())")
        print(array.count)
    }
    
}

