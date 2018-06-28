//
//  LoadingWhiteView.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoadingWhiteViewDelegete<NSObject>
-(void)resignTorefreshWeb;
@end
@interface LoadingWhiteView : UIView
{
    NSInteger count;
}
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIPageControl *pagect;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UILabel *loadFailLB;
@property(nonatomic,assign)BOOL isrefreshing; //是否正在加载 。yes正在加载。
@property(nonatomic,weak)id<LoadingWhiteViewDelegete> delegete;
-(void)addanimationWithPageControl;
-(void)stopTimer;
-(instancetype)initwithFrame:(CGRect)frame andimage:(NSString *)imageStr andtitle:(NSString *)title;
@end
