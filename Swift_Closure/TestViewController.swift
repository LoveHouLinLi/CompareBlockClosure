//
//  TestViewController.swift
//  Swift_Closure
//
//  Created by meitianhui2 on 2017/12/12.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var x = 10;
    var block:(()->())?
    fileprivate var person:Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
//        retainCycle()
//        testAutomaticClosure()   // 下面这个没有 retainCycle
//        testClosureCaptureBasicType()
//        testClosureCaptureObjectType()
//        testClosureCaptureObjectType2() //
//        testRetainCycleInClosure()
//        testRetainCycleInClosureTwo()
//        testRetainCycleInClosureThree()
        testRetainCycleInClosureFour()
        
//        testNoneEscapingClosureInEscapingCondition {
//            print("这是 闭包的内容 -----")
//        }
        //
        
    }
    
    //MARK: - 自动闭包  主要是为了 测试是否有 泄漏
    var completionHandlers:[()->Void] = []
    // 逃逸
    func someFunctionWithEscapingClosure(completionHandler: @escaping ()->Void)  {
        completionHandlers.append(completionHandler)
    }
    
    // 这里 有内存泄漏 
    func retainCycle()  {
        // 产生了内存泄漏 如果这样调用
        someFunctionWithEscapingClosure {
            self.x = 100;
        }
    }
    
    //
    func fixRetainRetainCycle() {
        
    }
    
    // 这个 没有内存泄漏
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("de init ")
    }

    //MARK: - 测试 闭包的捕获变量
    // 在Swift中，这叫做截获变量的引用。闭包默认会截取变量的引用，也就是说所有变量默认情况下都是加了__block修饰符的。
    func testClosureCaptureBasicType()  {
        var x = 42
        let f = {
            // [x] in //如果取消注释，结果是42
            print(x)
        }
        x = 43
        f() // 结果是43
    }
    
    // 捕获 Object 对象
    func testClosureCaptureObjectType() {
        
        // 没有循环引用
        var block2:()->()?
        var a:Person? = Person()
        block2 = {
            print(a?.name)
        }
        a = Person(name:"new name")
        block2()
    }
    
    func testClosureCaptureObjectType2()  {
        // 没有 循环引用
        // 如果把变量写在截获列表中，那么block内部会有一个指向对象的强引用，这和在OC中什么都不写的效果是一样的
        var block2: (() -> ())?
        if true {
            var a: Person? = Person()
            block2 = {
                [a] in
                print(a?.name)
            }
            a = Person(name: "de_long")
        }
        block2?() //打印 结果是："Optional("old name")"
    }
    
    // MARK: -  测试 循环引用
    /*
     我们先创建了可选类型的变量a，然后创建一个闭包变量，并把它赋值给a的block属性。这个闭包内部又会截获a，那这样是否会导致循环引用呢？
     
     答案是否定的。虽然从表面上看，对象的闭包属性截获了对象本身。但是如果你运行上面这段代码，你会发现对象的deinit方法确实被调用了，打印结果不是“A”而是“nil”。
     
     这是因为我们忽略了可选类型这个因素。这里的a不是A类型的对象，而是一个可选类型变量，其内部封装了A的实例对象。闭包截获的是可选类型变量a，当你执行a = nil时，并不是释放了变量a，而是释放了a中包含的A类型实例对象。所以A的deinit方法会执行，当你调用block时，由于使用了可选链，就会得到nil，如果使用强制解封，程序就会崩溃。
     */
    func testRetainCycleInClosure() {
        // 没有循环引用
        var a:Person? = Person()
        let block = {
            print(a?.name)
        }
        a?.block = block
        // 不论 a 是否是 nil 都不会有 循环引用
        a = nil
        block()
    }
    
    func testRetainCycleInClosureFour()  {
        person = Person()
        let block = {
            self.x = 20;
            print(self.x)
        }
        person?.block = block
//        person = nil  // 如果person 不设置成 nil 会有循环引用
//        block()  // 和 block 是否调用没有关系
    }
    
    func testRetainCycleInClosureTwo()  {
        
        //  还是没有测试出现 deint
        // 没有循环引用
        let block = {
            print("block")
            print(self.view.frame)
        }
        let b:Object = Object(block: block)
        b.block = block
//        b = nil
        block()
        b.block()
        
    }
    
    // 这个 会引起 循环引用
    func testRetainCycleInClosureThree() {
        let a = Person()
        // 全局 的 变量
        block = {
            print(self.view.frame)
        }
        a.name = "New Name"
        block!()
    }
    
    // MARK:-  我们测试一个耗时的操作 没有escaping 的是否会执行完 block 中的内容
    var canExecuteClosure:Bool = false
    var sum:Int = 0
    func testNoneEscapingClosureInEscapingCondition(some:@escaping ()->())  {
        
        // 提示要我们加上 @escaping  我们想加上这种情形 但是 IDE 不让通过 ！！！
        DispatchQueue.global().async {
            for i in 0...10000{
                for j in 0...10000{
                    self.sum += (i+j)
                }
            }
            some()
        }
       
    }
    


}


private class Person{
    
    var name:String?
    var block:(()->())?
    
    init(name:String) {
        self.name = name
    }
    
    convenience init(){
        self.init(name: "de_long")
    }
}

private class Object{
    var block:(()->())
    init(block:@escaping ()->()) {
        self.block = block
    }
}



