//
//  ScrollHeaderView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "ScrollHeaderView.h"
#import "Masonry.h"

@interface ScrollHeaderView()
{
    CGFloat  _headerHeight;
}
@end

@implementation ScrollHeaderView

- (instancetype)init
{
    if (self =[super init]) {
        self.backgroundColor =[UIColor redColor];
    }
    return self;
}


#pragma mark - scroll state
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self.headerScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset
{

//    CGFloat offset =-240 -newOffset.y;
//    self.type =HeaderViewTypeOpen;
//    if (offset<=-240)
//    {
//        offset =-240;
//        self.type =HeaderViewTypeClose;
//    }
//    else if (offset>=0)
//    {
//        offset =0;
//        self.type =HeaderViewTypeOpen;
//    }
    CGFloat offset =newOffset.y;
    if (offset >=240.0) {
        offset =240.0;
    }
    
    if ([self.deleagte respondsToSelector:@selector(GetNewContentInset:)]) {
        [self.deleagte GetNewContentInset:-offset];
    }

}











@end
