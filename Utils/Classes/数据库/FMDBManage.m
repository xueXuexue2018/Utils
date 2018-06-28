//
//  FMDBManage.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "FMDBManage.h"
#import "UserInfoModel.h"
#import "RelationModel.h"
#import "DepartmentModel.h"
#import "RelationUserModel.h"
#import "PluginModel.h"
#import "NSString+Encrypt.h"
@implementation FMDBManage
+(instancetype)shareManage{
    static FMDBManage *manage=nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        manage=[[FMDBManage alloc]init];
    });
    return manage;
}
-(instancetype)init{
    if ([super init]) {
        self.fmdataBase=[[FMDatabase alloc]initWithPath:@"本地数据库路径"];
        [self.fmdataBase open];
    }
    return self;
}
#pragma 更新用户数据
-(void)refreshUserInfoDataWithArr:(NSArray *)arr{
    [self.fmdataBase beginDeferredTransaction];
    for (NSInteger i=0; i<arr.count; i++) {
        UserInfoModel *model=arr[i];
        NSInteger flag=model.enabled;
        if (flag==0) {
            BOOL isExist=[self SearchIsExistUserInfoDataWithDB:self.fmdataBase andModel:model];
            if (isExist) {
                [self ChangeInfoDataWithDB:self.fmdataBase andModel:model];
            }else{
                [self insertUserInfoDataWithDB:self.fmdataBase andModel:model];
            }
        }else{
            [self deleteUserInfoDataWithDB:self.fmdataBase andModel:model];
        }
    }
    [self.fmdataBase commit];
}
-(void)insertUserInfoDataWithDB:(FMDatabase *)db andModel:(UserInfoModel *)model{
    
    if ([db executeUpdate:@"insert into BaseUserInfo (userInfoId,userName,userNumber,rankOrder,phoneNo,email,sex,imei,note,enabled,updateTime,pinyin,fileName) values(?,?,?,?,?,?,?,?,?,?,?,?,?)",model.userInfoId,model.userName,model.userNumber,model.rankOrder,model.phoneNo,model.email,model.sex,model.imei,model.note,@(model.enabled),@(model.updateTime),model.pinyin,model.fileName]==NO) {
        NSLog(@"添加人员失败");
    }
}

-(void)ChangeInfoDataWithDB:(FMDatabase *)db andModel:(UserInfoModel *)model{
    
    if ([db executeUpdate:@"UPDATE BaseUserInfo set userName=?,userNumber=?,rankOrder=?,phoneNo=?,email=?,sex=?,imei=?,note=?,enabled=?,updateTime=?,pinyin=?,fileName=? where userInfoId=?",model.userName,model.userNumber,model.rankOrder,model.phoneNo,model.email,model.sex,model.imei,model.note,@(model.enabled),@(model.updateTime),model.pinyin,model.fileName,model.userInfoId]==NO) {
        NSLog(@"修改人员失败");
    }
    
}
-(void)deleteUserInfoDataWithDB:(FMDatabase *)db andModel:(UserInfoModel *)model{
    if ([db executeUpdate:@"delete from BaseUserInfo where userInfoId=?",model.userInfoId]==NO) {
        NSLog(@"删除人员失败");
    }
}
-(BOOL)SearchIsExistUserInfoDataWithDB:(FMDatabase *)db andModel:(UserInfoModel *)model{
    int count;
    count=[db intForQuery:@"select COUNT(*) from BaseUserInfo where userInfoId=?",model.userInfoId];
    if (count>0) {
        return YES;
    }
    return NO;
}

#pragma 更新关系数据

