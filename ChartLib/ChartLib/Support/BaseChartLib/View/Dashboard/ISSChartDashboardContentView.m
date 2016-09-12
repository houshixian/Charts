//
//  ISSChartDashboardContentView.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardContentView.h"
#import "ISSChartdashboardData.h"
#import "ISSChartGraduation.h"
#import "ISSChartGraduationProperty.h"
#import "ISSChartGraduationInterval.h"
#import "ISSChartPointer.h"
#import "ISSChartCircle.h"
#import "UIDevice+ITTAdditions.h"

@interface ISSChartDashboardContentView()
{
	UILabel *_valueLabel;
	CALayer *_pointerLayer;
}
@end

@implementation ISSChartDashboardContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.opaque = FALSE;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();	

    [self drawBoard:context];
	[self drawPointers:context];
	[self drawCircle:context];
}

#pragma mark - private methods
- (void)drawOrigin:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 23, 200, 187, 1);
    CGContextAddArc(context, 240.f, 100.f, 10.f, 0, 360*(M_PI/180), 0);
    CGContextStrokePath(context);
	CGContextRestoreGState(context);
}

- (void)drawBoard:(CGContextRef)context
{
    CALayer *centerLayer = [CALayer layer];
    centerLayer.contents = (id)self.dashboardData.boardImage.CGImage;
    
    centerLayer.frame = self.bounds.size.width>=600 ? CGRectMake(308,133, 352, 245) : CGRectMake(64.f, -20.f, 352.f, 245.f);

    
    [self.layer addSublayer:centerLayer];
}

- (void)drawArc:(CGContextRef)context
{
	CGContextSaveGState(context);
	CGPoint origin = self.dashboardData.origin;
	CGFloat radius = self.dashboardData.radius;
	CGFloat innerRadius = self.dashboardData.innerRadius;
	CGFloat startDegree = self.dashboardData.startAngle;
	CGFloat endDegree = self.dashboardData.endAngle;
	
	ISSChartGraduation *firstGraduation = [self.dashboardData.graduations firstObject];
	ISSChartGraduation *lastGraduation = [self.dashboardData.graduations lastObject];
	ISSChartGraduationProperty *firstGraduationProperty = firstGraduation.graduationProperty;
	ISSChartGraduationProperty *lastGraduationProperty = lastGraduation.graduationProperty;
	
    CGContextSetStrokeColorWithColor(context, self.dashboardData.arcLineColor.CGColor);
	CGContextSetLineWidth(context, self.dashboardData.arcLineWidth);
	
	CGFloat			blur = 4;
	CGSize          shadowOffset = CGSizeMake (0, 2);
    CGFloat         shadowColorValues[] = {0/255.0, 0/255.0, 0/255.0, 1.0};
    CGColorRef      shadowColor;
    CGColorSpaceRef shadowColorSpace;
	
    shadowColorSpace = CGColorSpaceCreateDeviceRGB ();
    shadowColor = CGColorCreate (shadowColorSpace, shadowColorValues);
	//set shadow for inner arc
    CGContextSetShadowWithColor (context, shadowOffset, blur, shadowColor);
	
	//draw inner arc and join line between out arc and inner arc
	CGContextMoveToPoint(context, firstGraduationProperty.pointOnOuterCircle.x, firstGraduationProperty.pointOnOuterCircle.y);
	CGContextAddLineToPoint(context, firstGraduationProperty.pointOnInnerCircle.x, firstGraduationProperty.pointOnInnerCircle.y);
    CGContextAddArc(context, origin.x , origin.y, innerRadius, startDegree, endDegree, 0);
	CGContextAddLineToPoint(context, lastGraduationProperty.pointOnInnerCircle.x, lastGraduationProperty.pointOnInnerCircle.y);
	CGContextAddLineToPoint(context, lastGraduationProperty.pointOnOuterCircle.x, lastGraduationProperty.pointOnOuterCircle.y);
	CGContextDrawPath(context, kCGPathStroke);
	
	//set shadow for out arc
    CGContextSetShadowWithColor (context, CGSizeMake(0, -0.1), blur, shadowColor);
	//draw outer arc
    CGContextAddArc(context, origin.x , origin.y, radius, startDegree, endDegree, 0);
	CGContextDrawPath(context, kCGPathStroke);

    CGColorRelease (shadowColor);// 13
    CGColorSpaceRelease (shadowColorSpace);
	

	CGContextRestoreGState(context);
}

