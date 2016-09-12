//
//  StyleFourViewController.m
//  ChartLib
//
//  Created by BaHCy on 16/4/29.
//  Copyright © 2016年 BaHCy. All rights reserved.
//

#import "StyleFourViewController.h"
#import "HistogramDataParser.h"
#import "ISSChartHistogramData.h"
#import "ISSChartHistogramView.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartHistogramHintView.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartAxisItem.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartAxisProperty.h"


@interface StyleFourViewController ()

@property (nonatomic, strong) HistogramDataParser *histogramDataParser;

@property (nonatomic, strong) ISSChartHistogramData *chartHistogramData;
@end

@implementation StyleFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/柱状图" ofType:@"json"];
    NSDictionary *indicatorDics = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    NSDictionary *dataDic = indicatorDics[@"data"];
    NSDictionary *chartDataDic = dataDic[@"chart_datas"][0];
    
    _histogramDataParser = [[HistogramDataParser alloc] init];

    NSArray * array = @[@"10",@"23",@"10",@"20"];
    NSArray * array1 = @[@"陕西省行",@"西安分行",@"陕西省行",@"西安分行"];
    _histogramDataParser.values2 = array;
    _histogramDataParser.nameArray = array1;

    _chartHistogramData = [_histogramDataParser chartData:chartDataDic[@"chart_data"][0][@"data"] chartInfo:@{@"isShowIco":@"1"}];
    //修改说明标题
    _chartHistogramData.legendTextArray = @[@"同期值"];
    _chartHistogramData.legendIsShow = YES;
    ISSChartCoordinateSystem *coordinateSystem = _chartHistogramData.coordinateSystem;
    
    
    //在这 改Y轴坐标坐标刻度的宽度
    coordinateSystem.leftMargin = 100;
    coordinateSystem.topMargin = 24;
    coordinateSystem.bottomMargin = 10; //10.27
    coordinateSystem.rightMargin = 33;
    // coordinateSystem.xAxis.rotateAngle = 310;
    coordinateSystem.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSystem.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//    最大值 最小值
    coordinateSystem.yAxis.maxValue =  300;
    coordinateSystem.yAxis.minValue =  0;
    [_chartHistogramData ajustLengendSize:CGSizeMake(15, 15)];
    
    
    __block typeof(self) weakSelf = self;
    ISSChartHistogramView *histogramView = [[ISSChartHistogramView alloc] initWithFrame:CGRectMake(100, 100, 800, 336) histogram:_chartHistogramData];
    histogramView.didSelectedBarBlock = ^ISSChartHintView *(ISSChartHistogramView *histogramView, ISSChartHistogramBar *bar, ISSChartAxisItem *xAxisItem) {
        return [weakSelf getHistogramHintView:histogramView bar:bar xAxisItem:xAxisItem];
    };
    
    [self.view addSubview:histogramView];
    
    if (histogramView && [histogramView respondsToSelector:@selector(displayFirstShowAnimation)]) {
        [histogramView performSelector:@selector(displayFirstShowAnimation) withObject:nil afterDelay:DELAY_SEC];
    }
}


- (ISSChartHintView*)getHistogramHintView:(ISSChartHistogramView*)histogramView
                                      bar:(ISSChartHistogramBar *)bar xAxisItem:(ISSChartAxisItem*)axisItem
{
    NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
    ISSChartHistogramData *histogramData = histogramView.histogramData;
    ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
    if(histogramData.coordinateSystem.yAxis.axisType == ISSChartAxisTypeValue){
        hintProperty.text = [NSString stringWithFormat:@"%@ %.2f", histogramData.legendTextArray[bar.index],bar.valueY];
    }
    else{
        hintProperty.text = [NSString stringWithFormat:@"%@ %.2f", histogramData.legendTextArray[bar.index],bar.valueY];
    }
    hintProperty.textColor = bar.barProperty.fillColor;
    [hintDatas addObject:hintProperty];
    NSString *identifier = @"ISSChartHistogramHintView";
    ISSChartHistogramHintView *hintView = (ISSChartHistogramHintView*)[histogramView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramHintView loadFromNib];
        NSLog(@"ISSChartHistogramHintView 加载");
    }
    hintView.hintsArray = hintDatas;
    return hintView;
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
