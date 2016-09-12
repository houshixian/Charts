//
//  HistogramDataParser.h
//  CEBBank
//
//  Created by Sword Zhou on 6/27/13.
//  Copyright (c) 2013 ronglei. All rights reserved.
//

#import "ISSChartParser.h"

@interface HistogramDataParser : ISSChartParser

@property (nonatomic,strong) NSArray *nameArray;
@property (nonatomic,strong)NSArray *values2;
@property (nonatomic,strong)NSMutableArray *legendArray;
- (id)chartData:(NSDictionary*)dataDic chartInfo:(NSDictionary *)dataInfo;

@end
