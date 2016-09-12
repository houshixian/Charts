//
//  ISSChartLineProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineProperty.h"

@implementation ISSChartLineProperty
- (id)init
{
    self = [super init];
    if (self) {
        _lineWidth = DEFAULT_LINE_WIDTH;
        _joinLineWidth = DEFAULT_LINE_JOIN_WIDTH;
        _radius = DEFAULT_RADIUS;
        _pointStyle = ISSChartLinePointJoinCircle;
        _lineJoin = kCGLineJoinMiter;
        _lineCap = kCGLineCapSquare;
        _strokeColor = [UIColor redColor];
        _fillColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithLineProperty:(ISSChartLineProperty*)lineProperty
{
    self = [super init];
    if (self) {
        _lineWidth = lineProperty.lineWidth;
        _joinLineWidth = lineProperty.joinLineWidth;
        _radius = lineProperty.radius;
        _pointStyle = lineProperty.pointStyle;
        _lineCap = lineProperty.lineCap;
        _strokeColor = lineProperty.strokeColor;
        _fillColor = lineProperty.fillColor ;
        _points = [[NSArray alloc] initWithArray:lineProperty.points copyItems:TRUE];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartLineProperty *copy = [[ISSChartLineProperty allocWithZone:zone] initWithLineProperty:self];
    return copy;
}

- (UIColor*)fillColor
{
    if (ISSChartLinePointJoinSolidCircle == _pointStyle||
        ISSChartLinePointJoinSolidRectangle == _pointStyle||
        ISSChartLinePointJoinSolidTriangle == _pointStyle) {
        _fillColor = _strokeColor;
    }
    return _fillColor;
}
@end
