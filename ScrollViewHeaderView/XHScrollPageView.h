//
//  XHScrollPageView.h
//  ScrollViewAndPageView
//
//  Created by huhaifeng on 15/10/27.
//  Copyright © 2015年 huhaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHScrollView.h"
@protocol XHScrollPageViewDelegate;

@interface XHScrollPageView : UIView <UIScrollViewDelegate>

@property (nonatomic ,strong)XHScrollView *scrollView;

@property (nonatomic ,assign)NSInteger currentPage;

@property (nonatomic ,assign)id<XHScrollPageViewDelegate> delegate;

@property (nonatomic ,strong)NSMutableArray *imageViewArray;

@property (nonatomic ,readonly)UIPageControl *pageControl;

-(void)shouldAutoShow:(BOOL)shouldStart;

@end


@protocol XHScrollPageViewDelegate <NSObject>

@required
- (void)GetXHScrollViewYForVC:(CGFloat)Y;

@optional

- (void)DidClickPage:(XHScrollPageView *)view atIndex:(NSInteger)index;

@end



