//
//  ISSChartDashboardLegend.m
//  ChartLib
//
//  Created by Sword on 13-11-5.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardLegendView.h"

#import "ISSChartLegendView.h"
#import "ISSChartLegendUnitView.h"
#import "ISSChartLegendUnitView.h"
#import "ISSChartLegend.h"

@implementation ISSChartDashboardLegendView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self recyleAllLegendUnitViews];
    NSInteger count = [_legendArray count];
    ISSChartLegendUnitView *unitView;
	ISSChartLegend *legend;
    for (NSInteger i = 0; i < count; i++) {
        unitView = [self dequeueRecyledLegendUnitView];
		legend = _legendArray[i];
        if (!unitView) {
			unitView = [[ISSChartLegendUnitView alloc] initWithFrame:CGRectZero];
        }
        unitView.frame = [self getLegendUnitFrame:i];
        unitView.legend = legend;
        [_legendUnitViewSet addObject:unitView];
        [unitView setNeedsDisplay];
        [self addSubview:unitView];
    }
}

- (ISSChartLegendUnitView*)dequeueRecyledLegendUnitView
{
    ISSChartLegendUnitView *unitView = [_legendUnitViewRecyledSet anyObject];
    if (unitView) {
        [_legendUnitViewRecyledSet removeObject:unitView];
    }
    return unitView;
}

- (void)setLegendArray:(NSArray *)legendArray
{
    [self recyleAllLegendUnitViews];
    _legendArray = legendArray ;
    [self setNeedsLayout];
}

- (void)setDashData:(ISSChartDashboardData *)dashData;
{
    [self recyleAllLegendUnitViews];
    _dashData = dashData;
	
	self.direction = [_dashData getLegendDirection];
    self.legendArray = _dashData.legends;
    [self setNeedsLayout];
}
@end
