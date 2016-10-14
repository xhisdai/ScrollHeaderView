//
//  XHCollectionViewFlowLayout.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/26.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//
//屏幕宽度
#define SCREEN_W   [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_H   [UIScreen mainScreen].bounds.size.height
#import "XHCollectionViewFlowLayout.h"

@implementation XHCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    extern CGFloat header_height;
    extern CGFloat item_height;
    //cell大小
    self.itemSize =CGSizeMake(SCREEN_W, SCREEN_H -header_height);
    //水平滑动
    self.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    //上左下右四个偏移量
    self.sectionInset =UIEdgeInsetsMake(0, 0, 0, 0);
    //每个cell之间的间距
    self.minimumInteritemSpacing =0.0;
    self.minimumLineSpacing =0.0;
}

@end
