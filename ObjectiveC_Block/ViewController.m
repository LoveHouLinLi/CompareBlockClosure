//
//  ViewController.m
//  ObjectiveC_Block
//
//  Created by meitianhui2 on 2017/12/12.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    参考博客
    1.0 http://blog.csdn.net/zm_yh/article/details/51469621
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    void (^block)(void);
    NSMutableArray *array;
}

- (void)viewDidLoad {
    //
    [super viewDidLoad];
    
    //  这种在 Swift 里面叫做自动闭包
    array = @[@"I",@"have",@"a",@"apple"].mutableCopy;
    [self testBlockCaptureStaticValue];
    [self testBlockCaptureGlobalNormalBasicValue];
    [self testBlockCapturePartNormalBasicValue];
    [self testBlockChangeCapturedNormalTypeWithPointer];
}


-  (void)testAutomateBlock
{
    //  这种在 Swift 里面叫做自动闭包 但是没有懒加载的 意思 
    NSLog(@"count is %lu",(unsigned long)[array count]);
    
    void (^removeBlock)(void) = ^{
        [array removeObjectAtIndex:3];
    };
    
    removeBlock();
    NSLog(@"count is %lu",(unsigned long)[array count]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// OC  中并不能 使用 一个Block 作为一个返回值 swift 中可以
//- (block)returnBlock
//{
//
//}


#pragma mark ----  按钮点击事件
- (IBAction)testBlockClick:(id)sender
{
    [self testStackBlock];
}



#pragma mark ----  全局块 栈块 以及 堆块

/**
block  在 ARC 上默认是在堆上面
 */
- (void)testStackBlock
{
    
    int  i=arc4random()%2;
    if (i==0) {
        block=^{
            NSLog(@" Block A i is %d",i);
        };
    }else{
        block=^{
            NSLog(@"Block B i is %d",i);
        };
    }
    
    block=^{
        NSLog(@" Block A i is %d",i);
    };
    
    block=^{
        NSLog(@"Block B i is %d",i);
    };
    
    block();
}

#pragma mark ----   测试一下 Block  捕获局部 全局 静态 变量等的对比
//static int number = 100;
- (void)testBlockCaptureStaticValue
{
    static int number = 100;
    int (^TestBlock)(int) = ^(int x){
        return number+x;
    };
    
    // 
    NSLog(@"TMD 用static修饰 使用局部变量的结果:%d",TestBlock(100));
    number=50;//change the value of number.
    NSLog(@"在外面改变number的值，再次调用block的结果：%d",TestBlock(100));
}

int num = 100;
- (void)testBlockCaptureGlobalNormalBasicValue
{
    int (^TestBlock)(int) = ^(int x){
        return num+x;
    };
    
    //
    NSLog(@"使用全局变量的结果:%d",TestBlock(100));
    num=50;//change the value of number.
    NSLog(@"修改全局变量的值再次调用block的结果：%d",TestBlock(100));
    //  200 150
}

- (void)testBlockCapturePartNormalBasicValue
{
    int num = 100;
    int (^TestBlock)(int) = ^(int x){
        return num+x;
    };
    
    //
    NSLog(@"使用局部变量的结果:%d",TestBlock(100));
    num=50;//change the value of number.
    NSLog(@"修改局部变量的值再次调用block的结果：%d",TestBlock(100));
    // 200 200
}

- (void)testBlockChangeCapturedNormalBasicValue
{
    // 直接报错 Variable is not assignable (missing __block type specifier)
//    int num = 100;
//    int (^TestBlock)(int) = ^(int x){
//        num = num + x;
//        return num;
//    };
    
}

#pragma mark ----  Block 改变捕获的普通局部变量

/**
 通过指针的方式修改 捕获的普通变量
 */
- (void)testBlockChangeCapturedNormalTypeWithPointer
{
    int a = 2;
    int *p = &a;
    int (^TestBlock) (int) = ^(int y){
//        *p = 30;
        return *p + y;
    };
    
    NSLog(@"调用block的结果为：%d",TestBlock(2));//4
    NSLog(@"p指针取值:%d   变量a的值：%d ",*p,a);//2  2
    *p=4;
    NSLog(@"改变指针p对应的值以后再次调用block的结果为：%d",TestBlock(2));//6
    NSLog(@"修改指针p对应的值以后，p指针取值：%d   变量a的值：%d",*p,a);//4 4
    
    /*
     testBlock在其主体中用到的number这个变量值的时候做了一个copy的动作，把number的值copy下来。所以，之后number即使换成了新的值，对于testBlock里面copy的值是没有影响的。需要注意的是，这里copy的值是变量的值，如果它是一个记忆体的位置（地址），换句话说，如果这个变量是个指针的话，那么此时对testBlock里面copy的值是有影响的。那么在block里面可不可以通过修改指针的值呢？看看如下代码：
     */
}









@end
