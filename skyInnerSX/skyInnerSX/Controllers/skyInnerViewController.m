//
//  skyInnerViewController.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyInnerViewController.h"
#import "AppDelegate.h"

@interface skyInnerViewController ()
{
    CGPoint         startCanvas;        // 控制区起始点
    int             nRows;              // 拼接行数
    int             nColumns;           // 拼接列数
    int             nWinWidth;          // 单元宽度
    int             nWinHeight;         // 单元高度
    NSMutableArray *pArrayChess;        // 拼接占位数组
}

////////////////////////// Property /////////////////////////////
// 导航栏属性
@property (strong, nonatomic) UIBarButtonItem *settingButton;               // 导航栏设置按钮
@property (strong, nonatomic) UIBarButtonItem *modelButton;                 // 导航栏情景模式按钮
@property (strong, nonatomic) UIBarButtonItem *externButton;                // 导航栏扩展视图按钮

// 应用程序委托对象
@property (weak, nonatomic) AppDelegate *appDelegate;

////////////////////////// Methods //////////////////////////////
/****************** 初始化处理 *******************/
// 1.初始化导航栏
- (void)initializeNavigationItem;
// 2.初始化弹出视图
- (void)initializePopoverView;
// 3.初始化拼接主控区域
- (void)initializeSpliceArea;
// 4.初始化扩展功能视图
- (void)initializeExternView;
// 5.初始化运行数据
- (void)initializeAppDatas;
// 6.初始化协议适配器
- (void)initializeProtocolAdaptor;

/****************** 导航栏按钮事件 ****************/
// 导航栏设置按钮事件函数
- (void)settingButtonEventHandler:(id)paramSender;
// 情景模式按钮事件函数
- (void)modelButtonEventHandler:(id)paramSender;
// 视图扩展按钮事件函数
- (void)externButtonEventHandler:(id)paramSender;

/****************** 界面处理函数 ******************/
// 界面重新布置
- (void)reloadUI;

////////////////////////// Ends /////////////////////////////////

@end

@implementation skyInnerViewController

// synthesize
@synthesize settingsPopover = _settingsPopover;
@synthesize modelsPopover = _modelsPopover;
@synthesize currentPopover = _currentPopover;
@synthesize settingsNavgation = _settingsNavgation;
@synthesize modelsNavigation = _modelsNavigation;
@synthesize settingMainVC = _settingMainVC;
@synthesize modelVC = _modelVC;
@synthesize settingButton = _settingButton;
@synthesize modelButton = _modelButton;
@synthesize externButton = _externButton;
@synthesize appDelegate = _appDelegate;
@synthesize underPaint = _underPaint;
@synthesize isxWinContainer = _isxWinContainer;
@synthesize spliceTVProtocol = _spliceTVProtocol;

#pragma mark - ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 获取应用程序委托对象
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 初始化运行数据
    [self initializeAppDatas];
    // 初始化导航栏
    [self initializeNavigationItem];
    // 初始化弹出视图
    [self initializePopoverView];
    // 初始化拼接主控区域
    [self initializeSpliceArea];
    // 初始化扩展功能视图
    [self initializeExternView];
    // 初始化协议适配器
    [self initializeProtocolAdaptor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods(Initializeres)
// 1.初始化导航栏
- (void)initializeNavigationItem
{
    // 导航栏左侧设置按钮加入
    self.settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonEventHandler:)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:_settingButton, nil]];
    
    // 导航栏右侧情景模式、扩展视图按钮加入
    self.modelButton = [[UIBarButtonItem alloc] initWithTitle:@"情景模式" style:UIBarButtonItemStylePlain target:self action:@selector(modelButtonEventHandler:)];
    self.externButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbarDrawMode"] style:UIBarButtonItemStylePlain target:self action:@selector(externButtonEventHandler:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_externButton,_modelButton, nil]];
    
    // 应用程序名称、导航栏颜色设定
    self.title = @"创维群欣内置拼接控制系统";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:143.0f/255.0f blue:88.0f/255.0f alpha:1];
}

