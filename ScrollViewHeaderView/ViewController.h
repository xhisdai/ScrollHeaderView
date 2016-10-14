//
//  ViewController.h
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSearchHeadView.h"
#import "XHScrollHeaderView.h"
#import "XHScrollPageView.h"
#import "BaseTableView.h"
@interface ViewController : UIViewController

/**
 顶部status bar 背景视图
 */
@property (nonatomic ,strong)UIView * statusBackView;
/**
 顶部搜索框视图
 */
@property (nonatomic ,strong)XHSearchHeadView *searchHeaderView;

/**
 底视图 用来切换TableView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;

/**
 头部广告视图 包含itemView(用来装切换TableView的itemtitle)
 */
@property (nonatomic ,strong)XHScrollHeaderView * headerView;

/**
 用户当前显示的TableView 默认食品TableView
 */
@property (nonatomic ,strong)UITableView * showTableView;

/**
 食品 TableView
 */
@property (weak ,nonatomic) IBOutlet BaseTableView * tableViewFood;

/**
 着装靓衫 TableView
 */
@property (weak ,nonatomic) IBOutlet BaseTableView * tableViewDress;

/**
 发现 TableView
 */
@property (weak, nonatomic) IBOutlet BaseTableView *tableViewFind;

//需要可以继续添加
@end

