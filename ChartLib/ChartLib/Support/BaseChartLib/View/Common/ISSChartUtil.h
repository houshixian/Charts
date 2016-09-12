//
//  ISSChartUtil.h
//  ChartLib
//
//  Created by Sword Zhou on 6/6/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISSChartLineProperty;

@interface ISSChartUtil : NSObject

+ (CGPathRef)newPointJoinPath:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius;

+ (CGRect)pointJointRect:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius;

@end
