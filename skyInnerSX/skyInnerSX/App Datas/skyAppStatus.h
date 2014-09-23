//
//  skyAppStatus.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "skySettingConnectionVC.h"
#import "skySettingConfigVC.h"

// class skyAppStatus
// DataSource:
//              skySettingConnectionVCDataSource --- 通信设置数据源
//              skySettingConfigVCDataSource     --- 规格设置数据源
//
@interface skyAppStatus : NSObject<skySettingConnectionVCDataSource,skySettingConfigVCDataSource>

@end
