//
//  LineChartDataParser.m
//  CEBBank
//
//  Created by ronglei on 13-6-27.
//  Copyright (c) 2013年 ronglei. All rights reserved.
//

#import "LineChartDataParser.h"
#import "ISSChartConsts.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartLineData.h"
#import "ISSChartCoordinateSystem.h"
#import "UIColor-Expanded.h"

@implementation LineChartDataParser

- (id)chartData:(NSDictionary*)dataDic chartInfo:(NSDictionary *)dataInfo
{
    BOOL isshow_ico = [dataInfo[@"isShowIco"] boolValue];
    //_xNames = [[dataDic objectForKey:@"xaxis"] objectForKey:@"values"];
    NSLog(@"_xNames =========%@",_xNames);
    NSArray *lineData = [dataDic objectForKey:@"datas"];
    _legendArray = [NSMutableArray arrayWithCapacity:0];
   _colorArray = [NSMutableArray arrayWithCapacity:0];
//    _lineValueArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in lineData) {
        [_legendArray addObject:[dic objectForKey:@"name"]];
        [_colorArray addObject:[UIColor colorWithHexString:[dic objectForKey:@"stroke_color"]]];
//        [_lineValueArray addObject:[dic objectForKey:@"values"]];
    }
    ISSChartLineData *lineChartData = [[ISSChartLineData alloc] init];
    [lineChartData setXAxisItemsWithNames:_xNames values:nil];
    lineChartData.legendTextArray = _legendArray;
    lineChartData.legendIsShow = isshow_ico;
    [lineChartData setLineColors:_colorArray];
    
    lineChartData.coordinateSystem.yAxis.axisType = [[[dataDic objectForKey:@"yaxis"] objectForKey:@"type"] intValue];    
    [lineChartData setValues:_lineValueArray];
    lineChartData.legendPosition = ISSChartLegendPositionNone;

    ISSChartCoordinateSystem *coordinateSyste = lineChartData.coordinateSystem;
    coordinateSyste.leftMargin = 40;
    coordinateSyste.topMargin = 40;
    coordinateSyste.bottomMargin = 47;
    coordinateSyste.rightMargin = 33;
    for (ISSChartLine *line in lineChartData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        lineProperty.radius = 2;
        lineProperty.lineWidth = 1.0;
        lineProperty.joinLineWidth = 1;
    }
    coordinateSyste.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
    coordinateSyste.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
    coordinateSyste.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
    coordinateSyste.yAxis.axisProperty.strokeWidth = 1.0;
    coordinateSyste.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);    

    return lineChartData;
}

@end
