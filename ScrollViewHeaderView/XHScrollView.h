//
//  XHScrollView.h
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/24.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHScrollViewDelegate <NSObject>

- (void)GetXHScrollViewY:(CGFloat)Y;

@end

@interface XHScrollView : UIScrollView

@property (weak, nonatomic)id<XHScrollViewDelegate> xhScrollViewDelegate;
@end
