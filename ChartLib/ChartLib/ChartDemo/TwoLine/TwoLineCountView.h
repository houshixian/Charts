//
//  TwoLineCountView.h
//  双折线图
//
//  Created by zhugy on 16/9/7.
//  Copyright © 2016年 hsx. All rights reserved.
//

#import "ISSChartView.h"
@class ISSChartHistogramLineData;
@class ISSChartHintView;
@class ISSChartHistogramBar;
@class ISSChartLine;
@interface TwoLineCountView : ISSChartView
@property (nonatomic, retain) ISSChartHistogramLineData *histogramLineData;
@property (nonatomic, copy) ISSChartHintView* (^didSelectedBarBlock)(TwoLineCountView *histogramLineView, ISSChartHistogramBar *bar, NSArray *lines, NSInteger indexOfValueOnLine, ISSChartAxisItem *xAxisItem);

- (id)initWithFrame:(CGRect)frame histogramLineData:(ISSChartHistogramLineData*)histogramLineData;
@end
