//
//  BaseMessage.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>
//声明定义一个ToastLabel对象
@interface MessageLabel : UILabel
- (void)setMessageText:(NSString *)text;

@end
@interface BaseMessage : NSObject
{
    MessageLabel *messageLabel;
    NSTimer *countTimer;
}

//创建声明单例方法
+ (instancetype)shareInstance;

- (void)makeMessage:(NSString *)message duration:(CGFloat)duration;
@end
