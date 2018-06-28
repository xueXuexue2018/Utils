//
//  PluginModel.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PluginModel : NSObject
@property(nonatomic,strong)NSString     *pluginServerIp;
@property(nonatomic,strong)NSString     *pluginPort;
@property(nonatomic,strong)NSString     *permissionString;   //权限字符串
@property(nonatomic,strong)NSString     *pluginsInfoId;     //主键
@property(nonatomic,strong)NSString     *pluginsName;       //插件名称
@property(nonatomic,strong)NSString     *sourceUrl;         //插件图片下载地址
@property(nonatomic,assign)NSInteger    pluginType;        // 插件类型 ，1属于生活， 2属于政务
@property(nonatomic,strong)NSString     *pluginPhoneLogo;   //图片名称；
@property(nonatomic,strong)NSString     *pluginPhoneHome;   //插件的访问接口
@property(nonatomic,assign)NSInteger    status;            // 1正常   2.下架
@property(nonatomic,assign)NSInteger    enabled;            //是否删除  0表示未删除， －1表示已经删除
@property(nonatomic,assign)NSInteger    updateTime;         //更新时间
@property(nonatomic,assign)NSInteger    developStatus;     //插件是否在开发中 （0表示开发中，1表示已经开发）
@property(nonatomic,strong)NSData       *localPath;         //图片文件

@property(nonatomic,strong)NSString     *pluginOrder;       //排序
@property(nonatomic,assign)NSInteger    jurisdiction;      //判断退休人员是否可以使用（0不可以使用，1可以使用）
@property(nonatomic,assign)NSInteger    temporary;        //判断临时聘请人员是否可以使用（0不可以使用，1可以使用）
@property(nonatomic,strong)NSString     *pluginsCode;     //插件唯一标示
@end
