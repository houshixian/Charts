
//
//  TwoLineView.m
//  线和柱
//
//  Created by zhugy on 16/9/7.
//  Copyright © 2016年 hsx. All rights reserved.
//

#import "TwoLineView.h"

#import "HistogramLineChartDataParser.h"
#import "ISSChartHistogramLineData.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "TwoLineCountView.h"

//#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramLineHintView.h"
#import "ISSChartHistogramBarProperty.h"

#import "ISSChartLineData.h"
#import "LineChartDataParser.h"
//#import "ISSChartLineView.h"
#import "TwoLeftLineCountView.h"
#import "ISSChartLineHintView.h"

@interface TwoLineView ()


@property (nonatomic, strong) HistogramLineChartDataParser *chartDataParser;

@property (nonatomic, strong) ISSChartHistogramLineData *histogramLineChartData;


@property (nonatomic, strong) ISSChartLineData *lineData;

@property (nonatomic, strong) LineChartDataParser *lineChartParser;

@property(nonatomic,strong)NSMutableArray *BarArray;

@property(nonatomic,strong)NSMutableArray *XasiArray;

@end


@implementation TwoLineView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self createTwoLine];
    }
    return self;
}

- (void)createTwoLine{
    
    _BarArray = [NSMutableArray array];
    _XasiArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/线柱组合" ofType:@"json"];
    NSDictionary *indicatorDics = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    
    NSLog(@"%@",indicatorDics);
    
    
    
    
    NSInteger grounp1 = [indicatorDics[@"groupnumber1"] integerValue];
    NSInteger grounp2 = [indicatorDics[@"groupnumber2"] integerValue];
    NSArray *dataArray = indicatorDics[@"data"];
    NSMutableArray *KeyArray = [NSMutableArray array];
    NSMutableArray *ValueArray = [NSMutableArray array];
    NSMutableArray *ValueArray1 = [NSMutableArray array];
    NSMutableArray *ValueArray2 = [NSMutableArray array];
    NSMutableArray *ValueArray3 = [NSMutableArray array];
    
    NSMutableArray *arrayBar = [NSMutableArray array];
    NSMutableArray *arrayLine = [NSMutableArray array];
    NSMutableArray *NameArray = [NSMutableArray array];
    
    
    for (NSDictionary *dict in dataArray) {
        
        if (grounp1 == 1) {
            [KeyArray addObject:dict[@"K"]];
            [ValueArray addObject:dict[@"V0"]];
            
            
        }else if (grounp1 == 2){
            
            [KeyArray addObject:dict[@"K"]];
            [ValueArray addObject:dict[@"V0"]];
            [ValueArray1 addObject:dict[@"V1"]];
            
            
        }
        
        if (grounp2 == 1) {
            
            [ValueArray2 addObject:dict[@"V2"]];
            
            
        }else if (grounp2 == 2){
            [ValueArray2 addObject:dict[@"V2"]];
            
            [ValueArray3 addObject:dict[@"V3"]];
            
            
        }
        
        
    }
    
    if (grounp1 == 1&&grounp2 == 1) {
        [NameArray addObject:indicatorDics[@"name1"]];
        [NameArray addObject:indicatorDics[@"name2"]];
        
        [arrayBar addObject:ValueArray];
        [arrayLine addObject:ValueArray2];
        
    }else if (grounp1 == 1&&grounp2 == 2){
        [NameArray addObject:indicatorDics[@"name1"]];
        [NameArray addObject:indicatorDics[@"name2"]];
        [NameArray addObject:indicatorDics[@"name3"]];
        [arrayBar addObject:ValueArray];
        [arrayLine addObject:ValueArray2];
        [arrayLine addObject:ValueArray3];
    }else if(grounp1 == 2 && grounp2==1){
        
        [NameArray addObject:indicatorDics[@"name1"]];
        [NameArray addObject:indicatorDics[@"name2"]];
        [NameArray addObject:indicatorDics[@"name3"]];
        [arrayBar addObject:ValueArray];
        [arrayBar addObject:ValueArray1];
        [arrayLine addObject:ValueArray2];
    } else if (grounp1 == 2 && grounp2==2){
        [NameArray addObject:indicatorDics[@"name1"]];
        [NameArray addObject:indicatorDics[@"name2"]];
        [NameArray addObject:indicatorDics[@"name3"]];
        [NameArray addObject:indicatorDics[@"name4"]];
        [arrayBar addObject:ValueArray];
        [arrayBar addObject:ValueArray1];
        [arrayLine addObject:ValueArray2];
        [arrayLine addObject:ValueArray3];
    }
    
    NSLog(@"%@",arrayBar);
    NSLog(@"%@",arrayLine);
    _BarArray =arrayBar;
    _XasiArray =KeyArray;
    [self createLine];
    
    [self createLinBarNameArray:NameArray BarDataArray:arrayBar LinDataArray:arrayLine XAisName:KeyArray];
    
    
    
    
    
}


