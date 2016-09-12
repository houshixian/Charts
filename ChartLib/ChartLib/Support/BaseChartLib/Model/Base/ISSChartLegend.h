//
//  ISSChartLegend.h
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"
#import "ISSChartConsts.h"

@interface ISSChartLegend : ISSChartBaseModelObject<NSCopying>

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) CGSize legnedSize;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIColor  *fillColor;
@property (nonatomic, retain) UIColor  *textColor;
@property (nonatomic, retain) UIFont   *font;
@property (nonatomic, assign) id parent;

@property (nonatomic, assign) ISSChartLegendType type;

@end
