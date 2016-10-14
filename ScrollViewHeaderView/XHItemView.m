//
//  XHItemView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/28.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//
#define SCREEN_W           [UIScreen mainScreen].bounds.size.width
#define BTNTag 10
#import "XHItemView.h"
#import "Masonry.h"

@interface XHItemView()
{
    CGFloat _AllBtnWidth;
}
@end

@implementation XHItemView
extern CGFloat header_height;
extern CGFloat item_height;
extern CGFloat page_height;

- (instancetype)init
{
    self=[super init];
    if (self) {
        [self initView];
        [self initData];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];

    CGFloat space = (SCREEN_W -_AllBtnWidth)/([_btnArray count]+1);
    [_btnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx ==0) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-5);
                make.left.mas_equalTo(space);
                make.height.mas_equalTo(30);
            }];
        }
        else
        {
            UIButton * lasBtn =[_btnArray objectAtIndex:idx-1];
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-5);
                make.left.equalTo(lasBtn.mas_right).offset(space);
                make.height.mas_equalTo(30);
            }];
        }
        [obj layoutIfNeeded];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
}

- (void)initData
{
    self.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
}

- (void)initView
{
    
    if ([self.itemViewDelegate respondsToSelector:@selector(GetItemTitlesArray)]) {
        _titleArray =[self.itemViewDelegate GetItemTitlesArray];
    }
    if ([_titleArray count]<1) {
        _titleArray=@[@"食品",@"着装靓衫",@"发现"];
    }
    
    _btnArray =[NSMutableArray new];
    
    [_titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeSystem];
        btn.layer.cornerRadius =5.0;
        btn.contentEdgeInsets =UIEdgeInsetsMake(0, 10, 0, 10);
        btn.backgroundColor =[UIColor redColor];
        btn.titleLabel.font =[UIFont systemFontOfSize:17];
        btn.tag =BTNTag +idx;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnArray addObject:btn];
    }];
    _AllBtnWidth =0.0;
    [_btnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
        }];
        [obj layoutIfNeeded];
        _AllBtnWidth +=obj.frame.size.width;
    }];
}

- (void)ButtonClick:(UIButton *)sender
{
    
}
@end
