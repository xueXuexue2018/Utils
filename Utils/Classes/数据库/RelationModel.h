//
//  RelationModel.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationModel : NSObject
@property(nonatomic,strong)NSString *departUserId;      //主键
@property(nonatomic,strong)NSString *userInfoId;        //用户id
@property(nonatomic,strong)NSString *userName;          //用户名
@property(nonatomic,strong)NSString *departmentId;      //部门id
@property(nonatomic,strong)NSString *departmentName;    //部门名称
@property(nonatomic,strong)NSString *positionName;      //职位
@property(nonatomic,strong)NSString *telNo1;            //办公号码1
@property(nonatomic,strong)NSString *telNo2;            //办公号码2
@property(nonatomic,strong)NSString *telnet;            //短号
@property(nonatomic,strong)NSString *rankOrder;         //排序
@property(nonatomic,assign)NSInteger enabled;          //删除标记
@property(nonatomic,assign)NSInteger updateTime;       //最后更新时间
@end
