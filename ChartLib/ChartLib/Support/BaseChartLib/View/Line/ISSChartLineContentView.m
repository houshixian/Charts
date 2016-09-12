//
//  ISSHistogram.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineContentView.h"
#import "ISSChatGallery.h"
#import "ISSChartAxis.h"
#import "ISSChartLine.h"
#import "ISSChartLineData.h"
#import "ISSChartLineProperty.h"
#import "ISSChartUtil.h"

@interface ISSChartLineContentView()
{
}
@end

@implementation ISSChartLineContentView

#pragma mark - lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = FALSE;
        self.clipsToBounds = TRUE;
        self.contentMode = UIViewContentModeLeft;
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLines:context];
    [self drawKeyPoints:context];
}

#pragma mark - private methods
- (void)drawKeyPoint:(CGContextRef)context line:(ISSChartLine*)line
{
    ISSChartLineProperty *lineProperty = line.lineProperty;
    NSInteger count = [lineProperty.points count];
    CGPoint point;
    CGMutablePathRef lineKeyPointPath = CGPathCreateMutable();
    for (NSInteger i = 0; i < count; i++) {
        point = [lineProperty.points[i] CGPointValue];
        CGPathRef keyPointPath = [ISSChartUtil newPointJoinPath:point style:lineProperty.pointStyle radius:lineProperty.radius];
        if (keyPointPath) {
            CGPathAddPath(lineKeyPointPath, NULL, keyPointPath);
            CGPathRelease(keyPointPath);
        }
    }
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetLineWidth(context, lineProperty.joinLineWidth);
    CGContextSetStrokeColorWithColor(context, lineProperty.fillColor.CGColor);  //7月24日改
    CGContextSetFillColorWithColor(context, lineProperty.strokeColor.CGColor);
    CGContextAddPath(context, lineKeyPointPath);
    CGContextDrawPath(context, kCGPathFillStroke);    
    CGPathRelease(lineKeyPointPath);    
}

- (void)drawKeyPoints:(CGContextRef)context
{
    for (ISSChartLine *line in _lines) {
        [self drawKeyPoint:context line:line];
    }
}

- (void)drawLines:(CGContextRef)context
{
    for (ISSChartLine *line in _lines) {
        [self drawLine:context line:line];
    }
}

- (void)drawLine:(CGContextRef)context line:(ISSChartLine*)line
{
    ISSChartLineProperty *lineProperty = line.lineProperty;
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGPoint point;
    CGPoint firstPoint = [line firstPoint];
    NSInteger count = [lineProperty.points count];
    CGPathMoveToPoint(linePath, NULL, firstPoint.x, firstPoint.y);
    for (NSInteger i = 1; i < count; i++) {
        point = [lineProperty.points[i] CGPointValue];
        CGPathAddLineToPoint(linePath, NULL, point.x, point.y);
    }
    CGContextSetLineWidth(context, lineProperty.lineWidth);
    CGContextSetStrokeColorWithColor(context, lineProperty.strokeColor.CGColor);
    CGContextSetLineCap(context, lineProperty.lineCap);
    CGContextSetLineJoin(context, lineProperty.lineJoin);
    
    CGContextAddPath(context, linePath);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(linePath);
        
}

#pragma mark - public methods
- (void)setLines:(NSArray *)lines
{
    NSAssert(nil != lines, @"nil line data parameter!");
    _lines = lines;
    [self setNeedsDisplay];
}
@end
