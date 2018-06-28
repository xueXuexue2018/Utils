//
//  DownLoadAddressData.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "DownLoadAddressData.h"
#import "OnlyOneQueue.h"
#import "FMDBManage.h"

@implementation DownLoadAddressData
+(instancetype)shareDownManage{
    static DownLoadAddressData *manage=nil;
    static dispatch_once_t onceToken;  //updateTime
    dispatch_once(&onceToken, ^{
        manage=[[DownLoadAddressData alloc]init];
        manage.group=dispatch_group_create();
        manage.isdownLod=NO;
    });
    return manage;
}
-(void)downLoadAllDataRefreshDate:(NSInteger)hour andBlock:(void(^)(BOOL refreshOk))block{
    if (self.isdownLod==YES) {
        block(YES);
        return;
    }
    self.isdownLod=YES;
    //第一步是看时间是否超过多少小时，超过就重新去下载数据
    NSString *refreshTime=[[NSUserDefaults standardUserDefaults] objectForKey:@"refreshtime"];
    long long intrefreshT=0;
    long long time=0;
    NSString *nowtime;
    if (refreshTime!=nil) {
        intrefreshT=refreshTime.integerValue;
    }
    UInt64 timer=[[NSDate date] timeIntervalSince1970]*1000;
    time=(long long)timer;
    nowtime=[NSString stringWithFormat:@"%lld",time];
    static BOOL userDownOk=NO;  //三者前期都没有下载成功
    static BOOL relationDownOk=NO; //没有下载成功
    static BOOL DepartDownOk=NO;  //没有下载成功
    static NSArray *modeluserArr;  //人员下载
    static NSArray *modeldepartArr; //部门下载
    static NSArray *modelrelationArr; //关系
    static NSString *userRequestTime;       //人员的请求的时间
    static NSString *departRequestTime;     //部门的请求的时间
    static NSString *relationRequestTime;   //关系的请求的时间
    if (refreshTime==nil||(time-intrefreshT>=hour*60*60*1000)) {
        
        if (hour!=0) {
            [[NSUserDefaults standardUserDefaults]setObject:nowtime forKey:@"refreshtime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        userRequestTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"userRequestTime"];
        relationRequestTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"relationRequestTime"];
        departRequestTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"departRequestTime"];
        if (userRequestTime==nil) {
            userRequestTime=@"1529543623308";
        }
        if (relationRequestTime==nil) {
            relationRequestTime=@"1529543623308";
        }
        if (departRequestTime==nil) {
            departRequestTime=@"1529543623308";
        }
        /* ********这个是初始化数据的时候用
         userRequestTime=@"0";
         relationRequestTime=@"0";
         departRequestTime=@"0";
         */
        
        
        
        // 创建并发队列
        dispatch_queue_t queue = dispatch_queue_create("model", DISPATCH_QUEUE_CONCURRENT);
        NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:@"地址",@"地址",@"地址", nil];
      
        NSDictionary *userdic=@{@"updateTime":userRequestTime,@"session":@""};
        NSDictionary *departdic=@{@"updateTime":departRequestTime,@"session":@""};
        NSDictionary *relationdic=@{@"updateTime":relationRequestTime,@"session":@""};
        NSArray *parmarr=@[userdic,departdic,relationdic];
        for (NSInteger i=0; i<arr.count; i++) {
            dispatch_group_enter(self.group);
            AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
            manage.requestSerializer.timeoutInterval=120;
            manage.responseSerializer=[AFJSONResponseSerializer serializer];
            manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            [manage POST:arr[i] parameters:parmarr[i] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger flag=[responseObject[@"code"] integerValue];
                NSString *contentStr=responseObject[@"content"];
                if (flag==1) {
                    if (contentStr!=nil) {
                        NSData *data=[contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        if (i==0) {
                            NSArray *userArr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            userRequestTime=responseObject[@"requestTime"];
                            dispatch_async(queue, ^{
                                modeluserArr=[self WriteDataToSQLwithtype:userdataType andArr:userArr];
                                userDownOk=YES;
                                dispatch_group_leave(self.group);
                            });
                        }
                        if (i==1) {
                            NSArray *departArr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            dispatch_async(queue, ^{
                                modeldepartArr=[self WriteDataToSQLwithtype:departdataType andArr:departArr];
                                departRequestTime=responseObject[@"requestTime"];
                                DepartDownOk=YES;
                                dispatch_group_leave(self.group);
                            });
                        }
                        if (i==2) {
                            NSArray *relationArr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            dispatch_async(queue, ^{
                                modelrelationArr=[self WriteDataToSQLwithtype:relationdataType   andArr:relationArr];
                                relationRequestTime=responseObject[@"requestTime"];
                                relationDownOk=YES;
                                dispatch_group_leave(self.group);
                            });
                        }
                    }
                }else{
                    dispatch_group_leave(self.group);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                dispatch_group_leave(self.group);
            }];
        }
        dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
            
            if (userDownOk==YES&&DepartDownOk==YES&&relationDownOk==YES) {
                
                OnlyOneQueue *only=[OnlyOneQueue shareQueue];
                dispatch_async(only.SQLQueue, ^{
                    FMDBManage *manage=[FMDBManage shareManage];
                    [manage refreshUserInfoDataWithArr:modeluserArr];
                    [manage refreshRelationDataWithArr:modelrelationArr];
                    [manage refreshDepartmentDataWithArr:modeldepartArr];
                    NSUserDefaults *userD=[NSUserDefaults standardUserDefaults];
                    [userD setObject:relationRequestTime forKey:@"relationRequestTime"];
                    [userD setObject:userRequestTime forKey:@"userRequestTime"];
                    [userD setObject:departRequestTime forKey:@"departRequestTime"];
                    [userD synchronize];
                    self.isdownLod=NO;
                    block(YES);
                });
            }else{
                self.isdownLod=NO;
                block(NO);
            }
        });
    }
}
-(NSMutableArray *)WriteDataToSQLwithtype:(dataType)datatype andArr:(NSArray *)arr{
    if (datatype==userdataType) {
        NSMutableArray *userArr=[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<arr.count; i++) {
//            UserInfoModel *model=[[UserInfoModel alloc]initWithDictionary:arr[i] error:nil];
//            NSMutableString *user_name=[[NSMutableString alloc]initWithString:model.userName];
//            CFStringTransform(( CFMutableStringRef)user_name, NULL, kCFStringTransformMandarinLatin, NO);
//            CFStringTransform((CFMutableStringRef)user_name, NULL, kCFStringTransformStripDiacritics, NO);
//            [user_name setString:[user_name stringByReplacingOccurrencesOfString:@" " withString:@""]];
//            model.pinyin=user_name;
//            model.phoneNo=[model.phoneNo StringToMD5String];
//            [userArr addObject:model];
        }
        return userArr;
    }
    if (datatype==departdataType) {
        NSMutableArray *departArr=[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<arr.count; i++) {
//            DepartmentModel *model=[[DepartmentModel alloc]initWithDictionary:arr[i] error:nil];
//            [departArr addObject:model];
        }
        return departArr;
    }
    NSMutableArray *relArr=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<arr.count; i++) {
//        RelationModel *model=[[RelationModel alloc]initWithDictionary:arr[i] error:nil];
//        model.telnet=[model.telnet StringToMD5String];
//        model.telNo1=[model.telNo1 StringToMD5String];
//        model.telNo2=[model.telNo2 StringToMD5String];
//        [relArr addObject:model];
    }
    return relArr;
}
@end
