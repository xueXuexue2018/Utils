//
//  DownLoadPlugin.m
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import "DownLoadPlugin.h"

#import "OnlyOneQueue.h"
#import "FMDBManage.h"
@implementation DownLoadPlugin
+(instancetype)ShareDownPlugin{
    static DownLoadPlugin *Plugin=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Plugin=[[DownLoadPlugin alloc]init];
        Plugin.group=dispatch_group_create();
    });
    return Plugin;
}
//首先第一步是下载json，如果json下载失败或者服务器异常，则重新现在
-(void)DownLoadDataWithblock:(void(^)(NSString *plugintime))block andtime:(NSString *)needtime{
    NSString *plugintime;
    
    plugintime=[[NSUserDefaults standardUserDefaults] objectForKey:@"plugintime"];
    if (plugintime==nil) {
        plugintime=@"0";
    }
    
    NSString *content=[[NSUserDefaults standardUserDefaults]objectForKey:@"content"];
    
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage POST:@"" parameters:@{@"session":content,@"updateTime":plugintime} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code=[responseObject[@"code"] integerValue];
        if (code==1) {
            NSString *contentStr=responseObject[@"content"];
            if (contentStr!=nil) {
                NSData *data=[contentStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *contentArr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                long long time=[responseObject[@"requestTime"] longLongValue];
                NSString *nowtime=[NSString stringWithFormat:@"%lld",time];
                
                [self insertAllModelToSQLWith:contentArr andblock:block andtime:nowtime andOldtime:plugintime];
            }
        }else{
            block(plugintime);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(plugintime);
    }];
}
//第二，将所有的model数组储存起来
-(void)insertAllModelToSQLWith:(NSArray *)contentArr andblock:(void(^)(NSString *plugintime))block andtime:(NSString *)time andOldtime:(NSString *)oldtime{
    NSMutableArray *muarr=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<contentArr.count; i++) {
//        PluginModel *model=[[PluginModel alloc]initWithDictionary:contentArr[i] error:nil];
//        [muarr addObject:model];
    }
    OnlyOneQueue *only=[OnlyOneQueue shareQueue];
    dispatch_async(only.SQLQueue, ^{
        FMDBManage *manage=[FMDBManage shareManage];
        BOOL isSuccess=[manage refreshPluginDataWithArr:muarr];  //首先将数据插入表中
        
        if (isSuccess) {
            [self deleteImageFileFromPathWithArr:muarr];
            block(time); // 然后去下载图片
        }else{
            block(oldtime);
        }
    });
}
-(void)deleteImageFileFromPathWithArr:(NSArray *)arr{
    for (PluginModel *model in arr) {
        NSFileManager *filemanage=[NSFileManager defaultManager];
        NSString *path=[@"插件路径" stringByAppendingPathComponent:@"需要移除的字段"];
        [filemanage removeItemAtPath:path error:nil];
    }
}
-(void)insertToLocalWithData:(NSData *)data andModol:(PluginModel *)model{
    NSString *str=[@"插件路径" stringByAppendingPathComponent:@"需要插入的字段"];
    [data writeToFile:str atomically:YES];
    
}
@end
