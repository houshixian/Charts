//
//  ISSDashboardData.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardData.h"
#import "ISSChartGraduationProperty.h"
#import "ISSChartGraduation.h"
#import "ISSChartGraduationInterval.h"
#import "ISSChartCircleUtil.h"

#import "ISSChartCircleUtil.h"
#import "ISSChartPointer.h"
#import "UIDevice+ITTAdditions.h"
#import "ISSChartCircle.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartLegend.h"

@implementation ISSChartDashboardData

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (CGFloat)radianWithValue:(CGFloat)value
{
	CGFloat degreeRange = self.endAngle - self.startAngle;
	CGFloat valueRange = [self valueRange];
	CGFloat radian = ((value - self.minimumValue)/valueRange)*degreeRange + self.startAngle;
	return radian;
}

- (CGFloat)valueRange
{
	CGFloat valueRange = self.maximumValue - self.minimumValue;
	return valueRange;
}

- (CGFloat)valueInterval
{
	CGFloat valueRange = [self valueRange];
	CGFloat valueInterval = valueRange/(self.step - 1);
	return valueInterval;
}

- (void)readyGraduations
{
	CGFloat currentValue = self.minimumValue;
	CGFloat valueInterval = [self valueInterval];
	CGFloat valueRange = [self valueRange];
	CGFloat radian;
	NSMutableArray *graduations = [NSMutableArray arrayWithCapacity:self.step];
	for (NSInteger i = 0; i < self.step; i++) {
		radian = [self radianWithValue:currentValue];
		ISSChartGraduation *graduation = [[ISSChartGraduation alloc] init];
		graduation.value = currentValue;
		graduation.name = @"";
		
		ISSChartGraduationProperty *graduationProperty = [[ISSChartGraduationProperty alloc] init];
		graduationProperty.lineWidth = self.graduationLineWidth;
		graduationProperty.lineLength = self.graduationLineLength;
		graduationProperty.lineColor = self.graduationLineColor;
		graduation.graduationProperty = graduationProperty;
		graduationProperty.degree = radian;
		graduationProperty.pointOnOuterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius center:self.origin];
		graduationProperty.pointOnInnerCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius - graduationProperty.lineLength center:self.origin];
		
		[graduations addObject:graduation];
		
		currentValue += valueInterval;
	}
	self.graduations = graduations;
	
	if (self.labels && [self.labels count]) {
		NSInteger i = 0;
		for (ISSChartGraduation *graduation in self.labels) {
			
			radian = [self radianWithValue:graduation.value];
			
			ISSChartGraduationProperty *graduationProperty = [[ISSChartGraduationProperty alloc] init];
			graduationProperty.lineWidth = self.graduationLineWidth;
			graduationProperty.lineLength = self.graduationLineLength;
			graduationProperty.lineColor = self.graduationLineColor;
			graduationProperty.degree = radian;
			graduationProperty.pointOnOuterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius center:self.origin];
			graduationProperty.pointOnInnerCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius - graduationProperty.lineLength center:self.origin];
			graduationProperty.textFont = [UIFont systemFontOfSize:graduation.textSize];
			graduationProperty.textColor = graduation.textColor;
			graduation.graduationProperty = graduationProperty;
			
			if (!graduation.name||![graduation.name length]) {
				graduation.name = [NSString stringWithFormat:@"%.0lf%%", 100.0*(graduation.value/valueRange)];
			}
			graduationProperty.label = graduation.name;
			
//			if (0 == i) {
//				graduationProperty.image = [UIImage imageNamed:@"bad_left"];
//			}
//			else if ([self.labels count] - 1 == i) {
//				graduationProperty.image = [UIImage imageNamed:@"good_right"];
//			}
			[self caculateLabelProperty:graduation];
