//
//  ISSChartLineData.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineData.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartColorUtil.h"
#import "ISSChartLegend.h"

@implementation ISSChartLineData

- (id)init
{
    self = [super init];
    if (self) {
        _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];  
    }
    return self;
}

- (id)initWithLineData:(ISSChartLineData*)lineData
{
    self = [super init];
    if (self) {
        _graduationSpacing = lineData.graduationSpacing;
        _graduationWidth = lineData.graduationWidth;
        _legendPosition = lineData.legendPosition;
        _coordinateSystem = [lineData.coordinateSystem copy];
        _legendTextArray = lineData.legendTextArray ;
        _lines = [[NSArray alloc] initWithArray:lineData.lines copyItems:TRUE];
        _lineColors = lineData.lineColors;
        _lineDataArrays = [[NSArray alloc] initWithArray:lineData.lineDataArrays copyItems:TRUE];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartLineData *copy = [[ISSChartLineData allocWithZone:zone] initWithLineData:self];
    return copy;
}

#pragma mark - private methods
- (void)assignLineColors
{
    if (_lineColors && [_lineColors count] &&
        _lines && [_lines count]) {
        NSInteger index = 0;
        for (ISSChartLine *line in _lines) {
            line.lineProperty.strokeColor = _lineColors[index];
            index++;
        }
    }
}

- (void)generateLines
{
    UIColor *color;
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (NSArray *lineData in _lineDataArrays) {
        ISSChartLine *line = [[ISSChartLine alloc] init];
        line.lineIndex = index;
        line.values = lineData;
        ISSChartLineProperty *lineProperty = [[ISSChartLineProperty alloc] init];
        color = [ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB];
        lineProperty.strokeColor = color;
        line.lineProperty = lineProperty;
        [lines addObject:line];
        index++;
    }
    self.lines = lines;
}

#pragma mark - public methods
- (void)setValues:(NSArray*)values
{
    self.lineDataArrays = values;
    ITTDINFO(@" self.lineDataArrays:%@", self.lineDataArrays);
    [self tryToGenerateYAxis];
    [self generateLines];
    [self assignLineColors];    
}

- (void)setValuesWithValues:(NSArray*)values1, ...NS_REQUIRES_NIL_TERMINATION
{
//    NSInteger count = [values1 count];
    NSMutableArray *valuesArrays = [NSMutableArray array];
    id values;
    va_list argumentList;
    if (values1)                                // The first argument isn't part of the varargs list,
    {
        [valuesArrays addObject:values1];       // so we'll handle it separately.
        va_start(argumentList, values1);        // Start scanning for arguments after firstObject.
        while ((values = va_arg(argumentList, id))) { // As many times as we can get an argument of type "id"
            [valuesArrays addObject:values];        // that isn't nil, add it to array.
//            NSAssert([values count] == count, @"all values must have the same size!");
        }
        va_end(argumentList);
    }
    [self setValues:valuesArrays];
}

- (void)setLineColors:(NSArray *)lineColors
{
    NSAssert(nil != lineColors, @"nil colors parameter!");
    NSAssert(0 != [lineColors count], @"empty colors parameter!");
    if (_lineDataArrays && [_lineDataArrays count]) {
        NSAssert([_lineDataArrays count] == [lineColors count], @"the count of colors and count of data must have the same size!");
    }
    _lineColors = lineColors ;
    [self assignLineColors];
}

- (CGFloat)getMinYValue
{
    CGFloat minValue = CGFLOAT_MAX;
    for (NSArray *lineDataArray in _lineDataArrays) {
        for (NSNumber *value in lineDataArray) {
            if ([value floatValue] < minValue) {
                minValue = [value floatValue];
            }
        }
    }
    return (minValue > 0 ? 0 : minValue);
}

- (CGFloat)getMaxYValue
{
    CGFloat maxValue = 0;
    for (NSArray *lineDataArray in _lineDataArrays) {
        for (NSNumber *value in lineDataArray) {
            if ([value floatValue] > maxValue) {
                maxValue = [value floatValue];
            }
        }
    }
    return maxValue;

}

- (CGSize)getLegendJoinSize:(ISSChartLegend*)legend index:(NSInteger)index
{
    ISSChartLine *line =  _lines[index];
    ISSChartLineProperty *lineProperty = line.lineProperty;
    CGSize newSize = legend.size;
    newSize.width = lineProperty.radius * 4;
    return newSize;
}

- (NSMutableArray*)legends
{
    if (!_legends) {
        ISSChartLine *line;
        NSInteger count = [self.legendTextArray count];
        if (count) {
            _legends = [[NSMutableArray alloc] initWithCapacity:count];
            for (NSInteger i = 0; i < count; i++) {
                line = _lines[i];
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
                legend.name = self.legendTextArray[i];
                legend.fillColor = line.lineProperty.strokeColor;
                legend.type = ISSChartLegendLine;
                legend.parent = line.lineProperty;
                legend.size = [self getLegendJoinSize:legend index:i];
                [_legends addObject:legend];
            }
        }
    }
    return _legends;
}

@end
