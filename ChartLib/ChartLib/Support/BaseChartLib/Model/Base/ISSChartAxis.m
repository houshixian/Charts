//
//  ISSAxis.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartAxisItem.h"

@implementation ISSChartAxis

@synthesize valueRange = _valueRange;

- (id)init
{
    self = [super init];
    if (self) {
        _baseValue = CGFLOAT_MAX;
        _axisType = ISSChartAxisTypeValue;
        _axisProperty = [[ISSChartAxisProperty alloc] init];
    }
    return self;
}

- (id)initWithAxis:(ISSChartAxis*)axis
{
    self = [super init];
    if (self) {
        _rotateAngle = axis.rotateAngle;
        _baseValue = axis.baseValue;
        _minValue = axis.minValue;
        _maxValue = axis.maxValue;
        _valueRange = axis.valueRange;
        _name = [axis.name copy];
        _unit = [axis.unit copy];
        _axisProperty = [axis.axisProperty copy];
        _axisItems = [axis.axisItems copy];
        _axisType = axis.axisType;
            
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartAxis *copy = [[ISSChartAxis allocWithZone:zone] initWithAxis:self];
    return copy;
}

#pragma mark - public methods
- (CGFloat)valueRange
{    
    return fabs(_maxValue - _minValue);
}

- (void)setAxisItemsWithNames:(NSArray*)names
{
    [self setAxisItemsWithNames:names values:nil];
}

- (void)setAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    self.axisItems = [ISSChartAxisItem axisItemsWithNames:names values:values];    
    _minValue = CGFLOAT_MAX;
    _maxValue = CGFLOAT_MIN;//CGFLOAT_MIN;
    for (ISSChartAxisItem *axisItem in _axisItems) {
        if (axisItem.value > _maxValue) {
            _maxValue = axisItem.value;
        }
        if (axisItem.value < _minValue) {
            _minValue = axisItem.value;
        }
    }
	if (CGFLOAT_MAX == _baseValue) {
		_baseValue = _minValue;
		if (_minValue < 0) {
			_baseValue = 0;
		}
	}
}
@end
