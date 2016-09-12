//
//  ISSChartUtil.m
//  ChartLib
//
//  Created by Sword Zhou on 6/6/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartUtil.h"
#import "ISSChartLineProperty.h"

@implementation ISSChartUtil

+ (CGPathRef)newPointJoinPath:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius
{
    CGPathRef path = NULL;
    CGRect rect;
    switch (style) {
        case ISSChartLinePointJoinNone: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            path = CGPathCreateWithEllipseInRect(rect, NULL);
            break;
        }
        case ISSChartLinePointJoinCircle:
        case ISSChartLinePointJoinSolidCircle:{
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            path = CGPathCreateWithEllipseInRect(rect, NULL);
            break;
        }
        case ISSChartLinePointJoinRectangle:
        case ISSChartLinePointJoinSolidRectangle: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            path = CGPathCreateWithRect(rect, NULL);
            break;
        }
        case ISSChartLinePointJoinTriangle:
        case ISSChartLinePointJoinSolidTriangle: {
//             . A
//           .   .
//        B . . . . C
            CGPoint A = CGPointMake(point.x, point.y - radius * cos(degreesToRadian(30.0)));
            CGPoint B = CGPointMake(point.x + radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            CGPoint C = CGPointMake(point.x - radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            CGMutablePathRef mutablePath = CGPathCreateMutable();
            CGPathMoveToPoint(mutablePath, NULL, A.x, A.y);
            CGPathAddLineToPoint(mutablePath, NULL, B.x, B.y);
            CGPathAddLineToPoint(mutablePath, NULL, C.x, C.y);
            CGPathAddLineToPoint(mutablePath, NULL, A.x, A.y);
            path = mutablePath;
            break;
        }
        default:
            break;
    }
    return path;
}

+ (CGRect)pointJointRect:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius
{
    CGRect rect;
    switch (style) {
        case ISSChartLinePointJoinNone: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            break;
        }
        case ISSChartLinePointJoinCircle:
        case ISSChartLinePointJoinSolidCircle: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            break;
        }
        case ISSChartLinePointJoinRectangle:
        case ISSChartLinePointJoinSolidRectangle: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            break;
        }
        case ISSChartLinePointJoinTriangle:
        case ISSChartLinePointJoinSolidTriangle: {
            //             . A
            //           .   .
            //        B . . . . C
            CGPoint A = CGPointMake(point.x, point.y - radius * cos(degreesToRadian(30.0)));
            CGPoint B = CGPointMake(point.x + radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            CGPoint C = CGPointMake(point.x - radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            rect = CGRectMake(B.x, A.y, C.x - B.x, C.y - A.y);
            break;
        }
        default:
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);            
            break;
    }
    return rect;
}
@end
