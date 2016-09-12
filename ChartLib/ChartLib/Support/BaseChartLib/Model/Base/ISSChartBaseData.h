//
//  ISSChartBaseData.h
//  
//
//  Created by Sword Zhou on 6/25/13.
//
//

#import "ISSChartBaseModelObject.h"


@class ISSChartCoordinateSystem;
@class ISSChartAxisItem;

@interface ISSChartBaseData : ISSChartBaseModelObject
{
@protected
	ISSChartType			 _chartType;
	CGFloat					 _legendFontSize;
    ISSChartLegendPosition   _legendPosition;
    ISSChartCoordinateSystem *_coordinateSystem;
    NSMutableArray           *_legends;
    NSArray                  *_legendTextArray;
}

/** 文字说明是否显示 */
@property (nonatomic, assign) BOOL legendIsShow;
@property (nonatomic, assign) ISSChartType chartType;

/*!
 * The default value of this property is ISSChartLegendPositionBottom 文字说明位置
 */
@property (nonatomic, assign) ISSChartLegendPosition legendPosition;
@property (nonatomic, assign) CGFloat legendFontSize;
@property (nonatomic, retain, readonly) NSMutableArray *legends;

/** 文字说明数组 */
@property (nonatomic, retain) NSArray *legendTextArray;
@property (nonatomic, retain) ISSChartCoordinateSystem *coordinateSystem;

- (void)setup;

- (ISSChartLegendDirection)getLegendDirection;

- (CGFloat)getMinYValue;
- (CGFloat)getMaxYValue;
- (CGFloat)getMinViceYValue;
- (CGFloat)getMaxViceYValue;

- (void)adjust;
- (void)tryToGenerateYAxis;
- (void)generateYAxis;
- (void)generateViceYAxis;
- (void)ajustLengendSize:(CGSize)size;
- (void)setXAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;

- (void)setYAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;
- (void)setViceYAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;

- (CGSize)getMaxLegendUnitSize;//新增
- (CGSize)getLegendTotalSize;//新增

- (CGSize)getLegendMaxSize;

- (CGSize)getLegendTotalSizeBeforeIndex:(NSInteger)index;

- (ISSChartAxisItem*)xAxisItemAtIndex:(NSInteger)index;

- (NSMutableArray *)legends;

- (void)readyData;

@end
