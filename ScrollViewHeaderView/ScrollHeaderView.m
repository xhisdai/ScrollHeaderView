//
//  ScrollHeaderView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "ScrollHeaderView.h"
#import "Masonry.h"

@interface ScrollHeaderView()
{
    CGFloat  _headerHeight;
}
@end

@implementation ScrollHeaderView

- (instancetype)init
{
    if (self =[super init]) {
        self.backgroundColor =[UIColor redColor];
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData{
    extern CGFloat header_height;
    _headerHeight =header_height;
}

- (void)initView
{
    UILabel * title =[[UILabel alloc]init];
    title.text =@"我在底部";
    title.textAlignment =NSTextAlignmentCenter;
    title.backgroundColor =[UIColor greenColor];
    [self addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(20);
    }];

    [self layoutIfNeeded];
}

#pragma mark - scroll state
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self.headerScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    extern CGFloat header_height;
    self.headerScrollView.contentInset = UIEdgeInsetsMake(header_height, 0, 0, 0);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset
{
    NSLog(@"newOffset %f====\n",newOffset.y);
    CGFloat offset;
    if ((240 +newOffset.y)>240) {
        offset =240;
    }
    else
    {
        offset =240 +newOffset.y;
    }
    
    if ([self.deleagte respondsToSelector:@selector(GetNewContentInset:)]) {
        [self.deleagte GetNewContentInset:-offset];
    }

}











@end
