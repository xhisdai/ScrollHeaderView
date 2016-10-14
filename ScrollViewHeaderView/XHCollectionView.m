//
//  XHCollectionView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/26.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "XHCollectionView.h"
#import "XHCollectionViewFlowLayout.h"
@interface XHCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@end

@implementation XHCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate =self;
    self.dataSource =self;
    
    self.alwaysBounceVertical = NO;
    
    self.pagingEnabled =YES;
    self.showsHorizontalScrollIndicator =NO;
    self.showsVerticalScrollIndicator =YES;
    
    [self setContentInset:UIEdgeInsetsMake(240, 0, 0, 0)];
    
    [self registerClass:[XHCollectionViewCell class] forCellWithReuseIdentifier:@"XHCollectionViewCell"];
    XHCollectionViewFlowLayout * layout =[[XHCollectionViewFlowLayout alloc]init];
    [self setCollectionViewLayout:layout animated:NO];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
    [self.refreshControl addTarget:self action:@selector(controlEventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:self.refreshControl];
    
    [self reloadData];
}

- (void)controlEventValueChanged:(id)sender{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [(UIRefreshControl *)sender endRefreshing];
    });
}
#pragma mark 定义 一共有多少的大section
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 定义 每个section中有多少个cell（item）
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"XHCollectionViewCell";
    XHCollectionViewCell *cell = (XHCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.backgroundColor =[UIColor redColor];
    }
    else if (indexPath.row ==1)
    {
        cell.backgroundColor =[UIColor yellowColor];
    }
    else
    {
        cell.backgroundColor =[UIColor greenColor];
    }
    return cell;
}
@end
