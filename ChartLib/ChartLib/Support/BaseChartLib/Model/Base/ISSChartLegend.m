//
//  ISSChartLegend.m
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLegend.h"
#import "NSString+ITTAdditions.h"

@implementation ISSChartLegend

- (id)init
{
    self = [super init];
    if (self) {
        _spacing = 4;
        _legnedSize = CGSizeZero;
        _fillColor = [UIColor darkGrayColor];
        _textColor = [UIColor darkGrayColor];
        _font = [UIFont systemFontOfSize:14];
        _size = CGSizeMake(DEFAULT_LEGEND_UNIT_HEIGHT/2, DEFAULT_LEGEND_UNIT_HEIGHT/2);
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    ISSChartLegend *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.spacing = self.spacing;
        copy.size = self.size;
        copy.textSize = self.textSize;
        copy.legnedSize = self.legnedSize;
        copy.name = self.name;
        copy.fillColor = self.fillColor;
        copy.font = self.font;
        copy.textColor = self.textColor ;
        copy.parent = self.parent ;
        copy.type = self.type;
    }
    return copy;
}

- (CGSize)legnedSize
{
    if (CGSizeEqualToSize(_legnedSize, CGSizeZero)) {
        CGFloat height = _size.height;
        CGFloat textHeight = [_name heightWithFont:_font withLineWidth:CGFLOAT_MAX];
        if (height < textHeight) {
            height = textHeight;
        }
        CGFloat textWidth = [_name widthWithFont:_font withLineHeight:CGFLOAT_MAX];
        _textSize = CGSizeMake(textWidth, textHeight);
        _legnedSize.width = _size.width + _spacing + textWidth;
        _legnedSize.height = height + _spacing;
    }
    return _legnedSize;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"name:%@",_name];
}
@end
