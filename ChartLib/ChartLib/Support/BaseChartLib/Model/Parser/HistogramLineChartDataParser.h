//
//  HistogramLineChartDataParser.h
//  CEBBank
//
//  Created by Sword Zhou on 6/28/13.
//  Copyright (c) 2013 ronglei. All rights reserved.
//

#import "ISSChartParser.h"

@interface HistogramLineChartDataParser : ISSChartParser
@property (nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)NSArray *LinValues;
@property (nonatomic,strong)NSArray *datas;
@property (nonatomic,strong)NSArray *lineValueArray;
- (id)chartData:(NSDictionary*)dataDic chartInfo:(NSDictionary *)dataInfo;
@end
