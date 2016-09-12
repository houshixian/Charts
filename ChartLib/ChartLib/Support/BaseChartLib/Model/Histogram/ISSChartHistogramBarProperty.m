//
//  ISSBarProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramBarProperty.h"
#import "UIColor-Expanded.h"

@implementation ISSChartHistogramBarProperty

- (NSDictionary*)attributeMapDictionary
{
    return @{@"strokeColor":@"strokeColor",
             @"fillColor":@"fillColor",
             @"gradientStartColor":@"gradientStartColor",
             @"gradientEndColor":@"gradientEndColor",
             @"strokeWidth":@"strokeWidth",
             @"frame":@"frame"};
}

- (id)initWithProperty:(ISSChartHistogramBarProperty*)property
{
    self = [super init];
    if (self) {
        _strokeWidth = property.strokeWidth;
        _frame = property.frame;
        _backgroundFrame = property.backgroundFrame;		
        _needDrawSelectedForehead = property.needDrawSelectedForehead;
        _strokeColor = property.strokeColor;
		_fillColors = property.fillColors;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramBarProperty *copy = [[ISSChartHistogramBarProperty allocWithZone:zone] initWithProperty:self];
    return copy;
}

- (id)init
{
    self = [super init];
    if (self) {
		_fillColors = @[[UIColor randomColor]];
        _strokeColor = [UIColor clearColor];
        _strokeWidth = DEFAULT_STROKE_WIDTH_BAR;
    }
    return self;
}

- (UIColor*)fillColor
{
	return _fillColors[0];
}

- (NSArray*)gradientColors
{
	NSMutableArray *gradientColors = [NSMutableArray array];
	for (UIColor *color in _fillColors) {
		[gradientColors addObject:(id)color.CGColor];
	}
	return gradientColors;
}
@end
