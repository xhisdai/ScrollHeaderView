//
//  ViewController.h
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollHeaderView.h"
@interface ViewController : UIViewController

@property (nonatomic ,strong)ScrollHeaderView * headerView;
@property (nonatomic ,strong)UIView * itemView;
@property (weak ,nonatomic) IBOutlet UITableView * tableViewOne;
@property (weak ,nonatomic) IBOutlet UITableView * tableViewTwo;

@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@end

