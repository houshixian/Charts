//
//  ITTCommonFunctions.h
//  
//
//  Created by guo hua on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - CGGeometry functions
CGPoint CGRectGetCenter(CGRect rect);
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2);
CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center);
BOOL ITTIsModalViewController(UIViewController* viewController);