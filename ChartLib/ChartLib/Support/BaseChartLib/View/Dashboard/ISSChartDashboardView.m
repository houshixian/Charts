//
//  ISSChartDashboardView.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardView.h"
#import "ISSChatGallery.h"
#import "ISSChartDashboardContentView.h"
#import "ISSChartDashboardData.h"
#import "ISSChartDashboardLegendView.h"

@interface ISSChartDashboardView()
{
	ISSChartDashboardContentView *_dashboardContentView;
	ISSChartDashboardLegendView	 *_legendView;
}
@end

@implementation ISSChartDashboardView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_dashboardContentView = [[ISSChartDashboardContentView alloc] initWithFrame:self.bounds];
		[self addSubview:_dashboardContentView];
    }
    return self;
}

#pragma mark - public methods
- (void)setDashboardData:(ISSChartDashboardData *)dashboardData
{
	_dashboardData = dashboardData;
	[_dashboardData readyData];	
	_dashboardContentView.dashboardData = _dashboardData;
	[_dashboardContentView setNeedsDisplay];
	
	_legendView.frame = [self getLegendFrame:self.dashboardData.coordinateSystem legendPosition:self.dashboardData.legendPosition maxLegendSize:[self.dashboardData getMaxLegendUnitSize]];
	_legendView.dashData = self.dashboardData;
    
    //label
    CGFloat minVlaue = dashboardData.minimumValue;
    CGFloat maxValue =  dashboardData.maximumValue;
    CGFloat oneValue = (maxValue - minVlaue)/6;
    for (int i = 0; i < 7  ; i++ ) {
       
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        numLabel.center = self.center;
        numLabel.text = [NSString stringWithFormat:@"%0.0f",i*oneValue + minVlaue];
        numLabel.textColor = [UIColor grayColor];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.adjustsFontSizeToFitWidth = YES;
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.width = [numLabel.text widthWithFont:[UIFont systemFontOfSize:13] withLineHeight:20];
        switch (i) {
            case 0:{
            numLabel.right = self.centerX - 35;         //80
            numLabel.top = self.centerY + 30;           //60
            }
                
                break;
            case 1:{
                numLabel.right = self.centerX - 48;       //115
                numLabel.top = self.centerY - 20;     //20
            }
                
                break;
            case 2:{
            numLabel.right = self.centerX - 30;     //70
            numLabel.top =  self.centerY - 70;     //110
            }
                
                break;
            case 3:{
               numLabel.top = self.centerY - 102;           //145
                numLabel.centerX = numLabel.centerX - 3;    //7
            }
                
                break;
            case 4:{
                numLabel.left = self.centerX + 40;      //90
                numLabel.top = self.centerY - 80;      //110
            }
                
                break;
            case 5:{
                numLabel.left = self.centerX + 65;     //130
                 numLabel.top = self.centerY - 20;      //20
            }
                 break;
            case 6:{
                numLabel.left = self.centerX + 37;     //102
                numLabel.top = self.centerY + 30;       //58
            }
                
                break;

                
            default:
                break;
        }
        [self addSubview:numLabel];
    }
}

@end
