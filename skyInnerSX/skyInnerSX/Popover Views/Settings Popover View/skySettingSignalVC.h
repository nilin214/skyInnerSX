//
//  skySettingSignalVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"
#import "skyMatrixMain.h"

// class skySettingSignalVC
@interface skySettingSignalVC : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

//////////////////////// Property /////////////////////////////
@property (strong, nonatomic) NSMutableArray *matrixs;          // Signal Setting页面内控制器装载容器

//////////////////////// Methods //////////////////////////////

//////////////////////// Ends /////////////////////////////////

@end
