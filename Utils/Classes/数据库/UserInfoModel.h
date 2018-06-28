//
//  UserInfoModel.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property(nonatomic,strong)NSString *fileName;           // 用户图片名称
@property(nonatomic,strong)NSString *userInfoId;        //用户id
@property(nonatomic,strong)NSString *userName;          //用户名
@property(nonatomic,strong)NSString *userNumber;        //用户关员号
@property(nonatomic,strong)NSString *rankOrder;         //用户排序
@property(nonatomic,strong)NSString *phoneNo;           //手机号
@property(nonatomic,strong)NSString *email;             //邮箱
@property(nonatomic,strong)NSString *sex;               //性别  ,1表示男的 0表示女的
@property(nonatomic,strong)NSString *imei;              //设备号
@property(nonatomic,strong)NSString *note;              //备注
@property(nonatomic,assign)NSInteger enabled;           //删除标记  (0表示未删除，－1表示已经删除)
@property(nonatomic,assign)NSInteger updateTime;        //最后更新时间
@property(nonatomic,strong)NSString *pinyin;             //拼音
@end
