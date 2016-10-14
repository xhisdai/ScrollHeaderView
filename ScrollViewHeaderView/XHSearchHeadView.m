//
//  SearchHeadView.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/10/12.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "XHSearchHeadView.h"
#import "Masonry.h"
@interface XHSearchHeadView()
{
    UIButton * _searchBtn;
}
@end

@implementation XHSearchHeadView

- (instancetype)init
{
    if (self ==[super init]) {
        
        [self initData];
        [self initView];
        
    }
    return self;
}

- (void)initData
{

}

- (void)initView
{
    _searchBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    _searchBtn.backgroundColor =[UIColor whiteColor];
    _searchBtn.layer.cornerRadius =5.0;
    [self addSubview:_searchBtn];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(30);
    }];
    
    UILabel * saixuan =[[UILabel alloc]init];
    saixuan.text =@"筛选";

    [self addSubview:saixuan];
    
    UILabel * guanzhu =[[UILabel alloc]init];
    guanzhu.text =@"关注";
    [self addSubview:guanzhu];
    
    guanzhu.font =saixuan.font =[UIFont systemFontOfSize:17];
    guanzhu.textColor =saixuan.textColor=[UIColor whiteColor];
    
    [saixuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    [guanzhu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