// 2.初始化弹出视图
- (void)initializePopoverView
{
    /****************** 设置页面弹出视图 **********************/
    // 设置主视图初始
    self.settingMainVC = [[skySettingMainVC alloc] initWithStyle:UITableViewStyleGrouped];
    self.settingsNavgation = [[UINavigationController alloc] initWithRootViewController:_settingMainVC];
    self.settingsNavgation.interactivePopGestureRecognizer.enabled = NO;
    self.settingsPopover = [[UIPopoverController alloc] initWithContentViewController:_settingsNavgation];
    self.settingsPopover.popoverContentSize = CGSizeMake(320.0f, 680.0f);
    
    // 1.add skySettingConnectionVC
    skySettingConnectionVC *mySettingConnection = [[skySettingConnectionVC alloc] initWithNibName:@"skySettingConnection" bundle:nil];
    mySettingConnection.title = @"通讯连接设置";
    mySettingConnection.rowImage = [UIImage imageNamed:@"ConnSet.png"];
    mySettingConnection.myDelegate = self;
    mySettingConnection.myDataSource = _appDelegate.theApp;
    [_settingMainVC.controllers addObject:mySettingConnection];
    
    // 2.add skySettingConfigVC
    skySettingConfigVC *mySettingConfig = [[skySettingConfigVC alloc] initWithNibName:@"skySettingConfig" bundle:nil];
    mySettingConfig.title = @"规格参数设置";
    mySettingConfig.rowImage = [UIImage imageNamed:@"SCXSet.png"];
    mySettingConfig.myDelegate = self;
    mySettingConfig.myDataSource = _appDelegate.theApp;
    [_settingMainVC.controllers addObject:mySettingConfig];
    
    // 3.add skySettingSignalVC
    skySettingSignalVC *mySettingSignal = [[skySettingSignalVC alloc] initWithNibName:@"skySettingSignal" bundle:nil];
    mySettingSignal.title = @"信号设置";
    mySettingSignal.rowImage = [UIImage imageNamed:@"SignalSet.png"];
    mySettingSignal.myDataSource = _appDelegate.theApp;
    [_settingMainVC.controllers addObject:mySettingSignal];
    
    // 4.add skySettingUnitVC
    skySettingUnitVC *mySettingUnit = [[skySettingUnitVC alloc] initWithNibName:@"skySettingUnit" bundle:nil];
    mySettingUnit.title = @"屏幕控制";
    mySettingUnit.rowImage = [UIImage imageNamed:@"ProtocalSet.png"];
    mySettingUnit.myDelegate = self;
    mySettingUnit.myDataSource = _appDelegate.theApp;
    [_settingMainVC.controllers addObject:mySettingUnit];
    // 初始化skySettingUnitVC单元选择视图
    mySettingUnit.selectionView = [[skyUnitSelectionVC alloc] initWithStyle:UITableViewStylePlain];
    mySettingUnit.selectionView.myDelegate = self;
    mySettingUnit.selectionView.myDataSource = _appDelegate.theApp;
    
    /****************** 情景模式弹出视图 **********************/
    self.modelVC = [[skyModelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.modelsNavigation = [[UINavigationController alloc] initWithRootViewController:_modelVC];
    self.modelsPopover = [[UIPopoverController alloc] initWithContentViewController:_modelsNavigation];
    self.modelsPopover.popoverContentSize = CGSizeMake(320.0f, 680.0f);
    
    // 设定当前弹出视图
    _currentPopover = _modelsPopover;
}

// 3.初始化拼接主控区域
- (void)initializeSpliceArea
{
    /***************** 客户区底图初始 ********************/
    self.underPaint = [[skyUnderPaint alloc] initWithFrame:self.view.frame];
    self.underPaint.myDataSource = _appDelegate.theApp;
    [self.view addSubview:_underPaint];
    [_underPaint getUnderPaintSpec];
    startCanvas = [_underPaint getStartCanvasPoint];
    /***************** 客户区窗口初始 ********************/
}

// 4.初始化扩展功能视图
- (void)initializeExternView
{
    
}

// 5.初始化运行数据
- (void)initializeAppDatas
{
    int total;
    //self.externVisible = NO;
    nWinWidth = _appDelegate.theApp.appUnitWidth * 2;
    nWinHeight = _appDelegate.theApp.appUnitHeight * 2;
    nRows = _appDelegate.theApp.appScreenRows;
    nColumns = _appDelegate.theApp.appScreenColumns;
    
    total = nRows *nColumns;
    pArrayChess = [[NSMutableArray alloc] initWithCapacity:total];
    for (int i = 0; i < total; i++)
        [pArrayChess insertObject:[NSNumber numberWithInt:i+1] atIndex:i];
}

// 6.初始化协议适配器
- (void)initializeProtocolAdaptor
{
    
}

#pragma mark - Private Methods(Event Handler)
// 导航栏设置按钮事件函数
- (void)settingButtonEventHandler:(id)paramSender
{
    BOOL bFlag = [_settingsPopover isPopoverVisible];
    
    if (bFlag)
    {
        // 正在显示则隐藏
        [_settingsPopover dismissPopoverAnimated:YES];
    }
    else
    {
        // 没有在当前显示
        [_currentPopover dismissPopoverAnimated:YES];
        [_settingsPopover presentPopoverFromBarButtonItem:_settingButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        _currentPopover = _settingsPopover;
    }
}

// 情景模式按钮事件函数
- (void)modelButtonEventHandler:(id)paramSender
{
    BOOL bFlag = [_modelsPopover isPopoverVisible];
    
    if (bFlag)
    {
        // 正在显示则隐藏
        [_modelsPopover dismissPopoverAnimated:YES];
    }
    else
    {
        // 没显示则关闭其他视图后弹出显示
        [_currentPopover dismissPopoverAnimated:YES];
        [_modelsPopover presentPopoverFromBarButtonItem:_modelButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        _currentPopover = _settingsPopover;
    }
}

// 视图扩展按钮事件函数
- (void)externButtonEventHandler:(id)paramSender
{
    NSLog(@"Extern");
}

// 界面重新布置
- (void)reloadUI
{
    /*********************** 状态数据重置 **************************/
    [_appDelegate.theApp calculateWorkingArea];
    
    NSInteger total;
    //self.externVisible = NO;
    nWinWidth = _appDelegate.theApp.appUnitWidth * 2;
    nWinHeight = _appDelegate.theApp.appUnitHeight * 2;
    nRows = _appDelegate.theApp.appScreenRows;
    nColumns = _appDelegate.theApp.appScreenColumns;
    
    total = nRows *nColumns;
    [pArrayChess removeAllObjects];
    pArrayChess = [[NSMutableArray alloc] initWithCapacity:total];
    for (int i = 0; i < total; i++)
        [pArrayChess insertObject:[NSNumber numberWithInt:i+1] atIndex:i];
    
    // 后台数据删除
    
    /*********************** 客户区上视图移除 ***********************/
    // 移除主控区底图
    [_underPaint removeFromSuperview];
    
    /*********************** 主控区底图绘制 ************************/
    self.underPaint = [[skyUnderPaint alloc] initWithFrame:self.view.frame];
    self.underPaint.myDataSource = _appDelegate.theApp;                 // 指定代理
    [self.view addSubview:self.underPaint];
    [self.underPaint getUnderPaintSpec];
    startCanvas = [_underPaint getStartCanvasPoint];                    // 获取起始点位置
    
    /*********************** 客户区窗口绘制 ************************/
}

#pragma mark - skySettingConnectionVC Delegate
// 连接控制器
- (void)connectToController:(NSString *)ipAddress andPort:(NSInteger)nPort
{
    
}

// 断开控制器
- (void)disconnectController
{
    
}

#pragma mark - skySettingConfigVC Delegate
// 设定行列数
- (void)setScreenRow:(int)nRow andColumn:(int)nColumn
{
    // 界面配置
    [_settingsPopover dismissPopoverAnimated:YES];
    [self reloadUI];
    
    // 协议发送
    [_spliceTVProtocol innerSXSetSpliceRow:nRow andColumn:nColumn];
}

#pragma mark - skyUnitSelectionVC Delegate
// 选择某个机芯单元
- (void)selectOneUnitAtIndex:(int)nIndex
{
    NSLog([NSString stringWithFormat:@"Select Unit %d",nIndex],nil);
}

// 取消选择某个机芯单元
- (void)unSelectOneUnitAtIndex:(int)nIndex
{
    NSLog([NSString stringWithFormat:@"UnSelect Unit %d",nIndex],nil);
}

// 选择全部机芯单元
- (void)selectAllUnit
{
    
}

// 取消全部选择的机芯单元
- (void)unSelectAllUnit
{
    
}

@end
