//
//  RelationUserModel.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationUserModel : NSObject
@property(nonatomic,strong)NSString *fileName;          //用户图片名称
@property(nonatomic,strong)NSString *userInfoId;        //用户id
@property(nonatomic,strong)NSString *userName;          //用户名
@property(nonatomic,strong)NSString *userNumber;        //用户关员号
@property(nonatomic,strong)NSString *rankOrder;         //用户排序
@property(nonatomic,strong)NSString *phoneNo;           //手机号
@property(nonatomic,strong)NSString *email;             //邮箱
@property(nonatomic,strong)NSString *sex;               //性别
@property(nonatomic,strong)NSString *imei;              //设备号
@property(nonatomic,strong)NSString *note;              //备注
@property(nonatomic,assign)NSInteger enabled;           //删除标记  (0表示未删除，－1表示已经删除)
@property(nonatomic,assign)NSInteger updateTime;        //最后更新时间
@property(nonatomic,strong)NSString *pinyin;             //拼音

@property(nonatomic,strong)NSString *departmentId;      //部门id
@property(nonatomic,strong)NSString *departmentName;    //部门名称
@property(nonatomic,strong)NSString *positionName;      //职位
@property(nonatomic,strong)NSString *telNo1;            //办公号码1
@property(nonatomic,strong)NSString *telNo2;            //办公号码2
@property(nonatomic,strong)NSString *telnet;            //短号

@property(nonatomic,strong)NSString *departmentInfoId;      //部门id
@property(nonatomic,strong)NSString *departmentOrder;       //部门排序
@property(nonatomic,strong)NSString *departmentFullName;    //部门全称
@property(nonatomic,strong)NSString *parentDepartmentId;    //父级部门id
@property(nonatomic,strong)NSString *parentDepartmentName;  //父级部门名称

@end
