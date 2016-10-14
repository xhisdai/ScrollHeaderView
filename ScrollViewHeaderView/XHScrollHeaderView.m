//
//  ScrollHeaderView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "XHScrollHeaderView.h"
#import "Masonry.h"
extern CGFloat header_height;
extern CGFloat item_height;
extern CGFloat page_height;

@interface XHScrollHeaderView()
{
    CGFloat  _headerHeight;
}
@end

@implementation XHScrollHeaderView

- (instancetype)init
{
    if (self =[super init]) {
        self.backgroundColor =[UIColor redColor];
        
        [self addSubview:self.pageView];
        [self addSubview:self.itemView];
        self.itemViewAddHeaderView =YES;
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).mas_offset(0);
        make.top.equalTo(self).mas_offset(0);
        make.height.mas_equalTo(header_height);
        
    }];
    [self.pageView layoutIfNeeded];
    
    if (self.itemViewAddHeaderView)
    {  //如果itemView 存在self上 即可以更新约束
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.right.equalTo(self).mas_offset(0);
            make.height.mas_equalTo(item_height);
        }];
        [self.itemView layoutIfNeeded];
    }
    
}

- (void)drawRect:(CGRect)rect{
    
    NSLog(@"drawrect:%@ \n",NSStringFromCGRect(rect));
}

#pragma mark - scroll state
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:Nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    CGPoint oldOffset = [change[@"old"] CGPointValue];
    [self updateSubViewsWithScrollOffset:newOffset old:oldOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset old:(CGPoint)oldOffset
{
    if ([self.deleagte respondsToSelector:@selector(GetNewContentInset:)]) {
        [self.deleagte GetNewContentInset:newOffset.y];
    }
}

- (XHItemView *)itemView{
    if (_itemView ==nil) {
        _itemView =[[XHItemView alloc]init];
    }
    return _itemView;
}

- (XHScrollPageView *)pageView{
    if (_pageView ==nil) {
        _pageView =[[XHScrollPageView alloc]init];
        _pageView.backgroundColor =[UIColor orangeColor];
        NSMutableArray *tempAry = [NSMutableArray array];
        for (int i=1; i<7; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%i.jpg",i]];
            [tempAry addObject:imageView];
        }
        [_pageView setImageViewArray:tempAry];
        [_pageView shouldAutoShow:YES];
    }
    return _pageView;
}



@end
