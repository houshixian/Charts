//
//  ISSChartDashboardLegend.h
//  ChartLib
//
//  Created by Sword on 13-11-5.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartLegendView.h"
#import "ISSChartDashboardData.h"

@interface ISSChartDashboardLegendView : ISSChartLegendView

@property (retain, nonatomic) ISSChartDashboardData *dashData;

- (void)setDashData:(ISSChartDashboardData *)dashData;

@end
