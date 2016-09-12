//
//  StyleTwoViewController.m
//  ChartLib
//
//  Created by BaHCy on 16/4/29.
//  Copyright © 2016年 BaHCy. All rights reserved.
//  

#import "StyleTwoViewController.h"
#import "ISSChartLineData.h"
#import "LineChartDataParser.h"
#import "ISSChartLineView.h"
#import "ISSChartLine.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartLineHintView.h"
#import "ISSChartAxis.h"
#import "ISSChartLineProperty.h"
#import "ISSChartAxisProperty.h"
#define color @[@[UIColor colorWithRed:(221)/255.0f green:(21)/255.0f blue:(182)/255.0f alpha:1],@[UIColor colorWithRed:(221)/255.0f green:(21)/255.0f blue:(182)/255.0f alpha:1],@[UIColor colorWithRed:(221)/255.0f green:(21)/255.0f blue:(182)/255.0f alpha:1]]
@interface StyleTwoViewController ()

@property (nonatomic, strong) ISSChartLineData *lineData;

@property (nonatomic, strong) LineChartDataParser *lineChartParser;

@end

@implementation StyleTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/线" ofType:@"json"];
    NSDictionary *indicatorDics = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    
    NSDictionary *dataDic = indicatorDics[@"data"][@"chart_datas"][@"chart_data"][0][@"data"];
    
   //修改折线图数据
    
     _lineChartParser = [[LineChartDataParser alloc] init];
    NSArray * array = @[@[@"0",@"0.2",@"0",@"0.2"],@[@"0.5",@"300",@"0.5",@"0.6"],@[@"0",@"0.1",@"0.2",@"0.3"]];
     NSArray * array1 = @[@"03-02",@"05-06",@"03-02",@"05-06"];
    NSArray *array3 = @[@[[UIColor colorWithRed:(221)/255.0f green:(21)/255.0f blue:(182)/255.0f alpha:1]],@[[UIColor colorWithRed:(221)/255.0f green:(21)/255.0f blue:(182)/255.0f alpha:1]],@[[UIColor colorWithRed:(221)/255.0f green:(21)/255.0f blue:(182)/255.0f alpha:1]]];
    _lineChartParser.xNames = array1;
    _lineChartParser.lineValueArray =[NSMutableArray arrayWithArray:array];
    _lineChartParser.colorArray = [NSMutableArray arrayWithArray:array3];
    _lineData = [_lineChartParser chartData:dataDic chartInfo:@{@"isShowIco":@"1"}];
    _lineData.legendTextArray = @[@"同期值",@"本期值",@"随便"];
//    _lineData.lineDataArrays = array;
//    [_lineData setValues:array];
    
    ISSChartCoordinateSystem *coordinateSyste = _lineData.coordinateSystem;
    coordinateSyste.leftMargin = 100;
    coordinateSyste.topMargin = 29;
    coordinateSyste.bottomMargin = 30;      //30
    coordinateSyste.rightMargin = 33;
    for (ISSChartLine *line in _lineData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        lineProperty.radius = 3;
        lineProperty.lineWidth = 1.0;
        lineProperty.joinLineWidth = 1;
    }
    coordinateSyste.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
    coordinateSyste.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    coordinateSyste.yAxis.axisProperty.strokeWidth = 1.0;
    coordinateSyste.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    
//    coordinateSyste.xAxis.minValue = 10.0;
//    coordinateSyste.xAxis.maxValue = 200.0;
 coordinateSyste.yAxis.maxValue =  300;
  coordinateSyste.yAxis.minValue =  0;
    [_lineData ajustLengendSize:CGSizeMake(15, 15)];
    
    UIView *lineBgView = [[UIView alloc] initWithFrame:CGRectMake(100,100 ,800 , 300)];
    
    ISSChartLineView *lineView = [[ISSChartLineView alloc] initWithFrame:CGRectMake(0, 0, 800, 300) lineData:_lineData];
    __block typeof(self) wealkSelf = self;
    lineView.didSelectedLines = ^ISSChartHintView *(ISSChartLineView *lineView, NSArray *lines, NSInteger index, ISSChartAxisItem *xAxisItem) {
        return [wealkSelf getChartLineHintView:lineView lines:lines valueIndex:index xaxisItem:xAxisItem];
    };

    [lineBgView addSubview:lineView];
    [self.view addSubview:lineBgView];
    
    if (lineView && [lineView respondsToSelector:@selector(displayFirstShowAnimation)]) {
        [lineView performSelector:@selector(displayFirstShowAnimation) withObject:nil afterDelay:DELAY_SEC];
    }
   
}

- (ISSChartHintView*)getChartLineHintView:(ISSChartLineView *)lineView lines:(NSArray*)lines
                               valueIndex:(NSInteger)index xaxisItem:(ISSChartAxisItem *)xAxisItem
{
    //create popView hint data array
    NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
    ISSChartLineData *lineData = lineView.lineData;
    ISSChartCoordinateSystem *coordinateSystem = lineData.coordinateSystem;
    for (NSInteger i = 0; i < [lines count]; i++) {
        ISSChartLine *line = lines[i];
        if (index < line.values.count) {
            ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
            if(coordinateSystem.yAxis.axisType == ISSChartAxisTypeValue){
                NSString *str = [NSString stringWithFormat:@"%@",line.values[index]];
                double strD = [str doubleValue];
                str = [NSString stringWithFormat:@"%.2f",strD];
                hintProperty.text = [NSString stringWithFormat:@"%@ %@",lineData.legendTextArray[i],str];
            }
            else {
                hintProperty.text = [NSString stringWithFormat:@"%@ %@",lineData.legendTextArray[i],[self decimalwithFormat:@"0.00" floatV:[line.values[index] floatValue]]];
            }
            hintProperty.textColor = [[line lineProperty] strokeColor];
            [hintDatas addObject:hintProperty];
        }
    }
    
    NSString *identifier = @"ISSChartLineHintView";
    ISSChartLineHintView *hintView = (ISSChartLineHintView *)[lineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartLineHintView loadFromNib];
    }
    hintView.hintsArray = hintDatas;
    return hintView;
}

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
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
