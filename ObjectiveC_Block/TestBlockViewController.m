//
//  TestBlockViewController.m
//  ObjectiveC_Block
//
//  Created by meitianhui2 on 2017/12/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    参考博客： http://blog.csdn.net/zm_yh/article/details/51469621
 
 */

#import "TestBlockViewController.h"
#import "Person.h"


typedef void(^Block)(int x);
typedef void(^Block2)(void);
typedef int(^Block3)(void);

@interface TestBlockViewController ()

@property (nonatomic,strong)NSMutableArray *array;

@end

@implementation TestBlockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testCaptureBaseType];
    [self testModifyBaseTypeInBlock];
    [self testBlockCapturePoint];
    [self testModifyCapturePoint];
    [self createBlockArray];
    
}

- (void)dealloc
{
    NSLog(@"test VC  dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}


#pragma mark ----  Block 截获指针
// Block 捕获外部的 基本类型
- (void)testCaptureBaseType
{
    int value = 10;
    void (^block)(void) = ^{
        NSLog(@"value = %d",value);
    };
    value = 20;
    block();
    // 打印结果是："value = 10"  !! 为什么不是 20？ 外部的变量改变并没有影响block 里面的值
}


/**
 修改基本类型
 如果要想在block中修改被截获的基本类型变量，我们需要把它标记为__block：
 */
- (void)testModifyBaseTypeInBlock
{
    __block int value = 10;
    void(^block)(void) = ^{
        NSLog(@"value = %d", value);
    };
    value = 20;
    block();
    
    // 打印结果是："value = 20"
}


/**
 在截获基本类型时，block内部可能会有int capturedValue = value;这样的代码，类比到指针也是一样的，block内部也会有这样的代码：Person *capturedP = p;。在ARC下，这其实是强引用(retain)了block外部的p。
 */
- (void)testBlockCapturePoint
{
    Person *p = [[Person alloc] initWithName:@"zxy"];
    void(^block)(void) = ^{
        NSLog(@"person name = %@", p.name);
    };
    
    p.name = @"new name";
    block();
    
    // 打印结果是："person name = new name"
}

- (void)testModifyCapturePoint
{
    __block Person *p = [[Person alloc] initWithName:@"zxy"];
    void(^block)(void) = ^{
        NSLog(@"person name = %@", p.name);
    };
    
    p = nil;
    block();
    
    // 打印结果是："person name = (null)"
    // 试试 如果去掉 __block  打印结果是：person name = zxy
}

#pragma mark ----  测试添加Block 在Array 里面
- (void)createBlockArray
{
    Block block = ^(int value){
        NSLog(@"Block x is %d",value);
    };
    [self.array addObject:block];
    
    Block2 block2 = ^(){
        NSLog(@"Block2");
    };
    [self.array addObject:block2];
    
    Block3 block3 = ^(){
        NSLog(@"Block3 ---- ");
        return 3;
    };
    [self.array addObject:block3];
    
}


#pragma mark ---- 按钮点击事件
- (IBAction)onTestBlockArrayClick:(id)sender
{
    //
    Block block = (Block )[self.array  firstObject];
    block(100);
    
    Block2 block2 = (Block2 )[self.array objectAtIndex:1];
    block2();
    
    Block3 block3 = (Block3 )[self.array objectAtIndex:2];
    int value = block3();
    NSLog(@"value is %d",value);
}



@end
