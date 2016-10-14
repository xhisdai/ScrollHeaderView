
//
//  ScrollHeaderView.h
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//
typedef enum {
    HeaderViewTypeOpen   =0,//打开
    HeaderViewTypeClose  =1,//关闭
} HeaderViewType;

#import <UIKit/UIKit.h>
#import "XHItemView.h"
#import "XHScrollPageView.h"
@protocol ScrollHeaderViewDelegate <NSObject>

/**
 获取tableView 的偏移值处理自身frame
 @param offset 偏移值
 */
- (void)GetNewContentInset:(CGFloat)offset;

@end

@interface XHScrollHeaderView : UIView

/**
 标签视图 点击可切换TableView
 */
@property (nonatomic ,strong)XHItemView * itemView;
@property (nonatomic ,assign)BOOL itemViewAddHeaderView;
/**
 广告视图 轮播滚动
 */
@property (nonatomic ,strong)XHScrollPageView * pageView;

/**
 代理
 */
@property (nonatomic ,weak)id<ScrollHeaderViewDelegate>deleagte;

/**
 当前 显示TableView self是其的子视图 默认显示食品TableView
 */
@property (nonatomic ,strong)UITableView * tableView;


/**
 是否还在窗口中显示
 type 默认HeaderViewTypeOpen
 */
@property (nonatomic ,assign)HeaderViewType type;
@end
