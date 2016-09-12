//
//  ISSChartBarHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHintView.h"

@implementation ISSChartHintView


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private methods
- (void)setup
{
    self.reuseIdentifier = NSStringFromClass([self class]);    
}

- (CATransform3D)layerTransformForScale:(CGFloat)scale targetFrame:(CGRect)targetFrame
{
    //	CGFloat horizontalDelta = targetFrame.size.width/2;
	CGFloat hotizontalScaleTransform = 1.0;//(horizontalDelta * scale) - horizontalDelta;
	
	CGFloat verticalDelta = roundf(targetFrame.size.height/2);
	CGFloat verticalScaleTransform = verticalDelta - (verticalDelta * scale);
	
	CGAffineTransform affineTransform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, hotizontalScaleTransform, verticalScaleTransform);
	return CATransform3DMakeAffineTransform(affineTransform);
}

#pragma mark - public methods
- (void)show
{
	CGRect targetFrame = self.bounds;
	self.layer.transform = [self layerTransformForScale:0.001f targetFrame:targetFrame];	
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
					 animations:^{
						 self.layer.transform = [self layerTransformForScale:1.1f targetFrame:targetFrame];
					 }
					 completion:^ (BOOL finished) {
						 [UIView animateWithDuration:0.1
											   delay:0
											 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
										  animations:^{
											  self.layer.transform = [self layerTransformForScale:0.95f targetFrame:targetFrame];
										  }
										  completion:^ (BOOL finished) {
											  [UIView animateWithDuration:0.1
																	delay:0
																  options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
															   animations:^{
																   self.layer.transform = [self layerTransformForScale:1.0f targetFrame:targetFrame];
															   }
															   completion:^ (BOOL finished) {
																   self.layer.transform = CATransform3DIdentity;
															   }
											   ];
										  }];
					 }
	 ];
}

+ (id)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
}
@end
