//
//  HistogramLineChartDataParser.m
//  CEBBank
//
//  Created by Sword Zhou on 6/28/13.
//  Copyright (c) 2013 ronglei. All rights reserved.
//

#import "HistogramLineChartDataParser.h"
#import "ISSChartHistogramLineData.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "UIColor-Expanded.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"

@implementation HistogramLineChartDataParser

- (id)chartData:(NSDictionary*)dataDic chartInfo:(NSDictionary *)dataInfo
{
    BOOL isshow_ico = [dataInfo[@"isShowIco"] boolValue];
    ISSChartHistogramLineData *histogramLineData = [[ISSChartHistogramLineData alloc] init];
    ISSChartCoordinateSystem *coordinateSystem = histogramLineData.coordinateSystem;

    NSDictionary *xaxisDic = dataDic[@"xaxis"];
    if (xaxisDic && [[xaxisDic allKeys] count] > 0) {
        //修改
//        _nameArray = xaxisDic[@"values"];
        [histogramLineData setXAxisItemsWithNames:_nameArray values:nil];
        NSString *axisStrokeColorHexString = xaxisDic[@"stroke_color"];
        
        coordinateSystem.topMargin = 40;
        coordinateSystem.xAxis.name = xaxisDic[@"label"];
        coordinateSystem.xAxis.axisProperty.strokeColor = [UIColor colorWithHexString:axisStrokeColorHexString];
        coordinateSystem.xAxis.axisProperty.gridColor = [UIColor colorWithHexString:axisStrokeColorHexString];
    }
    
    NSDictionary *yaxisDic = dataDic[@"yaxis"];
    if (yaxisDic && [[yaxisDic allKeys] count] > 0) {
        NSString *yxisStrokeColorHexString = yaxisDic[@"stroke_color"];
        coordinateSystem.yAxis.name = yaxisDic[@"label"];
        coordinateSystem.yAxis.axisType = [yaxisDic[@"type"] integerValue];
        coordinateSystem.xAxis.axisProperty.strokeColor = [UIColor colorWithHexString:yxisStrokeColorHexString];
        coordinateSystem.xAxis.axisProperty.gridColor = [UIColor colorWithHexString:yxisStrokeColorHexString];
        coordinateSystem.viceYAxis.axisType = [dataDic[@"vice_yaxis"][@"type"] integerValue];
    }

    
    NSArray *datasDicArray = dataDic[@"datas"];
//    NSMutableArray *datas = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *legendArray = [NSMutableArray array];
    
   
    
    if (datasDicArray && [datasDicArray count] > 0) {
       int i =  [dataInfo[@"data"] integerValue]  ;
        for (NSDictionary *histogramDic in datasDicArray) {
            NSArray *colorsArr  = [self colorArrayWithIndex:i++];  //7.31
//            NSArray *values = histogramDic[@"values"];
//              NSLog(@"%@",values);
//            [legendArray addObject:histogramDic[@"name"]];
            [colors addObject:colorsArr];
            //[UIColor colorWithHexString:colorHexString] 7.28
//            [colors addObject: [UIColor colorWithRed:160.0/255.0 green:197.0/255.0 blue:73.0/255.0 alpha:1]];
            //Kevin Demo
//            [_datas addObject:values];
        }
        
    }
  
    NSArray *lineData = [dataDic objectForKey:@"vice_datas"];
    NSMutableArray *lineColors = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *lineValueArray = [NSMutableArray arrayWithCapacity:0];
    if (lineData && [lineData count] > 0) {
        for (NSDictionary *lineDic in lineData) {
//            [lineValueArray addObject:[lineDic objectForKey:@"values"]];
            [lineColors addObject:[UIColor colorWithHexString:[lineDic objectForKey:@"stroke_color"]]];
            //        [lineColors addObject:[UIColor orangeColor]];
//            [legendArray addObject:lineDic[@"name"]];
        }
        histogramLineData.legendTextArray = legendArray;
        histogramLineData.legendIsShow = isshow_ico;
        [histogramLineData setBarAndLineValues:_datas lineValues:_lineValueArray];
        [histogramLineData setBarFillColors:colors];
        [histogramLineData setLineColors:lineColors];
        
        histogramLineData.legendPosition = ISSChartLegendPositionNone;        //7.25
    }
    
    for (ISSChartLine *line in histogramLineData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        lineProperty.radius = 3;
        lineProperty.lineWidth = 1.0;
        lineProperty.joinLineWidth = 2;
    }
    
    return histogramLineData;
}

- (NSArray *)colorArrayWithIndex:(int) index
{
    index= index==0?arc4random()%3 :(arc4random()%3)+3;
    
    
    NSArray *color = nil;
    switch (index) {
        case 0:
        {
            color = @[[UIColor colorWithRed:253.0/255.0 green:223.0/255.0 blue:103.0/255.0 alpha:1],
                      [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:123.0/255.0 alpha:1],
                      [UIColor colorWithRed:227.0/255.0 green:196.0/255.0 blue:69.0/255.0 alpha:1]
                      ];
        }
            break;
        case 1:
        {
            color = @[[UIColor colorWithRed:97.0/255.0 green:137.0/255.0 blue:198.0/255.0 alpha:1],
                      [UIColor colorWithRed:102.0/255.0 green:142.0/255.0 blue:211.0/255.0 alpha:1],
                      [UIColor colorWithRed:82.0/255.0 green:115.0/255.0 blue:168.0/255.0 alpha:1]
                      ];
        }
            break;
        case 2:
        {
            color =@[[UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:76.0/255.0 alpha:1],
                     [UIColor colorWithRed:255.0/255.0 green:173.0/255.0 blue:100.0/255.0 alpha:1],
                     [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:56.0/255.0 alpha:1]
                     ];
        }
            
            break;
        case 3:{
            color = @[[UIColor colorWithRed:91.0/255.0 green:215.0/255.0 blue:117.0/255.0 alpha:1],
                      [UIColor colorWithRed:83.0/255.0 green:223.0/255.0 blue:114.0/255.0 alpha:1],
                      [UIColor colorWithRed:69.0/255.0 green:190.0/255.0 blue:95.0/255.0 alpha:1]
                      ];
        }
            break;
        case 4:{
            color = @[[UIColor colorWithRed:92.0/255.0 green:213./255.0 blue:224/255.0 alpha:1],
                      [UIColor colorWithRed:111./255.0 green:219./255.0 blue:229./255.0 alpha:1],
                      [UIColor colorWithRed:74./255.0 green:194./255.0 blue:208./255.0 alpha:1]
                      ];
        }
            break;
        case 5:{
            color = @[[UIColor colorWithRed:249./255.0 green:109./255.0 blue:110./255.0 alpha:1],
                      [UIColor colorWithRed:252/255.0 green:112./255.0 blue:113./255.0 alpha:1],
                      [UIColor colorWithRed:232./255.0 green:98./255.0 blue:97./255.0 alpha:1]
                      ];
        }
            break;
    }
    return color;
}


@end
