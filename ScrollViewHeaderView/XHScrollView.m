//
//  XHScrollView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/24.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "XHScrollView.h"

@interface XHScrollView()
{
    CGPoint beginPoint;
}
@end

@implementation XHScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch=[touches anyObject];
    
    beginPoint =[touch locationInView:self];
    
    NSLog(@"point x:%f \n",beginPoint.x);
    NSLog(@"point y:%f \n",beginPoint.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)even{
    self.scrollEnabled =NO;
    
    UITouch *touch=[touches anyObject];
    CGPoint movePoint =[touch locationInView:self];
    
    if ([self.xhScrollViewDelegate respondsToSelector:@selector(GetXHScrollViewY:)]) {
        [self.xhScrollViewDelegate GetXHScrollViewY:movePoint.y -beginPoint.y];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.scrollEnabled =YES;
}



@end
