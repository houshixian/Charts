//
//  HistogramDataParser.m
//  CEBBank
//
//  Created by Sword Zhou on 6/27/13.
//  Copyright (c) 2013 ronglei. All rights reserved.
//

#import "HistogramDataParser.h"
#import "ISSChartHistogramData.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "UIColor-Expanded.h"

@implementation HistogramDataParser

- (id)chartData:(NSDictionary*)dataDic chartInfo:(NSDictionary *)dataInfo
{
    BOOL isshow_ico = [dataInfo[@"isShowIco"] boolValue];
    ISSChartHistogramData *histogramData = [[ISSChartHistogramData alloc] init];
    NSDictionary *xaxisDic = dataDic[@"xaxis"];
    //NSArray *nameArray = xaxisDic[@"values"];
    [histogramData setXAxisItemsWithNames:_nameArray values:nil];
//    NSString *axisStrokeColorHexString = xaxisDic[@"stroke_color"];
    
    ISSChartCoordinateSystem *coordinateSystem = histogramData.coordinateSystem;
    
    coordinateSystem.xAxis.name = xaxisDic[@"label"];
    coordinateSystem.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);  //[UIColor colorWithHexString:axisStrokeColorHexString];
    coordinateSystem.xAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);//[UIColor colorWithHexString:axisStrokeColorHexString];
    
    NSDictionary *yaxisDic = dataDic[@"yaxis"];
//    NSString *yxisStrokeColorHexString = yaxisDic[@"stroke_color"];
    coordinateSystem.yAxis.name = yaxisDic[@"label"];
    coordinateSystem.yAxis.axisType = [yaxisDic[@"type"] integerValue];
    coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);//[UIColor colorWithHexString:yxisStrokeColorHexString];
    coordinateSystem.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);//[UIColor colorWithHexString:yxisStrokeColorHexString];
    coordinateSystem.yAxis.axisProperty.strokeWidth =1;
    
    NSArray *datasDicArray = dataDic[@"datas"];
    
//    NSString *colorHexString;
    NSMutableArray *datas = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    _legendArray = [NSMutableArray array];
    for (NSDictionary *histogramDic in datasDicArray) {
       // NSArray *values2 = histogramDic[@"values"];
        NSMutableArray *values =[NSMutableArray array];
        for (NSNumber *value in _values2) {
            NSString *str = [NSString stringWithFormat:@"%.2f",[value doubleValue]];
            [values addObject:str];
        }
        
//        NSLog(@"%.2f",[value doubleValue]);
        
        [_legendArray addObject:histogramDic[@"name"]];
        
        
//        colorHexString = histogramDic[@"stroke_color"];
        int i  = [dataInfo[@"color"] intValue];
        
        NSArray *colorArr = [self colorArrayIndex:i];
        [colors addObject:colorArr];
//        [colors addObject:@[[UIColor colorWithHexString:colorHexString]]];    //7.31
        [datas addObject:values];
    }
    histogramData.legendTextArray = _legendArray;
    histogramData.legendIsShow = isshow_ico;
    [histogramData setBarDataValues:datas];
    [histogramData setBarFillColors:colors];
    histogramData.legendPosition = ISSChartLegendPositionBottom;
    return histogramData;
}

- (NSArray *)colorArrayIndex:(int) index
{
    
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
