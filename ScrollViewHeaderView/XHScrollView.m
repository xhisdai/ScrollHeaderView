//
//  XHScrollView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/24.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "XHScrollView.h"

@interface XHScrollView()
@end

extern CGFloat header_height;
extern CGFloat item_height;
extern CGFloat page_height;

@implementation XHScrollView

- (instancetype)init{
    self =[super init];
    if (self) {
        self.bounces =NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled =YES;
        self.backgroundColor =[UIColor blackColor];
    }
    return self;
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    
    self.contentSize =CGSizeMake(3 *self.frame.size.width, header_height);
}
@end
