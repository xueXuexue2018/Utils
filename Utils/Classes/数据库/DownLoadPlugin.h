//
//  DownLoadPlugin.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
// 下载插件

#import <Foundation/Foundation.h>
@class PluginModel;
@interface DownLoadPlugin : NSObject
@property(nonatomic,assign)NSInteger flag;    //判断是否正常
@property(nonatomic,retain)dispatch_group_t group;

+(instancetype)ShareDownPlugin;
-(void)DownLoadDataWithblock:(void(^)(NSString *plugintime))block andtime:(NSString *)needtime;
-(void)insertToLocalWithData:(NSData *)data andModol:(PluginModel *)model;
@end
