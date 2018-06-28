//
//  OnlyOneQueue.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlyOneQueue : NSObject
@property(nonatomic,retain)dispatch_queue_t SQLQueue;
+(instancetype)shareQueue;
@end
