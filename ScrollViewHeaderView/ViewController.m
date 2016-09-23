//
//  ViewController.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate ,ScrollHeaderViewDelegate>

@end

@implementation ViewController

- (void)viewDidLayoutSubviews{
    extern CGFloat header_height;
    extern CGFloat item_height;

    __weak ViewController * superVC =self;
    __weak UIView * superView =self.view;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(superView);
        make.height.mas_equalTo(header_height);
    }];

    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superVC.headerView);
        make.top.equalTo(superVC.headerView.mas_bottom);
        make.height.mas_equalTo(40);
    }];

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
    self.tableViewOne.contentInset = UIEdgeInsetsMake(header_height, 0, 0, 0);
    self.tableViewTwo.contentInset = UIEdgeInsetsMake(header_height, 0, 0, 0);
    
    self.headerView.headerScrollView =self.tableViewOne;
    
    [self initViews];
    
}

- (void)initViews{
    
    [self.view addSubview:self.headerView];
    [self.view bringSubviewToFront:self.headerView];

    
    [self.view addSubview:self.itemView];
    [self.view bringSubviewToFront:self.itemView];

}

#pragma mark --ScrollViewDelagte
- (void)GetNewContentInset:(CGFloat)offset{
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(offset);
    }];
    [self.headerView layoutIfNeeded];
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
    
    if (scrollView ==self.tableViewOne) { //演示用   只限定headView并没有完全缩回的时候 后续修改
        self.tableViewTwo.contentOffset = self.tableViewOne.contentOffset;
    }
    else
    {
        self.tableViewOne.contentOffset = self.tableViewTwo.contentOffset;
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

@end
