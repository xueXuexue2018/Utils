//
//  OnlyOneQueue.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "OnlyOneQueue.h"

@implementation OnlyOneQueue
+(instancetype)shareQueue{
    static OnlyOneQueue *manage=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage=[[OnlyOneQueue alloc]init];
        manage.SQLQueue=dispatch_queue_create("zeng",DISPATCH_QUEUE_SERIAL);
    });
    return manage;
}
@end
