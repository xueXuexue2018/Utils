//
//  DepartmentModel.h
//  Utils
//
//  Created by yuexun on 2018/6/28.
//  Copyright © 2018年 yuexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmentModel : NSObject

@property(nonatomic,strong)NSString *departmentInfoId;      //部门id
@property(nonatomic,strong)NSString *departmentName;        //部门名称
@property(nonatomic,strong)NSString *departmentOrder;       //部门排序
@property(nonatomic,strong)NSString *departmentFullName;    //部门全称
@property(nonatomic,strong)NSString *parentDepartmentId;    //父级部门id
@property(nonatomic,strong)NSString *parentDepartmentName;  //父级部门名称
@property(nonatomic,strong)NSString *note;                  //备注
@property(nonatomic,assign)NSInteger enabled;              //删除标记
@property(nonatomic,assign)NSInteger updateTime;           //最后更新时间
@end
