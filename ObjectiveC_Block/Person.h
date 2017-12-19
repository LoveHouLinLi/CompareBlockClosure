//
//  Person.h
//  ObjectiveC_Block
//
//  Created by meitianhui2 on 2017/12/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic,copy)NSString *name;

@end