-(void)refreshRelationDataWithArr:(NSArray *)arr{
    
    [self.fmdataBase beginDeferredTransaction];
    for (NSInteger i=0; i<arr.count; i++) {
        RelationModel *model=arr[i];
        NSInteger flag=model.enabled;
        if (flag==0) {
            BOOL isExist=[self searchIsExistRelationDataWithDB:self.fmdataBase andModel:model];
            if (isExist) {
                [self changeRelationDataWithDB:self.fmdataBase andModel:model];
            }else{
                [self insertRelationDataWithDB:self.fmdataBase andModel:model];
            }
        }else{
            [self deleteRelationDataWithDB:self.fmdataBase andModel:model];
        }
    }
    [self.fmdataBase commit];
    
}
-(void)insertRelationDataWithDB:(FMDatabase *)db andModel:(RelationModel *)model{
    
    if ([db executeUpdate:@"insert into BaseDepartUser (departUserId,userInfoId,userName,departmentId,departmentName,positionName,telNo1,telNo2,telnet,rankOrder,enabled,updateTime) values(?,?,?,?,?,?,?,?,?,?,?,?)",model.departUserId,model.userInfoId,model.userName,model.departmentId,model.departmentName,model.positionName,model.telNo1,model.telNo2,model.telnet,model.rankOrder,@(model.enabled),@(model.updateTime)]==NO) {
        NSLog(@"添加关系失败");
    }
    
}

