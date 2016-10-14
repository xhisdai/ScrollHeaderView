//
//  XHScrollPageView.m
//  ScrollViewAndPageView
//
//  Created by huhaifeng on 15/10/27.
//  Copyright © 2015年 huhaifeng. All rights reserved.
//

#import "XHScrollPageView.h"
#import "Masonry.h"
extern CGFloat header_height;
extern CGFloat item_height;
extern CGFloat page_height;

@interface XHScrollPageView()
{
    UIView *_firstView;
    UIView *_middleView;
    UIView *_lastView;
    
    NSTimer *_autoScrollTimer;
    
    UITapGestureRecognizer *_tap;
}

@end

@implementation XHScrollPageView

- (XHScrollView *)scrollView
{
    if (_scrollView ==nil) {

        _scrollView =[[XHScrollView alloc]init];
        _scrollView.delegate =self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl ==nil) {
        _pageControl =[[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled =NO;
        _pageControl.currentPageIndicatorTintColor =[UIColor redColor];
        _pageControl.pageIndicatorTintColor =[UIColor whiteColor];
    }
    return _pageControl;
}

-(instancetype)init{
    
    self =[super init];
    
    if (self) {

        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];

        //设置单击手势
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:_tap];
    }
    
    return self;
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    
    [self UpdateViewFrame];
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_scrollView layoutIfNeeded];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-item_height);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(page_height);
    }];
}

- (void)UpdateViewFrame{
    
    _firstView.frame =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _middleView.frame =CGRectMake(1* self.bounds.size.width, 0,self.bounds.size.width, self.bounds.size.height);
    _lastView.frame =CGRectMake(2* self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    //显示中间页
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

/**
 将要被添加到另一个视图的时候调用
 @param newSuperview 父视图
 */
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
}

#pragma mark 单击手势
-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(DidClickPage:atIndex:)]) {
        [_delegate DidClickPage:self atIndex:_currentPage+1];
    }
}


#pragma mark scrollvie停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑动时候暂停自动替换
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
    _autoScrollTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSDefaultRunLoopMode];
    //得到当前页数
    float x = _scrollView.contentOffset.x;
    
    //往前翻
    if (x<=0) {
        if (_currentPage-1<0) {
            _currentPage = _imageViewArray.count-1;
        }else{
            _currentPage --;
        }
    }
    
    //往后翻
    if (x>=self.frame.size.width*2) {
        if (_currentPage==_imageViewArray.count-1) {
            _currentPage = 0;
        }else{
            _currentPage ++;
        }
    }
    
    [self reloadData];
}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart)  //开启自动翻页
    {
        if (!_autoScrollTimer) {
            _autoScrollTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSDefaultRunLoopMode];//NSRunLoopCommonModes 手动滑动scrollview不暂停
        }
    }
    else   //关闭自动翻页
    {
        if (_autoScrollTimer.isValid) {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

#pragma mark 展示下一页
-(void)autoShowNextImage
{
    if (_currentPage == _imageViewArray.count-1) {
        _currentPage = 0;
    }else{
        _currentPage ++;
    }
    
    [self reloadData];
}

-(void)setImageViewArray:(NSMutableArray *)imageViewArray{
    
    if (imageViewArray) {
        
        _imageViewArray =imageViewArray;
        _currentPage =0;
        _pageControl.numberOfPages =[_imageViewArray count];
    }
    if ([imageViewArray count]>1) {
        [self reloadData];
    }
    else
    {
        [_firstView removeFromSuperview];
        _firstView =[_imageViewArray lastObject];
        [_scrollView addSubview:_firstView];
    }
    
}

-(void)reloadData{
    
    [_firstView removeFromSuperview];
    [_middleView removeFromSuperview];
    [_lastView removeFromSuperview];
    
    if (_currentPage ==0) {
        
        _firstView =[_imageViewArray lastObject];
        _middleView =[_imageViewArray objectAtIndex:_currentPage];
        _lastView =[_imageViewArray objectAtIndex:_currentPage +1];
    }
    else if (_currentPage == [_imageViewArray count]-1){
        
        _firstView =[_imageViewArray objectAtIndex:_currentPage -1];
        _middleView =[_imageViewArray objectAtIndex:_currentPage];
        _lastView =[_imageViewArray firstObject];
    }
    else{
        
        _firstView =[_imageViewArray objectAtIndex:_currentPage -1];
        _middleView =[_imageViewArray objectAtIndex:_currentPage];
        _lastView =[_imageViewArray objectAtIndex:_currentPage +1];
    }
    
    [_scrollView addSubview:_firstView];
    [_scrollView addSubview:_middleView];
    [_scrollView addSubview:_lastView];
    
    //设置当前的分页
    _pageControl.currentPage = _currentPage;
    
    [self UpdateViewFrame];
}
@end
