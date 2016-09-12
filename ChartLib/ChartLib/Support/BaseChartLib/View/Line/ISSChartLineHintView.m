//
//  ISSChartLineHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineHintView.h"
#import "ISSChartHintTextProperty.h"


@interface ISSChartLineHintView()

@end

@implementation ISSChartLineHintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size.height = _hintsArray.count * DEFAULT_HINT_LABEL_HEIGHT + DEFAULT_HINT_LABEL_TOP_MARGIN+ DEFAULT_HINT_LABEL_BOTTOM_MARGIN;
    frame.size.width = [self getFrameWidth];
    [self setFrame:frame];
    [_backgroundImageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - setter
-(void)setHintsArray:(NSArray *)hintsArray
{
    if (hintsArray && hintsArray.count < _hintsArray.count) {
        [self removeSubViewsWitchTagIsBigOrEqualTo:(ISSChart_Hint_Tag_Base+_hintsArray.count)];
    }    
    
    _hintsArray = hintsArray;
    [self setNeedsLayout];
    [self updateSubViewsInfo];
}

//9.23 画明细
#pragma mark - private method
- (void)updateSubViewsInfo
{
    if (!_hintsArray || _hintsArray.count<=0) {
        return;
    }
    for (int i=0; i<_hintsArray.count; i++) {
        ISSChartHintTextProperty *property = _hintsArray[i];
        ITTAssert([property isKindOfClass:[ISSChartHintTextProperty class]],@"_hintsArray contain data is not ISSChartHintTextProperty");
        UILabel *label = (UILabel *)[self findViewWithTag:ISSChart_Hint_Tag_Base+i];
        if (!label) {
            float width = [self getFrameWidth];
            label = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_HINT_LABEL_LEFT_MARGIN,
                                                              DEFAULT_HINT_LABEL_TOP_MARGIN+DEFAULT_HINT_LABEL_HEIGHT *i,
                                                              width,
                                                              DEFAULT_HINT_LABEL_HEIGHT)];
            label.tag = ISSChart_Hint_Tag_Base+i;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [self addSubview:label];
        }
        [label setText:property.text];
        [label setTextColor:property.textColor];
        
        
    }
}

#pragma mark - helper

- (UIView *)findViewWithTag:(NSInteger)tag
{
    for (UIView *subView in self.subviews){
        if (subView.tag == tag) {
            return subView;
        }
    }
    return nil;
}

- (void)removeSubViewsWitchTagIsBigOrEqualTo:(NSInteger)tag
{
    for (UIView *subView in self.subviews){
        if (subView.tag >= tag) {
            [subView removeFromSuperview];
        }
    }
}

- (float)getFrameWidth
{
    float width = 100;
    UIFont *font = [UIFont systemFontOfSize:17];
    for (ISSChartHintTextProperty *property in _hintsArray){
        CGSize size = [property.text sizeWithFont:font constrainedToSize:CGSizeMake(1000, 100)];
        if (width<size.width) {
            width = size.width;
        }
    }
    width+=DEFAULT_HINT_LABEL_LEFT_MARGIN*2 + 10;
    ITTDINFO(@"width:%f",width);
    return width;
}

- (float)getFrameHeight
{
    float height = 0;
    height +=    DEFAULT_HINT_LABEL_TOP_MARGIN;
    height +=    DEFAULT_HINT_LABEL_BOTTOM_MARGIN;
    height += _hintsArray.count * DEFAULT_HINT_LABEL_HEIGHT;
    ITTDINFO(@"height:%f",height);
    return height;
}

- (CGRect)getHintViewFrame:(CGRect)frame location:(CGPoint)location supView:(UIView *)view
{
    ITTDINFO();
    frame.origin.x = location.x + 15;
    frame.origin.y = location.y - CGRectGetHeight(frame)/2;
    
    if (frame.origin.x+[self getFrameWidth]>view.bounds.size.width) {
        frame.origin.x -= ([self getFrameWidth]+30) ;
        UIImage *image = [[UIImage imageNamed:@"hint_bg_arrow_left_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        [self.backgroundImageView setImage:image];
        self.backgroundImageView.transform = CGAffineTransformScale(self.backgroundImageView.transform, -1, 1);
        
    }else{
        
        if (frame.origin.y+[self getFrameHeight]>view.bounds.size.height) {
            frame.origin.y -= ([self getFrameHeight]- 2 * 10) ;
            UIImage *image = [[UIImage imageNamed:@"hint_bg_arrow_left_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:3];
            [self.backgroundImageView setImage:image];
            
        }else{
            
            UIImage *image = [[UIImage imageNamed:@"hint_bg_arrow_left_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30];
            [self.backgroundImageView setImage:image];
            
        }
        self.backgroundImageView.transform = CGAffineTransformIdentity;
    }
    return frame;
}

#pragma mark - public method
- (void)showInView:(UIView *)view location:(CGPoint)location
{
    if (view.superview.superview.superview) {
        CGRect frame = self.frame;
        CGPoint point = [view convertPoint:location toView:view.superview.superview.superview];
        self.frame = [self getHintViewFrame:frame location:point supView:view.superview.superview.superview];
        //        self.frame = [view convertRect:self.frame toView:view.superview.superview.superview];
        [view.superview.superview.superview addSubview:self];
        [self show];
    }
}


@end