- (void)createLine{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/线" ofType:@"json"];
    NSDictionary *indicatorDics = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    
    NSDictionary *dataDic = indicatorDics[@"data"][@"chart_datas"][@"chart_data"][0][@"data"];
    
    //修改折线图数据
    
    _lineChartParser = [[LineChartDataParser alloc] init];
    NSArray * array = _BarArray;
    
    
    _lineChartParser.xNames = _XasiArray;
    _lineChartParser.lineValueArray =[NSMutableArray arrayWithArray:array];
    
    _lineData = [_lineChartParser chartData:dataDic chartInfo:@{@"isShowIco":@"1"}];
    //    _lineData.legendTextArray = @[@"同期值"];
    
    
    ISSChartCoordinateSystem *coordinateSyste = _lineData.coordinateSystem;
    coordinateSyste.leftMargin = 40;
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
    coordinateSyste.yAxis.maxValue =  [_lineData getMaxYValue];
    coordinateSyste.yAxis.minValue =  [_lineData getMinYValue];
    [_lineData ajustLengendSize:CGSizeMake(15, 15)];
    
    TwoLeftLineCountView *lineView = [[TwoLeftLineCountView alloc] initWithFrame:CGRectMake(0, 110, 949, 236) lineData:_lineData];
    
    //    __block typeof(self) wealkSelf = self;
    //    lineView.didSelectedLines = ^ISSChartHintView *(ISSChartLineView *lineView, NSArray *lines, NSInteger index, ISSChartAxisItem *xAxisItem) {
    //        return [wealkSelf getChartLineHintView:lineView lines:lines valueIndex:index xaxisItem:xAxisItem];
    //    };
    //
    
    [self addSubview:lineView];
    
    if (lineView && [lineView respondsToSelector:@selector(displayFirstShowAnimation)]) {
        [lineView performSelector:@selector(displayFirstShowAnimation) withObject:nil afterDelay:DELAY_SEC];
    }
    
    
    
}
//- (ISSChartHintView*)getChartLineHintView:(ISSChartLineView *)lineView lines:(NSArray*)lines
//                               valueIndex:(NSInteger)index xaxisItem:(ISSChartAxisItem *)xAxisItem
//{
//    //create popView hint data array
//    NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
//    ISSChartLineData *lineData = lineView.lineData;
//    ISSChartCoordinateSystem *coordinateSystem = lineData.coordinateSystem;
//    for (NSInteger i = 0; i < [lines count]; i++) {
//        ISSChartLine *line = lines[i];
//        if (index < line.values.count) {
//            ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
//            if(coordinateSystem.yAxis.axisType == ISSChartAxisTypeValue){
//                NSString *str = [NSString stringWithFormat:@"%@",line.values[index]];
//                double strD = [str doubleValue];
//                str = [NSString stringWithFormat:@"%.2f",strD];
//                hintProperty.text = [NSString stringWithFormat:@"%@ %@",lineData.legendTextArray[i],str];
//            }
//            else {
//                hintProperty.text = [NSString stringWithFormat:@"%@ %@",lineData.legendTextArray[i],[self decimalwithFormat:@"0.00" floatV:[line.values[index] floatValue]]];
//            }
//            hintProperty.textColor = [[line lineProperty] strokeColor];
//            [hintDatas addObject:hintProperty];
//        }
//    }
//
//    NSString *identifier = @"ISSChartLineHintView";
//    ISSChartLineHintView *hintView = (ISSChartLineHintView *)[lineView dequeueHintViewWithIdentifier:identifier];
//    if (!hintView) {
//        hintView = [ISSChartLineHintView loadFromNib];
//    }
//    hintView.hintsArray = hintDatas;
//    return hintView;
//}
//
//- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
//{
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//
//    [numberFormatter setPositiveFormat:format];
//
//    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
//}