- (void)drawGraduations:(CGContextRef)context
{
	CGContextSaveGState(context);
	NSArray *graduations = self.dashboardData.graduations;
	NSInteger count = [graduations count];
	ISSChartGraduation *graduation;
	ISSChartGraduationProperty *graduationProperty;
	for (NSInteger i = 0; i < count; i++) {
		graduation = graduations[i];
		graduationProperty = graduation.graduationProperty;
		
		CGContextSetLineWidth(context, graduationProperty.lineWidth);
		CGContextSetStrokeColorWithColor(context, graduationProperty.lineColor.CGColor);
		CGContextMoveToPoint(context, graduationProperty.pointOnOuterCircle.x, graduationProperty.pointOnOuterCircle.y);
		CGContextAddLineToPoint(context, graduationProperty.pointOnInnerCircle.x, graduationProperty.pointOnInnerCircle.y);
		CGContextDrawPath(context, kCGPathStroke);
	}
	CGContextRestoreGState(context);
}

- (void)drawLabels:(CGContextRef)context
{
	CGContextSaveGState(context);
	NSArray *labels = self.dashboardData.labels;
	ISSChartGraduationProperty *graduationProperty;
	for (ISSChartGraduation *graduation in labels) {
		graduationProperty = graduation.graduationProperty;
		//draw bg image
		if (graduationProperty.image) {
			[graduationProperty.image drawInRect:graduationProperty.imageFrame];
		}
		//draw text
		CGContextSetLineWidth(context, graduationProperty.lineWidth);
		CGContextSetStrokeColorWithColor(context, graduationProperty.textColor.CGColor);
		CGContextSetFillColorWithColor(context, graduationProperty.textColor.CGColor);
		[graduationProperty.label drawInRect:graduationProperty.textFrame withFont:graduationProperty.textFont lineBreakMode:NSLineBreakByTruncatingTail];
	}
	CGContextRestoreGState(context);
}

- (void)shakeAnimation
{
	NSMutableArray *values = [NSMutableArray array];
	CGFloat degree = 3.0;
	CGFloat step = 0.5;
	NSInteger count = (NSInteger)degree/step;
	for(NSInteger i = 0; i < count; i++) {
		CGFloat radian = degreesToRadian(degree);
		if (i % 2) {
			radian *= -1;
		}
		[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(self.dashboardData.pointer.degree + radian, 0, 0, 1.0)]];
		degree -= step;
	}
	CAKeyframeAnimation *bounceAnimation = nil;
	bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	bounceAnimation.fillMode = kCAFillModeForwards;
	bounceAnimation.duration = 0.5;
	bounceAnimation.values = values;
	bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	bounceAnimation.removedOnCompletion = TRUE;
	[_pointerLayer addAnimation:bounceAnimation forKey:@"pointershakeanimation"];
}

- (void)rotatePointer
{
	_pointerLayer.transform = CATransform3DMakeRotation(self.dashboardData.pointer.degree, 0, 0, 1.0);
	[self performSelector:@selector(shakeAnimation) withObject:nil afterDelay:0.3];
}

- (void)updateValueLabel
{
	_valueLabel.text = self.dashboardData.valueLabel;
	return;
	[UIView animateWithDuration:0.3 animations:^{
		_valueLabel.alpha = 0.0;
	} completion:^(BOOL finished){
		if (finished) {
			[UIView animateWithDuration:0.1 animations:^{
				_valueLabel.text = self.dashboardData.valueLabel;
				_valueLabel.alpha = 1.0;
			}];
		}
	}];
}

- (void)drawPointers:(CGContextRef)context
{
	if (self.dashboardData.pointer && !_pointerLayer) {
		//draw pointer layer
		CGRect pointerFrame = self.dashboardData.pointer.rect;
		_pointerLayer = [CALayer layer];
		_pointerLayer.contents = (id)self.dashboardData.pointer.image.CGImage;
		_pointerLayer.frame = pointerFrame;
        _pointerLayer.position = self.width > 500 ? CGPointMake(482, 255) : CGPointMake(CGRectGetMaxX(pointerFrame), CGRectGetMaxY(pointerFrame));
		_pointerLayer.anchorPoint = CGPointMake(1.0, 0.5);
		[self.layer addSublayer:_pointerLayer];
		[self rotatePointer];
	}
}

- (void)drawCircle:(CGContextRef)context
{
	ISSChartCircle *circle = self.dashboardData.circle;
	CALayer *centerLayer = [CALayer layer];
	centerLayer.contents = (id)circle.image.CGImage;
    centerLayer.frame =  circle.rect;
    if (self.width > 600){
        centerLayer.position = CGPointMake(482, 255);
    }
    
    
	[self.layer addSublayer:centerLayer];

	if (!_valueLabel) {
        UIImageView *aoBackGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DownCase.png"]];
        _valueLabel = [[UILabel alloc] initWithFrame: self.width > 600 ? CGRectMake(450, 0, 20, 20) : CGRectMake(206, 90, 20, 20)];
		_valueLabel.text = self.dashboardData.valueLabel;
		_valueLabel.textAlignment = NSTextAlignmentCenter;
		_valueLabel.font = self.dashboardData.valueTextFont;
		_valueLabel.textColor = self.dashboardData.valueTextColor;
		_valueLabel.backgroundColor = [UIColor clearColor];
		_valueLabel.minimumScaleFactor = 0.25;
		_valueLabel.adjustsFontSizeToFitWidth = NO;
        _valueLabel.width = 40 + 20;

        CGRect frame = _valueLabel.frame;
        frame.origin.y = self.width > 600 ? 300 : 165 - 20;
        _valueLabel.frame = frame;
        
        
        frame = _valueLabel.frame;
        frame.origin.x = frame.origin.x -2;
        frame.size.height = 20;
        frame.origin.y = frame.origin.y ;
        [aoBackGround setFrame:frame];
        
        [self addSubview:aoBackGround];
        
		[self addSubview:_valueLabel];
        [_valueLabel setCenter:aoBackGround.center];
	}
}

