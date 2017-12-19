//
//  Person.m
//  ObjectiveC_Block
//
//  Created by meitianhui2 on 2017/12/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

@end
