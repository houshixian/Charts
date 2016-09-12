//
//  ISSChartAxisProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxisProperty.h"

@implementation ISSChartAxisProperty

- (id)init
{
    self = [super init];
    if (self) {
		_needDisplayUnit = FALSE;
		_gridWith = 1.0;
        _strokeWidth = DEFAULT_AXIS_LINE_WIDTH;
        _axisStyle = kDashingNone;
        _textColor  = [UIColor grayColor] ;
        _gridColor = [UIColor grayColor];
        _strokeColor = [UIColor darkGrayColor];
        _labelFont = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (id)initWithAxisProperty:(ISSChartAxisProperty*)axisProperty
{
    self = [super init];
    if (self) {
		_needDisplayUnit = axisProperty.needDisplayUnit;
		_gridWith = axisProperty.gridWith;
        _strokeWidth = axisProperty.strokeWidth;
        _axisStyle = axisProperty.axisStyle;
        _axisType = axisProperty.axisType;
        _textColor = axisProperty.textColor;
        _gridColor = axisProperty.gridColor;
        _strokeColor = axisProperty.strokeColor;
        _labelFont = axisProperty.labelFont;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartAxisProperty *copy = [[ISSChartAxisProperty allocWithZone:zone] initWithAxisProperty:self];
    return copy;
}
@end