//			if (0 == i) {
//				CGRect textRect = graduationProperty.textFrame;
//				textRect.origin.x -= 2;
//				graduationProperty.textFrame = textRect;
//			}
//			else if ([self.labels count] - 1 == i) {
//				CGRect textRect = graduationProperty.textFrame;
//				textRect.origin.x += 2;
//				graduationProperty.textFrame = textRect;
//			}
			[graduations addObject:graduation];
			i++;
		}
	}
}

- (void)readyIntervals
{
	if (self.graduationIntervals && [self.graduationIntervals count]) {
		ISSChartGraduation *startGraduation;
		ISSChartGraduation *endGraduation;
		CGFloat radian;

		for (ISSChartGraduationInterval *graduationInterval in self.graduationIntervals) {
			startGraduation = graduationInterval.startGraduation;
			endGraduation = graduationInterval.endGraduation;
			radian = [self radianWithValue:startGraduation.value];
			
			ISSChartGraduationProperty *startGraduationProperty = [[ISSChartGraduationProperty alloc] init];
			startGraduationProperty.pointOnOuterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius center:self.origin];
			startGraduationProperty.pointOnInnerCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius - self.graduationLineLength center:self.origin];
			startGraduationProperty.degree = radian;
			startGraduation.graduationProperty = startGraduationProperty;
			
			radian = [self radianWithValue:endGraduation.value];
			ISSChartGraduationProperty *endGraduationProperty = [[ISSChartGraduationProperty alloc] init];
			endGraduationProperty.pointOnOuterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius center:self.origin];
			endGraduationProperty.pointOnInnerCircle = [ISSChartCircleUtil pointOnCircleWithRadian:radian radius:self.radius - self.graduationLineLength center:self.origin];
			endGraduationProperty.degree = radian;
			endGraduation.graduationProperty = endGraduationProperty;
		}
	}
}

- (CGSize)adjustImageSize:(CGSize)imageSize
{
	if ([[UIDevice currentDevice] hasRetinaDisplay]) {
		imageSize = CGSizeMake(imageSize.width/2, imageSize.height/2);
	}
	return imageSize;
}

- (void)readyPointer
{
	CGSize imageSize = [self adjustImageSize:self.pointer.image.size];
	CGRect pointerRect = CGRectMake(self.origin.x - imageSize.width, self.origin.y - imageSize.height/2 - 8.f, imageSize.width, imageSize.height);
	self.pointer.rect = pointerRect;
	self.pointer.degree = [self radianWithValue:self.value] - M_PI;
}

- (void)readyCircle
{
	CGSize imageSize = [self adjustImageSize:self.circle.image.size];
	CGRect circleRect = CGRectMake(self.origin.x - imageSize.width/2, self.origin.y - imageSize.height/2, imageSize.width, imageSize.height);
	self.circle.rect = circleRect;
}

- (void)readyData
{
	[self readyGraduations];
	[self readyIntervals];
	[self readyPointer];
	[self readyCircle];
}

