//
//  XHScrollPageView.m
//  ScrollViewAndPageView
//
//  Created by huhaifeng on 15/10/27.
//  Copyright © 2015年 huhaifeng. All rights reserved.
//


#import "XHScrollPageView.h"

@interface XHScrollPageView()<XHScrollViewDelegate>
{
    UIView *_firstView;
    UIView *_middleView;
    UIView *_lastView;
    
    float _viewWidth;
    float _viewHeight;
    
    NSTimer *_autoScrollTimer;
    
    UITapGestureRecognizer *_tap;
}

@end

@implementation XHScrollPageView

-(id)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    
    if (self) {
        
        _viewWidth =self.bounds.size.width;
        _viewHeight =self.bounds.size.height;
        //设置scrollView
        _scrollView =[[XHScrollView alloc]initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _scrollView.delegate =self;
        _scrollView.xhScrollViewDelegate =self;
        _scrollView.contentSize =CGSizeMake(3 *_viewWidth, _viewHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled =YES;
        _scrollView.backgroundColor =[UIColor blackColor];
        [self addSubview:_scrollView];
        //设置pageControl
        _pageControl =[[UIPageControl alloc]initWithFrame:CGRectMake(0, _viewHeight -30, _viewWidth, 30)];
        _pageControl.userInteractionEnabled =NO;
        _pageControl.currentPageIndicatorTintColor =[UIColor redColor];
        _pageControl.pageIndicatorTintColor =[UIColor whiteColor];
        [self addSubview:_pageControl];
        
        //设置单击手势
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:_tap];
    }
    
    return self;
}

#pragma mark 单击手势
-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(DidClickPage:atIndex:)]) {
        [_delegate DidClickPage:self atIndex:_currentPage+1];
    }
}

- (void)GetXHScrollViewY:(CGFloat)Y{
    
    NSLog(@"ScrollView---Y:%f \n",Y);
    if ([_delegate respondsToSelector:@selector(GetXHScrollViewYForVC:)]) {
        [_delegate GetXHScrollViewYForVC:Y];
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
    if (x>=_viewWidth*2) {
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
    
    _firstView.frame =CGRectMake(0, 0, _viewWidth, _viewHeight);
    _middleView.frame =CGRectMake(1* _viewWidth, 0,_viewWidth, _viewHeight);
    _lastView.frame =CGRectMake(2* _viewWidth, 0, _viewWidth, _viewHeight);
    
    
    [_scrollView addSubview:_firstView];
    [_scrollView addSubview:_middleView];
    [_scrollView addSubview:_lastView];
    
    //设置当前的分页
    _pageControl.currentPage = _currentPage;
    
    //显示中间页
    _scrollView.contentOffset = CGPointMake(_viewWidth, 0);
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
