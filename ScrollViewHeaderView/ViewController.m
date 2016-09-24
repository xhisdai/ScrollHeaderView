//
//  ViewController.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "ViewController.h"
#import "XHScrollPageView.h"
#import "Masonry.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate ,ScrollHeaderViewDelegate,XHScrollPageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLayoutSubviews{
    extern CGFloat header_height;
    extern CGFloat item_height;

//    __weak ViewController * superVC =self;
//    __weak UIView * superView =self.view;
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(superView);
//        make.height.mas_equalTo(header_height);
//    }];
//    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(superVC.headerView);
//        make.top.equalTo(superVC.headerView.mas_bottom);
//        make.height.mas_equalTo(item_height);
//    }];
    self.headerView.frame =CGRectMake(0, 0, self.view.frame.size.width, header_height);
    self.itemView.frame =CGRectMake(0, header_height, self.view.frame.size.width, item_height);


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _MainScrollView.bounces =NO;
    _MainScrollView.pagingEnabled =YES;

    self.tableViewOne.delegate =self;
    self.tableViewOne.dataSource =self;
    self.tableViewTwo.delegate =self;
    self.tableViewTwo.dataSource =self;
    
    extern CGFloat header_height;
    UIView * headOne =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, header_height)];
    headOne.backgroundColor =[UIColor blueColor];
    UIView * headTwo =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, header_height)];
    headTwo.backgroundColor =[UIColor blueColor];
//    self.tableViewOne.contentInset = UIEdgeInsetsMake(header_height, 0, 0, 0);
//    self.tableViewTwo.contentInset = UIEdgeInsetsMake(header_height, 0, 0, 0);
    self.tableViewOne.tableHeaderView =headOne;
    self.tableViewTwo.tableHeaderView =headTwo;
    self.headerView.headerScrollView =self.tableViewOne;    
    [self initViews];

}

- (void)initViews{
    
    [self.view addSubview:self.headerView];
    [self.view bringSubviewToFront:self.headerView];
    [self.headerView addSubview:self.pageView];
    
    [self.view addSubview:self.itemView];
    [self.view bringSubviewToFront:self.itemView];

}

-(void)DidClickPage:(XHScrollPageView *)view atIndex:(NSInteger)index{
    NSLog(@"PageView page=====:%ld\n",(long)index);
}

#pragma mark --ScrollViewDelagte
- (void)GetNewContentInset:(CGFloat)offset{
    NSLog(@"offset=======:%f \n",offset);
    extern CGFloat header_height;
    extern CGFloat item_height;
    self.headerView.frame =CGRectMake(0, offset, self.view.frame.size.width, header_height);
    self.itemView.frame =CGRectMake(0, header_height +offset, self.view.frame.size.width, item_height);
//    UIView * superView =self.view;
//    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(offset);
//        make.left.right.equalTo(superView);
//        make.height.mas_equalTo(header_height);
//    }];
//    [self.headerView setNeedsLayout];
//    [self.headerView layoutIfNeeded];
}

#pragma mark --UISCrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ((scrollView.contentOffset.x / self.MainScrollView.frame.size.width >=1))
    {
        self.headerView.headerScrollView =self.tableViewTwo;
    }
    else
    {
        self.headerView.headerScrollView =self.tableViewOne;
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_headerView.type ==HeaderViewTypeOpen) {
        
        if (scrollView ==self.tableViewOne) { //演示用   只限定headView并没有完全缩回的时候 后续修改
            self.tableViewTwo.contentOffset = self.tableViewOne.contentOffset;
        }
        else
        {
            self.tableViewOne.contentOffset = self.tableViewTwo.contentOffset;
        }
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    [cell.textLabel setText:[NSString stringWithFormat:@"test cell %ld", (long)indexPath.row]];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ScrollHeaderView *)headerView{
    if (_headerView ==nil) {
        _headerView =[[ScrollHeaderView alloc]init];
        _headerView.deleagte =self;
    }
    return _headerView;
}

- (UIView *)itemView{
    if (_itemView ==nil) {
        _itemView =[[UIView alloc]init];
        _itemView.backgroundColor =[UIColor grayColor];
    }
    return _itemView;
}

- (XHScrollPageView *)pageView{
    if (_pageView ==nil) {
        _pageView =[[XHScrollPageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
        NSMutableArray *tempAry = [NSMutableArray array];
        for (int i=1; i<7; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%i.jpg",i]];
            [tempAry addObject:imageView];
        }
        
        [_pageView setImageViewArray:tempAry];
        
        _pageView.delegate =self;
    }
    return _pageView;
}
@end