- (void)drawIntervals:(CGContextRef)context
{
	CGContextSaveGState(context);
	NSInteger colorCount;
	CGPoint origin = self.dashboardData.origin;
	CGFloat radius = self.dashboardData.radius;
	CGFloat innerRadius = self.dashboardData.innerRadius;
	ISSChartGraduation *startGraduation;
	ISSChartGraduation *endGraduation;
	ISSChartGraduationProperty *startGraduationProperty;
	ISSChartGraduationProperty *endGraduationProperty;
	
	CGPoint startPointOnOuterCircle;
	CGPoint startPointOnInnterCircle;
	CGPoint endPointOnInnterCircle;

	
	for (ISSChartGraduationInterval *graduationInterval in self.dashboardData.graduationIntervals) {
		CGContextSaveGState(context);
		startGraduation = graduationInterval.startGraduation;
		endGraduation = graduationInterval.endGraduation;
		startGraduationProperty = startGraduation.graduationProperty;
		endGraduationProperty = endGraduation.graduationProperty;
		
		startPointOnInnterCircle = startGraduationProperty.pointOnInnerCircle;
		startPointOnOuterCircle = startGraduationProperty.pointOnOuterCircle;
		endPointOnInnterCircle = endGraduationProperty.pointOnInnerCircle;
		
		CGContextMoveToPoint(context, startPointOnInnterCircle.x, startPointOnInnterCircle.y);
		CGContextAddLineToPoint(context, startPointOnOuterCircle.x, startPointOnOuterCircle.y);
		CGContextAddArc(context, origin.x, origin.y, radius, startGraduationProperty.degree, endGraduationProperty.degree, 0);
		CGContextAddLineToPoint(context, endPointOnInnterCircle.x, endPointOnInnterCircle.y);
		CGContextAddArc(context, origin.x, origin.y, innerRadius, endGraduationProperty.degree, startGraduationProperty.degree, 1);
		
		colorCount = [graduationInterval.colors count];
		if (2 == colorCount) {
			//draw radial gradient
			CGFloat locs[2] = {0.0, 1.0};
			CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
			CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, graduationInterval.cgcolors, locs);
			CGColorSpaceRelease(mySpace);
			CGContextClip(context);
			CGContextDrawRadialGradient(context, gradientRef, origin, innerRadius, origin, radius, 0);
			CFRelease(gradientRef);
		}
		else if (3 == colorCount) {
			//draw radial gradient
			CGFloat locs[3] = {0.0, 0.3, 1.0};
			CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
			CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, graduationInterval.cgcolors, locs);
			CGColorSpaceRelease(mySpace);
			CGContextClip(context);
			CGContextDrawRadialGradient(context, gradientRef, origin, innerRadius, origin, radius, 0);
			CFRelease(gradientRef);			
		}
		else {
			UIColor *fillColor = graduationInterval.colors[0];
			CGContextSetFillColorWithColor(context, fillColor.CGColor);
			CGContextFillPath(context);
		}
		CGContextRestoreGState(context);
	}
	CGContextRestoreGState(context);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([@"degree" isEqualToString:keyPath] && object == _dashboardData.pointer) {
			[self rotatePointer];
	}
	else if([@"valueLabel" isEqualToString:keyPath] && object == _dashboardData) {
		[self updateValueLabel];
	}
}

- (void)dealloc {
    [self removeObservers];
}

- (void)removeObservers
{
	[_dashboardData.pointer removeObserver:self forKeyPath:@"degree" context:nil];
	[_dashboardData removeObserver:self forKeyPath:@"valueLabel" context:nil];
}

#pragma mark - public methods
-(void)setDashboardData:(ISSChartDashboardData *)dashboardData
{
	[self removeObservers];
	
	_dashboardData = dashboardData;
	[_dashboardData.pointer addObserver:self forKeyPath:@"degree" options:NSKeyValueObservingOptionNew context:nil];
	[_dashboardData addObserver:self forKeyPath:@"valueLabel" options:NSKeyValueObservingOptionNew context:nil];
}

@end