- (void)caculateLabelProperty:(ISSChartGraduation*)graduation
{
	ISSChartGraduationProperty *graduationPropeprty = graduation.graduationProperty;
	CGFloat textHeight = CGFLOAT_MAX;
	CGFloat textWidth = [graduation.name widthWithFont:graduationPropeprty.textFont withLineHeight:textHeight];
	CGPoint origin = graduationPropeprty.pointOnOuterCircle;
	CGRect textFrame = CGRectZero;
	CGRect imageFrame = CGRectZero;
	CGSize imageSize = [self adjustImageSize:graduationPropeprty.image.size];
	textHeight = [graduation.name heightWithFont:graduationPropeprty.textFont withLineWidth:textWidth];
	PointPosition position = [ISSChartCircleUtil pointPosition:graduationPropeprty.degree];
	switch (position) {
		case PointPositionRight:
			textFrame = CGRectMake(origin.x, origin.y - textHeight, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x, origin.y - imageSize.height, imageSize.width, imageSize.height);
			break;
		case PointPositionBottom:
			textFrame = CGRectMake(origin.x - textWidth/2, origin.y, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x - imageSize.width/2, origin.y, imageSize.width, imageSize.height);
			break;
		case PointPositionLeft:
			textFrame = CGRectMake(origin.x - textWidth, origin.y - textHeight, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x - imageSize.width, origin.y - imageSize.height , imageSize.width, imageSize.height);
			break;
		case PointPositionTop:
			textFrame = CGRectMake(origin.x - textWidth/2, origin.y - textHeight, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x - imageSize.width/2, origin.y - imageSize.height, imageSize.width, imageSize.height);
			break;
		case PointPositionRightBottom:
			textFrame = CGRectMake(origin.x, origin.y, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x, origin.y, imageSize.width, imageSize.height);
			break;
		case PointPositionLeftBottom:
			textFrame = CGRectMake(origin.x - textWidth, origin.y, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x - imageSize.width, origin.y, imageSize.width, imageSize.height);
			break;
		case PointPositionLeftTop:
			textFrame = CGRectMake(origin.x - textWidth, origin.y - textHeight, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x - imageSize.width, origin.y - imageSize.height, imageSize.width, imageSize.height);
			break;
		case PointPositionRightTop:
			textFrame = CGRectMake(origin.x, origin.y - textHeight, textWidth, textHeight);
			imageFrame = CGRectMake(origin.x, origin.y - imageSize.height, imageSize.width, imageSize.height);
			break;
		default:
			break;
	}
	if (textFrame.size.width < imageFrame.size.width) {
		textFrame.origin.x = imageFrame.origin.x + (imageFrame.size.width - textFrame.size.width)/2;
	}
	graduationPropeprty.imageFrame = imageFrame;
	graduationPropeprty.textFrame = textFrame;
}

#pragma mark - super methods
- (void)setup
{
	_valueTextFont = [UIFont systemFontOfSize:14];
	_valueTextColor = [UIColor blackColor];
	_graduationLineLength = DEFAULT_LINE_LENGTH;
	_graduationLineWidth = DEFAULT_LINE_WIDTH;
	_graduationLineColor = [UIColor grayColor];
	_arcLineWidth = -1;
	_graduationLineLength = -1;
	_graduationLineWidth = -1;
	_pointer = [[ISSChartPointer alloc] init];
    _pointer.image = nil;
	_circle = [[ISSChartCircle alloc] init];
	_coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
}


#pragma mark - public methods

- (UIColor*)arcLineColor
{
	if (!_arcLineColor) {
		_arcLineColor = [UIColor clearColor];
	}
	return _arcLineColor;
}

- (UIColor*)graduationLineColor
{
	if (!_graduationLineColor) {
		_graduationLineColor = [UIColor grayColor];
	}
	return _graduationLineColor;
}

- (CGFloat)arcLineWidth
{
	if (_arcLineWidth < 0) {
		_arcLineWidth = DEFAULT_LINE_WIDTH;
	}
	return _arcLineWidth;
}


- (void)setValue:(CGFloat)value
{
	_value = value;
	[self readyPointer];
}
-(void)setValue1:(CGFloat)value1{
    _value1 = value1;
    [self readyPointer];
}


- (NSString*)valueLabel
{
	if (!_valueLabel || ![_valueLabel length]) {
		_valueLabel = [NSString stringWithFormat:@"%.2lf", _value];
	}
	return _valueLabel;
}

- (NSMutableArray*)legends
{
    if (!_legends) {
        NSInteger legendCount = [self.legendTextArray count];
        if (legendCount) {
            _legends = [[NSMutableArray alloc] initWithCapacity:legendCount];
			NSInteger i = 0;
			UIColor *color;
            for (ISSChartGraduationInterval *graduationInterval in _graduationIntervals) {
				color = graduationInterval.colors[0];
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
                legend.name = _legendTextArray[i];
                legend.fillColor = color;
                legend.type = ISSChartLegendDashBoard;
                [_legends addObject:legend];
                i++;
            }
        }
    }
    return _legends;
}
@end
