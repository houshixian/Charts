//
//  SytleThreeViewController.m
//  ChartLib
//
//  Created by ChinaMonkey on 16/4/29.
//  Copyright © 2016年 ChinaMonkey. All rights reserved.
//

#import "SytleThreeViewController.h"
#import "HistogramLineChartDataParser.h"
#import "ISSChartHistogramLineData.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramLineHintView.h"
#import "ISSChartHistogramBarProperty.h"



@interface SytleThreeViewController ()

@property (nonatomic, strong) HistogramLineChartDataParser *chartDataParser;

@property (nonatomic, strong) ISSChartHistogramLineData *histogramLineChartData;
@end

@implementation SytleThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/柱线状图" ofType:@"json"];
    NSDictionary *indicatorDics = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    NSDictionary *dataDic = indicatorDics[@"data"];
    NSDictionary *chartDataDic = dataDic[@"chart_datas"][0];

    _chartDataParser = [[HistogramLineChartDataParser alloc] init];
    _chartDataParser.nameArray = @[@"12",@"23",@"34"];
     _chartDataParser.datas = @[@[@"100",@"200",@"300"],@[@"200",@"300",@"400"],@[@"300",@"300",@"600"],@[@"300",@"300",@"600"]];
    
     _chartDataParser.lineValueArray = @[@[@"0.3",@"0.2",@"0.5"],@[@"0.2",@"0.4",@"0.3"],@[@"0.4",@"0.2",@"0.7"]];
    
    
    _histogramLineChartData = [_chartDataParser chartData:chartDataDic[@"chart_data"][0][@"data"] chartInfo:@{@"isShowIco":@"1"}];
   _histogramLineChartData.legendTextArray = @[@"随便",@"suiu",@"随便",@"suiu",@"随便",@"随便",@"随便"];
    ISSChartCoordinateSystem *coordinateSyste = _histogramLineChartData.coordinateSystem;
    coordinateSyste.leftMargin = 40;
    coordinateSyste.topMargin = 29;
    coordinateSyste.bottomMargin = 30;
    coordinateSyste.rightMargin = 40;
    coordinateSyste.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.viceYAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
    coordinateSyste.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    coordinateSyste.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    
    coordinateSyste.yAxis.axisProperty.strokeWidth = 1.0;
    coordinateSyste.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    [_histogramLineChartData ajustLengendSize:CGSizeMake(15, 15)];
    for (ISSChartLine *line in _histogramLineChartData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        lineProperty.radius = 3;
        lineProperty.lineWidth = 1.0;
        lineProperty.joinLineWidth = 1;
    }

    ISSChartHistogramLineView *histogramLineView = [[ISSChartHistogramLineView alloc] initWithFrame:CGRectMake(0, 100, 949, 236) histogramLineData:_histogramLineChartData];
    __block typeof(self) wealkSelf = self;
    histogramLineView.didSelectedBarBlock = ^ISSChartHintView *(ISSChartHistogramLineView *histogramLineView, ISSChartHistogramBar *bar, NSArray *lines, NSInteger indexOfValueOnLine, ISSChartAxisItem *xAxisItem) {
        return [wealkSelf getHistogramLineHintView:histogramLineView bar:bar lines:lines indexOfValueOnLine:indexOfValueOnLine xAxisItem:xAxisItem];
    };
    
    [self.view addSubview:histogramLineView];
    
    if (histogramLineView && [histogramLineView respondsToSelector:@selector(displayFirstShowAnimation)]) {
        [histogramLineView performSelector:@selector(displayFirstShowAnimation) withObject:nil afterDelay:DELAY_SEC];
    }

}

- (ISSChartHintView*)getHistogramLineHintView:(ISSChartHistogramLineView *)histogramLineView bar:(ISSChartHistogramBar *)bar lines:(NSArray *)lines indexOfValueOnLine:(NSInteger)indexOfValueOnLine xAxisItem:(ISSChartAxisItem *)xAxisItem
{
    
    NSInteger legendArrayIndex = 0;
    //create popView hint data array
    NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
    
    ISSChartHistogramLineData *histogramLineData = histogramLineView.histogramLineData;
    ISSChartHistogramBarGroup *group = [histogramLineData barGroups][indexOfValueOnLine];
    NSArray *legendTextArray = histogramLineData.legendTextArray;
    NSAssert([group isKindOfClass:[ISSChartHistogramBarGroup class]], @"group type must be ISSChartHistogramBarGroup");
    for (int i=0; i<group.bars.count; i++) {
        ISSChartHistogramBar *bar = group.bars[i];
        
        ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
        if(histogramLineData.coordinateSystem.yAxis.axisType == ISSChartAxisTypeValue){
            hintProperty.text = [NSString stringWithFormat:@"%@ %.2f", legendTextArray[i], bar.valueY];
        }else{
            hintProperty.text = [NSString stringWithFormat:@"%@ %.2f", legendTextArray[i], bar.valueY];
        }
        hintProperty.textColor = bar.barProperty.fillColor;
        [hintDatas addObject:hintProperty];
        legendArrayIndex++;
    }
    
    for (ISSChartLine *line in lines) {
        ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
        if(histogramLineData.coordinateSystem.viceYAxis.axisType == ISSChartAxisTypeValue){
            hintProperty.text = [NSString stringWithFormat:@"%@ %.2f",legendTextArray[legendArrayIndex], [line.values[indexOfValueOnLine] doubleValue]];
        }else{
            hintProperty.text = [NSString stringWithFormat:@"%@ %.2f",legendTextArray[legendArrayIndex], [line.values[indexOfValueOnLine] doubleValue]];
        }
        hintProperty.textColor = [[line lineProperty] strokeColor];
        [hintDatas addObject:hintProperty];
        legendArrayIndex++;
    }
    
    NSString *identifier = @"ISSChartHistogramLineHintView";
    ISSChartHistogramLineHintView *hintView = (ISSChartHistogramLineHintView *)[histogramLineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramLineHintView loadFromNib];
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
