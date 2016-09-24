//
//  ScrollHeaderView.h
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//
typedef enum {
    HeaderViewTypeOpen   =0,
    HeaderViewTypeClose  =1,
} HeaderViewType;

#import <UIKit/UIKit.h>

@protocol ScrollHeaderViewDelegate <NSObject>

- (void)GetNewContentInset:(CGFloat)offset;

@end

@interface ScrollHeaderView : UIView

@property (nonatomic ,weak)id<ScrollHeaderViewDelegate>deleagte;

@property (nonatomic ,strong)UIScrollView * headerScrollView;

//是否缩小了
@property (nonatomic ,assign)HeaderViewType type;
@end
