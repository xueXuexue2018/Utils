//
//  FMDBManage.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface FMDBManage : NSObject
@property(nonatomic,strong)FMDatabaseQueue *FMQueue;  //管理串行数据库，不会造成数据库堵塞，操作线程
@property(nonatomic,strong)FMDatabase *fmdataBase;   //这个是用来查询数据的
+(instancetype)shareManage;
-(void)refreshUserInfoDataWithArr:(NSArray *)arr;
-(void)refreshRelationDataWithArr:(NSArray *)arr;
-(void)refreshDepartmentDataWithArr:(NSArray *)arr;
//查询数据
-(NSMutableArray *)searchDepartmentDataWith:(NSString *)parentStr;   //查询子类数据通过父类的id
-(NSMutableArray *)searchDepartmentAllUserWith:(NSString *)departmentId; //查询一个部门下都是人员的情况
//单表查询
-(NSArray *)searchOnePersonWithOneOnlyTable:(NSString *)userinfoid;
// 查询人员列表通过通过人员表和关系表,没有部门表
-(NSMutableArray *)searchAllUserInfoDataNotDepartTable;
// 查询个人数据,从三张表
-(NSArray *)searchOnePersonDataWith:(NSString *)userInfoId;
//查询个人数据,没有从部门表查找
-(NSArray *)searchOnePersonDataWithoutDepartTabelWith:(NSString *)userInfoId;
// 查询父级部门
-(NSArray *)SearchOnePersonParentDeparmentIdWithStr:(NSString *)DeparmentId;

-(NSMutableArray *)searchPersonImageWith:(NSString *)userinfoid;
//查询自己是不是关领导
-(NSArray *)searchSelfIsGuanLingDaoWithUserInfoId:(NSString *)userinfoId;


#pragma 插件表

-(BOOL)refreshPluginDataWithArr:(NSArray *)arr;
-(NSArray *)searchAllPluginData;
-(void)searchAllPluginDataWithBlock:(void(^)(NSArray *Arr))block;

@end
