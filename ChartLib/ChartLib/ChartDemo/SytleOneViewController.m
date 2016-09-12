//
//  SytleOneViewController.m
//  ChartLib
//
//  Created by BaHCy on 16/4/29.
//  Copyright © 2016年 BaHCy. All rights reserved.
//

#import "SytleOneViewController.h"
#import "ISSChartDashboardView.h"
#import "ISSChartDashboardDataParser.h"
#import "ISSChartDashboardData.h"
#import "ISSChartParser.h"
#import "ISSChartPointer.h"
#import "ISSChartCircle.h"
//#import "ISSChartView.h"
@interface SytleOneViewController ()

@property (nonatomic, strong) ISSChartDashboardData *ChartData;
@property (nonatomic, strong) ISSChartDashboardData *ChartDataB;
@property (nonatomic, strong) ISSChartDashboardData *chartData1;

@property (nonatomic, strong) ISSChartDashboardData *ChartDataC;


//@property (nonatomic,strong)ISSChartView *chartView;
@end

@implementation SytleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"马表盘"];
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:view];
    UIView *dashboardBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 465, 236)];
     UIView *dashboardBgView1 = [[UIView alloc] initWithFrame:CGRectMake(250, 200, 465, 236)];
    [view addSubview:dashboardBgView];
     [view addSubview:dashboardBgView1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(400, 0, 100, 50)];
    
    label.text = @"单位：亿";
    [dashboardBgView addSubview:label];
    //读取本地JSON获取数据
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/马表盘" ofType:@"json"];
//    
//    NSLog(@"========%@",path);
//    NSDictionary *indicatorDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
//    
//    ISSChartDashboardDataParser *chartDataParser = [[ISSChartDashboardDataParser alloc] init];
//    
//    NSDictionary *dict  = indicatorDic[@"data"][@"chart_datas"][@"chart_data"];
//    
//    _chartData =  [chartDataParser chartData:dict[@"data"] chartInfo:@{@"isShowIco":@"1"}];
//   
//    NSLog(@"_chartData ======%@",_chartData);
//    CGFloat scale = [UIScreen mainScreen].scale;
//    NSString *imgName = nil;
//    
//    if (scale == 2.0) {
//        _chartData.pointer.image = [UIImage imageNamed:@"pointer@2x.png"];
//        _chartData.circle.image = [UIImage imageNamed:@"circle@2x.png"];
//        imgName = @"board@2x.png";
//        
//    }else{
//        _chartData.pointer.image = [UIImage imageNamed:@"pointer.png"];
//        _chartData.circle.image = [UIImage imageNamed:@"circle.png"];
//        imgName = @"board.png";
//        
//    }
//    _chartData.boardImage = [UIImage imageNamed:imgName];
//    _chartData.maximumValue = 1000;
//    _chartData.minimumValue = 0;
//    _chartData.value = [@"80" intValue];
//  
//    _chartData.valueLabel = @"80";
//    if ((int)_chartData.minimumValue < 0) {
//        
//    }
//    [_chartData ajustLengendSize:CGSizeMake(15, 15)];
//    _chartView = [[ISSChartView alloc]init];
//    _chartView.delegate = self;
    
    _ChartData = [self ISSChartDashboardData:_ChartDataB Value:80];
    
    ISSChartDashboardView *dashBoardView = [[ISSChartDashboardView alloc] initWithFrame:CGRectMake(0, 0, 465 , 236)];
    [dashBoardView setDashboardData:_ChartData];
  [dashboardBgView addSubview:dashBoardView];
    
    
    _ChartDataC = [self ISSChartDashboardData:_chartData1 Value:80];
    ISSChartDashboardView *dashBoardView1 = [[ISSChartDashboardView alloc] initWithFrame:CGRectMake(0, 0, 465 , 236)];
    [dashBoardView1 setDashboardData:_ChartData];
    [dashboardBgView1 addSubview:dashBoardView1];
    
    
//    
//    ISSChartDashboardView *dashBoardView1 = [[ISSChartDashboardView alloc] initWithFrame:CGRectMake(0, 0, 465 , 236)];
//    [dashBoardView1 setDashboardData:_chartData];
//    [dashboardBgView1 addSubview:dashBoardView1];
    
    
    
    
//    if (dashBoardView && [dashBoardView respondsToSelector:@selector(displayFirstShowAnimation)]) {
//        [dashBoardView performSelector:@selector(displayFirstShowAnimation) withObject:nil afterDelay:DELAY_SEC];
//    }
    
}

//-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
//
//    NSLog(@"000000000000000");
//
//}

- (ISSChartDashboardData *)ISSChartDashboardData:(ISSChartDashboardData *)_chartData Value:(NSInteger)value{


    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/马表盘" ofType:@"json"];
    
    NSLog(@"========%@",path);
    NSDictionary *indicatorDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    
    ISSChartDashboardDataParser *chartDataParser = [[ISSChartDashboardDataParser alloc] init];
    
    NSDictionary *dict  = indicatorDic[@"data"][@"chart_datas"][@"chart_data"];
    
    _chartData =  [chartDataParser chartData:dict[@"data"] chartInfo:@{@"isShowIco":@"1"}];
    
    NSLog(@"_chartData ======%@",_chartData);
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *imgName = nil;
    
    if (scale == 2.0) {
        _chartData.pointer.image = [UIImage imageNamed:@"pointer@2x.png"];
        _chartData.circle.image = [UIImage imageNamed:@"circle@2x.png"];
        imgName = @"board@2x.png";
        
    }else{
        _chartData.pointer.image = [UIImage imageNamed:@"pointer.png"];
        _chartData.circle.image = [UIImage imageNamed:@"circle.png"];
        imgName = @"board.png";
        
    }
    _chartData.boardImage = [UIImage imageNamed:imgName];
    _chartData.maximumValue = 1000;
    _chartData.minimumValue = 0;
    _chartData.value = [@"80" intValue];
    
    _chartData.valueLabel = @"80";
    if ((int)_chartData.minimumValue < 0) {
        
    }
    [_chartData ajustLengendSize:CGSizeMake(15, 15)];


    return _chartData;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
