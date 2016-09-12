//
//  LineChartDataParser.h
//  CEBBank
//
//  Created by ronglei on 13-6-27.
//  Copyright (c) 2013年 ronglei. All rights reserved.
//

#import "ISSChartParser.h"

@interface LineChartDataParser : ISSChartParser
@property (nonatomic,strong)NSArray *xNames;
@property (nonatomic,strong) NSMutableArray *lineValueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *legendArray;
- (id)chartData:(NSDictionary*)dataDic chartInfo:(NSDictionary *)dataInfo;
@end