-(void)changeRelationDataWithDB:(FMDatabase *)db andModel:(RelationModel *)model{
    if ([db executeUpdate:@"UPDATE BaseDepartUser set departUserId=?,userName=?,departmentName=?,positionName=?,telNo1=?,telNo2=?,telnet=?,rankOrder=?,enabled=?,updateTime=? where userInfoId=? and departmentId=?",model.departUserId,model.userName,model.departmentName,model.positionName,model.telNo1,model.telNo2,model.telnet,model.rankOrder,@(model.enabled),@(model.updateTime),model.userInfoId,model.departmentId]==NO) {
        NSLog(@"修改关系失败");
    }
}
-(void)deleteRelationDataWithDB:(FMDatabase *)db andModel:(RelationModel *)model{
    if ([db executeUpdate:@"delete from BaseDepartUser where userInfoId=? and departmentId=?",model.userInfoId,model.departmentId]==NO) {
        NSLog(@"删除关系失败");
    }
}
-(BOOL)searchIsExistRelationDataWithDB:(FMDatabase *)db andModel:(RelationModel *)model{
    int count;
    count=[db intForQuery:@"select COUNT(*) from BaseDepartUser where userInfoId=? and departmentId=?",model.userInfoId,model.departmentId];
    if (count>0) {
        return YES;
    }
    return NO;
}
#pragma 更新部门数据
-(void)refreshDepartmentDataWithArr:(NSArray *)arr{
    
    [self.fmdataBase beginDeferredTransaction];
    for (NSInteger i=0; i<arr.count; i++) {
        DepartmentModel *model=arr[i];
        NSInteger flag=model.enabled;
        if (flag==0) {
            BOOL isExist=[self searchIsExistDepartmentDatawithDB:self.fmdataBase andModel:model];
            if (isExist) {
                [self changeDepartmentDataWithDB:self.fmdataBase andModel:model];
            }else{
                [self insertDepartmentDataWithDB:self.fmdataBase andModel:model];
            }
        }else{
            [self deleteDepartmentDataWithDB:self.fmdataBase andModel:model];
        }
    }
    [self.fmdataBase commit];
    
}
-(void)insertDepartmentDataWithDB:(FMDatabase *)db andModel:(DepartmentModel *)model{
    
    if ([db executeUpdate:@"insert into BaseDepartmentInfo (departmentInfoId,departmentName,departmentOrder,departmentFullName,parentDepartmentId,parentDepartmentName,note,enabled,updateTime) values(?,?,?,?,?,?,?,?,?)",model.departmentInfoId,model.departmentName,model.departmentOrder,model.departmentFullName,model.parentDepartmentId,model.parentDepartmentName,model.note,@(model.enabled),@(model.updateTime)]==NO) {
        NSLog(@"添加部门失败");
    }
}
-(void)changeDepartmentDataWithDB:(FMDatabase *)db andModel:(DepartmentModel *)model{
    if ([db executeUpdate:@"UPDATE BaseDepartmentInfo set departmentName=?,departmentOrder=?,departmentFullName=?,parentDepartmentId=?,parentDepartmentName=?,note=?,enabled=?,updateTime=? where departmentInfoId=?",model.departmentName,model.departmentOrder,model.departmentFullName,model.parentDepartmentId,model.parentDepartmentName,model.note,@(model.enabled),@(model.updateTime),model.departmentInfoId]==NO) {
        NSLog(@"修改部门失败");
    }
}
-(void)deleteDepartmentDataWithDB:(FMDatabase *)db andModel:(DepartmentModel *)model{
    if ([db executeUpdate:@"delete from BaseDepartmentInfo where departmentInfoId=?",model.departmentInfoId]==NO) {
        NSLog(@"删除部门失败");
    }
}
-(BOOL)searchIsExistDepartmentDatawithDB:(FMDatabase *)db andModel:(DepartmentModel *)model{
    int count;
    count=[db intForQuery:@"select COUNT(*) from BaseDepartmentInfo where departmentInfoId=?",model.departmentInfoId];
    if (count>0) {
        return YES;
    }
    return NO;
}
#pragma 查询数据
#pragma  这里都是部门的查询
// 查询子部门
-(NSMutableArray *)searchDepartmentDataWith:(NSString *)parentStr{
    [self.fmdataBase open];
    NSMutableArray *departArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select * from BaseDepartmentInfo where parentDepartmentId=? order by departmentOrder",parentStr];
    while([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.departmentName=[resultSet stringForColumn:@"departmentName"];
        model.parentDepartmentId=[resultSet stringForColumn:@"parentDepartmentId"];
        model.parentDepartmentName=[resultSet stringForColumn:@"parentDepartmentName"];
        model.departmentInfoId=[resultSet stringForColumn:@"departmentInfoId"];
        [departArr addObject:model];
    }
    return departArr;
}
//查询某个子部门都是人物的情况
-(NSMutableArray *)searchDepartmentAllUserWith:(NSString *)departmentId{
    
    [self.fmdataBase open];
    NSMutableArray *DepartAllUserArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select BaseUserInfo.userInfoId,BaseUserInfo.sex,BaseUserInfo.fileName,BaseUserInfo.updateTime,BaseUserInfo.userName,BaseUserInfo.userNumber,BaseUserInfo.phoneNo,BaseDepartUser.positionName from BaseUserInfo,BaseDepartUser where BaseUserInfo.userInfoId=BaseDepartUser.userInfoId and BaseDepartUser.departmentId=? order by BaseDepartUser.rankOrder asc",departmentId];
    while ([resultSet next]) {
        //从人员表
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.userInfoId=[resultSet stringForColumn:@"userInfoId"];
        model.userName=[resultSet stringForColumn:@"userName"];
        model.userNumber=[resultSet stringForColumn:@"userNumber"];
        model.phoneNo=[[resultSet stringForColumn:@"phoneNo"] MD5StringToString];
        //从关系表
        model.positionName=[resultSet stringForColumn:@"positionName"];
        [DepartAllUserArr addObject:model];
    }
    return DepartAllUserArr;
}
#pragma  这里都是人员的查询
//查询人的图片信息
-(NSMutableArray *)searchPersonImageWith:(NSString *)userinfoid{
    [self.fmdataBase open];
    NSMutableArray *userArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select * from  BaseUserInfo where userinfoid=?",userinfoid];
    while ([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.fileName=[resultSet stringForColumn:@"fileName"];
        model.updateTime=[resultSet longForColumn:@"updateTime"];
        model.sex=[resultSet stringForColumn:@"sex"];
        [userArr addObject:model];
    }
    return userArr;
}
// 直接在人员中去查找,没有去查找部门表
-(NSMutableArray *)searchAllUserInfoDataNotDepartTable{
    
    [self.fmdataBase open];
    NSMutableArray *userArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select * from  BaseUserInfo as a inner join (select min(departuserid),departmentId,departmentName,positionName,telNo1,telNo2,telnet,userinfoid from BaseDepartUser GROUP by userInfoId) as b  on b.userinfoid=a.userinfoid"];
    while ([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.userInfoId=[resultSet stringForColumn:@"userInfoId"];
        model.userName=[resultSet stringForColumn:@"userName"];
        model.phoneNo=[[resultSet stringForColumn:@"phoneNo"] MD5StringToString];
        model.pinyin=[resultSet stringForColumn:@"pinyin"];
        model.userNumber=[resultSet stringForColumn:@"userNumber"];
        model.positionName=[resultSet stringForColumn:@"positionName"];
        [userArr addObject:model];
    }
    return userArr;
}
//从部门进去查找
-(NSArray *)searchOnePersonDataWith:(NSString *)userInfoId{
    [self.fmdataBase open];
    NSMutableArray *userArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select BaseUserInfo.phoneNo,BaseUserInfo.fileName,BaseUserInfo.userName,BaseDepartUser.departmentId,BaseDepartUser.departmentName,BaseDepartUser.positionName,BaseDepartUser.telNo1,BaseDepartUser.telNo2,BaseDepartUser.telnet,BaseDepartmentInfo.parentDepartmentName from BaseUserInfo,BaseDepartUser,BaseDepartmentInfo where BaseUserInfo.userInfoId=BaseDepartUser.userInfoId and BaseDepartUser.departmentId=BaseDepartmentInfo.departmentInfoId and BaseUserInfo.userInfoId=?",userInfoId];
    while ([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.departmentId=[resultSet stringForColumn:@"departmentId"];
        model.phoneNo=[[resultSet stringForColumn:@"phoneNo"] MD5StringToString];
        model.parentDepartmentName=[resultSet stringForColumn:@"parentDepartmentName"];
        model.departmentName=[resultSet stringForColumn:@"departmentName"];
        model.telNo1=[[resultSet stringForColumn:@"telNo1"] MD5StringToString];
        model.telNo2=[[resultSet stringForColumn:@"telNo2"] MD5StringToString];
        model.telnet=[[resultSet stringForColumn:@"telnet"] MD5StringToString];
        model.userName=[resultSet stringForColumn:@"userName"];
        model.positionName=[resultSet stringForColumn:@"positionName"];
        [userArr addObject:model];
    }
    return userArr;
}
//单表查询
-(NSArray *)searchOnePersonWithOneOnlyTable:(NSString *)userinfoid{
    [self.fmdataBase open];
    NSMutableArray *userArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select BaseUserInfo.phoneNo,BaseUserInfo.fileName,BaseUserInfo.userInfoId, BaseUserInfo.userName,BaseUserInfo.userNumber from BaseUserInfo where BaseUserInfo.userInfoId=?",userinfoid];
    while ([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.fileName=[resultSet stringForColumn:@"fileName"];
        model.phoneNo=[[resultSet stringForColumn:@"phoneNo"] MD5StringToString];
        model.userName=[resultSet stringForColumn:@"userName"];
        model.userNumber=[resultSet stringForColumn:@"userNumber"];
        [userArr addObject:model];
    }
    return userArr;
    
}

//从两张表查
-(NSArray *)searchOnePersonDataWithoutDepartTabelWith:(NSString *)userInfoId;{
    [self.fmdataBase open];
    NSMutableArray *userArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select BaseUserInfo.phoneNo,BaseUserInfo.userNumber,BaseUserInfo.updateTime,BaseUserInfo.fileName,BaseUserInfo.userName,BaseDepartUser.positionName,BaseDepartUser.departmentId,BaseDepartUser.departmentName,BaseDepartUser.telNo1,BaseDepartUser.telNo2,BaseDepartUser.telnet from BaseUserInfo,BaseDepartUser where BaseUserInfo.userInfoId=BaseDepartUser.userInfoId  and BaseUserInfo.userInfoId=?",userInfoId];
    while ([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.updateTime=[resultSet longForColumn:@"updateTime"];
        model.fileName=[resultSet stringForColumn:@"fileName"];
        model.phoneNo=[[resultSet stringForColumn:@"phoneNo"] MD5StringToString];
        model.departmentName=[resultSet stringForColumn:@"departmentName"];
        model.positionName=[resultSet stringForColumn:@"positionName"];
        model.departmentId=[resultSet stringForColumn:@"departmentId"];
        model.telNo1=[[resultSet stringForColumn:@"telNo1"] MD5StringToString];
        model.telNo2=[[resultSet stringForColumn:@"telNo2"] MD5StringToString];
        model.telnet=[[resultSet stringForColumn:@"telnet"] MD5StringToString];
        model.userName=[resultSet stringForColumn:@"userName"];
        model.userNumber=[resultSet stringForColumn:@"userNumber"];
        [userArr addObject:model];
    }
    return userArr;
}
// 查找某人的父级部门,因为存在部门删除了，但是关系表中还有这个部门
-(NSArray *)SearchOnePersonParentDeparmentIdWithStr:(NSString *)DeparmentId{
    [self.fmdataBase open];
    NSMutableArray *userArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select BaseDepartmentInfo.parentDepartmentId,BaseDepartmentInfo.parentDepartmentName from BaseDepartmentInfo where BaseDepartmentInfo.departmentInfoId=?",DeparmentId];
    while ([resultSet next]) {
        RelationUserModel *model=[[RelationUserModel alloc]init];
        model.parentDepartmentId=[resultSet stringForColumn:@"parentDepartmentId"];
        model.parentDepartmentName=[resultSet stringForColumn:@"parentDepartmentName"];
        [userArr addObject:model];
    }
    return userArr;
}
//查询自己是不是关领导
-(NSArray *)searchSelfIsGuanLingDaoWithUserInfoId:(NSString *)userinfoId{
    [self.fmdataBase open];
    NSMutableArray *departArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select * from BaseDepartUser where userInfoId=?",userinfoId];
    while ([resultSet next]) {
        NSString *departmendId=[resultSet stringForColumn:@"departmentId"];
        [departArr addObject:departmendId];
    }
    return departArr;
}

#pragma 插件表
#pragma 插件数据
/////////////////////////////////////////////////插件数据
//更新数据
-(BOOL)refreshPluginDataWithArr:(NSArray *)arr{
    BOOL isSuccess=false;
    [self.fmdataBase beginDeferredTransaction];
    for (NSInteger i=0; i<arr.count; i++) {
        PluginModel *model=arr[i];
        NSInteger flag=model.enabled;
        if (flag==0) {
            BOOL isExist=[self searchIsExistPluginDataWithDB:self.fmdataBase andModel:model];
            if (isExist==YES) {
                isSuccess=[self changePluginDataWithDB:self.fmdataBase andModel:model];
            }else{
                isSuccess=[self insertPluginDataWithDB:self.fmdataBase andModel:model];
            }
        }else{
            isSuccess=[self changePluginDataWithDB:self.fmdataBase andModel:model];
        }
        if (isSuccess==NO) {
            break;
        }
    }
    [self.fmdataBase commit];
    return isSuccess;
}
//增加数据
-(BOOL)insertPluginDataWithDB:(FMDatabase *)db  andModel:(PluginModel *)model{
    
    if ([db executeUpdate:@"insert into BasePluginsInfo (pluginsServiceIp,pluginsPort,pluginsCode,temporary,jurisdiction,pluginsInfoId,pluginsName,sourceUrl,pluginsType,pluginsPhoneLogo,pluginsPhoneHome,status,enabled,updateTime,developStatus,permissionString,pluginOrder) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.pluginServerIp,model.pluginPort,model.pluginsCode,@(model.temporary),@(model.jurisdiction),model.pluginsInfoId,model.pluginsName,model.sourceUrl,@(model.pluginType),model.pluginPhoneLogo,model.pluginPhoneHome,@(model.status),@(model.enabled),@(model.updateTime),@(model.developStatus),model.permissionString,model.pluginOrder]==NO) {
        NSLog(@"插入插件失败");
        return NO;
    }
    return YES;
}
//改变数据
-(BOOL)changePluginDataWithDB:(FMDatabase *)db andModel:(PluginModel *)model{
    
    if ([db executeUpdate:@"update BasePluginsInfo set pluginsName=?,sourceUrl=?,pluginsType=?,pluginsPhoneLogo=?,pluginsPhoneHome=?,status=?,enabled=?,updateTime=?,developStatus=?,permissionString=?,pluginOrder=?,temporary=?,jurisdiction=?,pluginsCode=?,pluginsServiceIp=?,pluginsPort=? where pluginsInfoId=?",model.pluginsName,model.sourceUrl,@(model.pluginType),model.pluginPhoneLogo,model.pluginPhoneHome,@(model.status),@(model.enabled),@(model.updateTime),@(model.developStatus),model.permissionString,model.pluginOrder,@(model.temporary),@(model.jurisdiction),model.pluginsCode,model.pluginServerIp,model.pluginPort,model.pluginsInfoId]==NO) {
        NSLog(@"修改插件失败");
        return NO;
    }
    return YES;
}
//查找是否存在图片
-(BOOL)searchIsExistPluginDataWithDB:(FMDatabase *)db andModel:(PluginModel *)model{
    int count;
    count=[db intForQuery:@"select COUNT(*) from BasePluginsInfo where pluginsInfoId=?",model.pluginsInfoId];
    if (count>0) {
        return YES;
    }
    return NO;
}

-(NSArray *)searchAllPluginData{
    [self.fmdataBase open];
    NSMutableArray *pluginArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select * from BasePluginsInfo order by pluginOrder"];
    while ([resultSet next]) {
        PluginModel *model=[[PluginModel alloc]init];
        model.permissionString=[resultSet stringForColumn:@"permissionString"];
        model.pluginsInfoId=[resultSet stringForColumn:@"pluginsInfoId"];
        model.pluginsName=[resultSet stringForColumn:@"pluginsName"];
        model.sourceUrl=[resultSet stringForColumn:@"sourceUrl"];
        model.pluginType=[resultSet intForColumn:@"pluginsType"];
        model.pluginPhoneLogo=[resultSet stringForColumn:@"pluginsPhoneLogo"];
        model.pluginPhoneHome=[resultSet stringForColumn:@"pluginsPhoneHome"];
        model.status=[resultSet intForColumn:@"status"];
        model.enabled=[resultSet intForColumn:@"enabled"];
        model.updateTime=[resultSet intForColumn:@"updateTime"];
        model.developStatus=[resultSet intForColumn:@"developStatus"];
        model.localPath=[resultSet dataForColumn:@"localPath"];
        model.jurisdiction=[resultSet intForColumn:@"jurisdiction"];
        model.temporary=[resultSet intForColumn:@"temporary"];
        model.pluginsCode=[resultSet stringForColumn:@"pluginsCode"];
        model.pluginServerIp=[resultSet stringForColumn:@"pluginsServiceIp"];
        model.pluginPort=[resultSet stringForColumn:@"pluginsPort"];
        [pluginArr addObject:model];
    }
    return pluginArr;
}
-(void)searchAllPluginDataWithBlock:(void(^)(NSArray *Arr))block{
    [self.fmdataBase open];
    NSMutableArray *pluginArr=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[self.fmdataBase executeQuery:@"select * from BasePluginsInfo"];
    while ([resultSet next]) {
        PluginModel *model=[[PluginModel alloc]init];
        model.permissionString=[resultSet stringForColumn:@"permissionString"];
        model.pluginsInfoId=[resultSet stringForColumn:@"pluginsInfoId"];
        model.pluginsName=[resultSet stringForColumn:@"pluginsName"];
        model.sourceUrl=[resultSet stringForColumn:@"sourceUrl"];
        model.pluginType=[resultSet intForColumn:@"pluginsType"];
        model.pluginPhoneLogo=[resultSet stringForColumn:@"pluginsPhoneLogo"];
        model.pluginPhoneHome=[resultSet stringForColumn:@"pluginsPhoneHome"];
        model.status=[resultSet intForColumn:@"status"];
        model.enabled=[resultSet intForColumn:@"enabled"];
        model.updateTime=[resultSet intForColumn:@"updateTime"];
        model.developStatus=[resultSet intForColumn:@"developStatus"];
        model.localPath=[resultSet dataForColumn:@"localPath"];
        [pluginArr addObject:model];
        block(pluginArr);
    }
}

@end
