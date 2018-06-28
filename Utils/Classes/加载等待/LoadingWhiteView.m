//
//  LoadingWhiteView.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "LoadingWhiteView.h"

@implementation LoadingWhiteView
-(instancetype)initwithFrame:(CGRect)frame andimage:(NSString *)imageStr andtitle:(NSString *)title{
    if ([super initWithFrame:frame]) {
        [self creatUIWithImage:imageStr andtitle:title];
    }
    return self;
}
-(void)creatUIWithImage:(NSString *)imageStr andtitle:(NSString *)title{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.imgV];
    [self addSubview:self.titleLB];
    [self addSubview:self.pagect];
    [self addSubview:self.loadFailLB];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(50);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imgV.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.pagect mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.titleLB.mas_bottom).offset(20);
         make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.loadFailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.pagect.mas_bottom).offset(20);
    }];
  
}
-(void)clickTap:(UITapGestureRecognizer *)tap{
    if (self.isrefreshing==NO) {
        if (_delegete&&[_delegete respondsToSelector:@selector(resignTorefreshWeb)]) {
            [_delegete resignTorefreshWeb];
        }
    }
}
-(void)addanimationWithPageControl{
    count=0;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
-(void)stopTimer{
    [self.timer invalidate];
}
-(void)timerAction:(NSTimer *)timer{
    
    count=count+1;
    NSInteger index=count%3;
    self.pagect.currentPage=index;
}

-(UIImageView *)imgV{
    if (_imgV==nil) {
        _imgV=[UIImageView new];
    }
    return _imgV;
}
-(UIPageControl *)pagect{
    if (_pagect==nil) {
        _pagect= [[UIPageControl alloc] init];
        _pagect.translatesAutoresizingMaskIntoConstraints = NO;
        _pagect.numberOfPages = 3;
        _pagect.currentPage = 0;
        _pagect.currentPageIndicatorTintColor = [UIColor colorWithRed:251/255.0f green:57/255.0f blue:10/255.0f alpha:1.0f];
        _pagect.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pagect;
}
-(UILabel *)titleLB{
    if (_titleLB==nil) {
        _titleLB=[UILabel new];
        _titleLB.textColor=[UIColor redColor];
        _titleLB.font=[UIFont boldSystemFontOfSize:14];
        _titleLB.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLB;
}
-(UILabel *)loadFailLB{
    if (_loadFailLB==nil) {
        _loadFailLB=[UILabel new];
        _loadFailLB.textColor=[UIColor redColor];
        _loadFailLB.font=[UIFont systemFontOfSize:14];
        _loadFailLB.textAlignment=NSTextAlignmentCenter;
    }
    return _loadFailLB;
}
-(void)dealloc{
    [self.timer invalidate];
    self.timer=nil;
}

@end
