//
//  DownLoadAddressData.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,dataType){
    userdataType,
    departdataType,
    relationdataType,
};
@interface DownLoadAddressData : NSObject
@property(nonatomic,retain)dispatch_group_t group;
@property(nonatomic,strong)NSArray *userInfoArr;
@property(nonatomic,strong)NSArray *relationArr;
@property(nonatomic,strong)NSArray *departmentArr;
@property(nonatomic,assign)BOOL  isdownLod;        //是否正在下载
+(instancetype)shareDownManage;
-(void)downLoadAllDataRefreshDate:(NSInteger)hour andBlock:(void(^)(BOOL refreshOk ))block;
@end