- (void)createLinBarNameArray:(NSMutableArray *)nameArray BarDataArray:(NSMutableArray *)BarDataArray LinDataArray:(NSMutableArray *)LinDataArray XAisName:(NSMutableArray *)XAisName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"source/柱线状图" ofType:@"json"];
    NSDictionary *indicatorDics = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    NSDictionary *dataDic = indicatorDics[@"data"];
    NSDictionary *chartDataDic = dataDic[@"chart_datas"][0];
    
    _chartDataParser = [[HistogramLineChartDataParser alloc] init];
    
    //    _chartDataParser.nameArray = @[@"12",@"23",@"34"];
    _chartDataParser.nameArray = XAisName;
    _chartDataParser.datas = BarDataArray;
    _chartDataParser.lineValueArray = LinDataArray;
    _histogramLineChartData = [_chartDataParser chartData:chartDataDic[@"chart_data"][0][@"data"] chartInfo:@{@"isShowIco":@"1"}];
    _histogramLineChartData.legendTextArray = nameArray;
    
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
    coordinateSyste.yAxis.minValue = 100;
    //    coordinateSyste.yAxis.maxValue = 5000;
    coordinateSyste.yAxis.axisProperty.strokeWidth = 1.0;
    coordinateSyste.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    [_histogramLineChartData ajustLengendSize:CGSizeMake(15, 15)];
    for (ISSChartLine *line in _histogramLineChartData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        lineProperty.radius = 3;
        lineProperty.lineWidth = 1.0;
        lineProperty.joinLineWidth = 1;
    }
    
    TwoLineCountView *histogramLineView = [[TwoLineCountView alloc] initWithFrame:CGRectMake(0, 100, 955, 236) histogramLineData:_histogramLineChartData];
    __block typeof(self) wealkSelf = self;
    histogramLineView.didSelectedBarBlock = ^ISSChartHintView *(TwoLineCountView *histogramLineView, ISSChartHistogramBar *bar, NSArray *lines, NSInteger indexOfValueOnLine, ISSChartAxisItem *xAxisItem) {
        return [wealkSelf getHistogramLineHintView:histogramLineView bar:bar lines:lines indexOfValueOnLine:indexOfValueOnLine xAxisItem:xAxisItem];
    };
    
    [self addSubview:histogramLineView];
    
    if (histogramLineView && [histogramLineView respondsToSelector:@selector(displayFirstShowAnimation)]) {
        [histogramLineView performSelector:@selector(displayFirstShowAnimation) withObject:nil afterDelay:DELAY_SEC];
    }
    
    
    
    
    
}





- (ISSChartHintView*)getHistogramLineHintView:(TwoLineCountView *)histogramLineView bar:(ISSChartHistogramBar *)bar lines:(NSArray *)lines indexOfValueOnLine:(NSInteger)indexOfValueOnLine xAxisItem:(ISSChartAxisItem *)xAxisItem
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



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
