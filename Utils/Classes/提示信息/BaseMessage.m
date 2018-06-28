//
//  BaseMessage.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "BaseMessage.h"
static int changeCount;

@implementation BaseMessage
/**
 *  实现声明单例方法 GCD
 *
 *  @return 单例
 */
+ (instancetype)shareInstance
{
    static BaseMessage *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[BaseMessage alloc] init];
    });
    return singleton;
}

/**
 *  初始化方法
 *
 *  @return 自身
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        messageLabel = [[MessageLabel alloc]init];
        
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        countTimer.fireDate = [NSDate distantFuture];//关闭定时器
    }
    return self;
}
/**
 *  弹出并显示Toast
 *
 *  @param message  显示的文本内容
 *  @param duration 显示时间
 */
- (void)makeMessage:(NSString *)message duration:(CGFloat)duration
{
    if ([message length] == 0) {
        return;
    }
    [messageLabel setMessageText:message];
    [[[UIApplication sharedApplication]keyWindow] addSubview:messageLabel];
    
    messageLabel.alpha = 0.8;
    countTimer.fireDate = [NSDate distantPast];//开启定时器
    changeCount = duration;
}
/**
 *  定时器回调方法
 */
- (void)changeTime
{
    
    if(changeCount-- <= 0){
        countTimer.fireDate = [NSDate distantFuture];//关闭定时器
        [UIView animateWithDuration:0.2f animations:^{
            messageLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [messageLabel removeFromSuperview];
        }];
    }
}
@end

#pragma mark - MessageLabel的方法
@implementation MessageLabel

/**
 *  MessageLabel初始化，为label设置各种属性
 *
 *  @return MessageLabel
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

/**
 *  设置显示的文字
 *
 *  @param text 文字文本
 */
- (void)setMessageText:(NSString *)text{
    [self setText:text];
    
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(WIDTH_SCREEN-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    
    CGFloat width = rect.size.width + 20;
    CGFloat height = rect.size.height + 20;
    CGFloat x = (WIDTH_SCREEN-width)/2;
    CGFloat y = HEIGHT_SCREEN/3;
    
    self.frame = CGRectMake(x, y, width, height);
}

@end
