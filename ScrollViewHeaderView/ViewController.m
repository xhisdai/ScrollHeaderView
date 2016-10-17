//
//  ViewController.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/23.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

//屏幕宽度
#define SCREEN_W           [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate ,ScrollHeaderViewDelegate,XHScrollPageViewDelegate>
{

    int _noRepeatUpdateConstraint; //避免一直更新约束
    CGFloat _lastOffsetY;//判断_showTableView 上下滑动的方向
    CGFloat _searchViewY;//searchView的origin Y值
    BOOL _searchViewIsShowFromAnimation;//_searchView 是否通过上下拉显示的
    BOOL _isHeaderAddShowTable;//headerView是否加载到TableView上 默认YES
    
    BOOL _tableViewFoodScreenShow; //全屏显示TableView headView缩上去了
    BOOL _tableViewDressScreenShow;
    BOOL _tableViewFindScreenShow;
}
@end

const CGFloat status_height =20;//statusView 高度
const CGFloat inset_height =64+240;//tabelView 的初始化偏移量
const CGFloat search_height =64;//searchView 高度
const CGFloat header_height =240;//headerView 高度
const CGFloat item_height =44;//itemView 高度
const CGFloat page_height =20;//pageControl 高度

typedef struct
{//一个frame的结构体 其实并没有什么用
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
}CGItemViewFrame;

@implementation ViewController

//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
//返回状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.headerView.itemViewAddHeaderView) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}
//VC.view 约束布局完调用
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.statusBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(status_height);
    }];
    [self.statusBackView layoutIfNeeded];
}

//更新约束 通过self.view setNeedsUpdateConstraints 调用
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (_searchViewY ==0)
    {
        _searchViewIsShowFromAnimation =YES;
    }
    else
    {
        _searchViewIsShowFromAnimation =NO;
    }
    [self.searchHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_equalTo(_searchViewY);
    }];
}

//初始化调用方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
    
    [self initData];

    self.edgesForExtendedLayout = UIRectEdgeNone;//不跟随Navbar变化
}

- (void)initData{
    //设置偏移量
    [self.tableViewFood setContentInset:UIEdgeInsetsMake(inset_height, 0, 0, 0)];
    [self.tableViewDress setContentInset:UIEdgeInsetsMake(inset_height, 0, 0, 0)];
    [self.tableViewFind setContentInset:UIEdgeInsetsMake(inset_height, 0, 0, 0)];
    self.tableViewFood.delegate =self;
    self.tableViewFood.dataSource =self;
    self.tableViewDress.delegate =self;
    self.tableViewDress.dataSource =self;
    self.tableViewFind.delegate =self;
    self.tableViewFind.dataSource =self;
    self.tableViewFood.tag =10;
    self.tableViewDress.tag =11;
    self.tableViewFind.tag =12;
    _lastOffsetY =-header_height;
    _searchViewY =1;
}

- (void)initViews
{
    [self.view addSubview:self.statusBackView];
    [self.view bringSubviewToFront:self.statusBackView];
    _MainScrollView.bounces =NO; //设置没有弹簧效果
    _MainScrollView.pagingEnabled =YES; //设置翻页效果
    _MainScrollView.delegate =self; //设置代理
    
    //当前显示TableView 为食品TableView
    _showTableView =self.tableViewFood;
    
    self.headerView.tableView =_showTableView;
    [self HeaderViewAddTableView];
    
    [self.view insertSubview:self.searchHeaderView belowSubview:self.statusBackView];
    [self SearchHeaderForSelfViewFrame:(CGItemViewFrame){0,0,SCREEN_W,search_height}];
}

#pragma mark --SearchView 跟新frame
- (void)SearchHeaderForSelfViewFrame:(CGItemViewFrame)frame
{
    [self.searchHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_equalTo(frame.y);
        make.left.right.equalTo(self.view).mas_equalTo(0);
        make.height.mas_equalTo(frame.height);
    }];
    [self.searchHeaderView setNeedsUpdateConstraints];
}

#pragma mark --HeaderView 添加到TableView上  更新frame
- (void)HeaderViewAddTableView
{
    _isHeaderAddShowTable =YES;
    [_showTableView insertSubview:self.headerView atIndex:0];
    [_showTableView bringSubviewToFront:self.headerView];

    self.headerView.frame =CGRectMake(0, -header_height, SCREEN_W, header_height);
    [self.headerView setNeedsUpdateConstraints];
}

- (void)HeaderViewAddSelfView:(CGItemViewFrame)frame
{
    _isHeaderAddShowTable =NO;
    [self.view insertSubview:self.headerView belowSubview:self.searchHeaderView];
    
    self.headerView.frame =CGRectMake(frame.x, frame.y, frame.width, frame.height);
    [self.headerView setNeedsUpdateConstraints];
}

#pragma mark --HeaderView 添加到SelfView上  更新frame
- (void)ItemViewAddSelfView
{
    
    [self.headerView.itemView removeConstraints:[self.headerView.itemView constraints]];
    [self.view addSubview:self.headerView.itemView];
    [self.view bringSubviewToFront:self.headerView.itemView];
}
- (void)ItemViewForSelfViewFrame:(CGItemViewFrame)frame
{
    [self.headerView.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchHeaderView.mas_bottom).mas_equalTo(0);
        make.left.right.equalTo(self.searchHeaderView).mas_offset(0);
        make.height.mas_equalTo(frame.height);
    }];
    [self.headerView.itemView setNeedsUpdateConstraints];
}

#pragma mark --ItemView 添加到HeaderView上  更新frame
- (void)ItemViewAddHeaderView
{

    [self SearchHeaderForSelfViewFrame:(CGItemViewFrame){0,0,SCREEN_W,search_height}];
    
    [self.headerView.itemView removeConstraints:[self.headerView.itemView constraints]];
    [self.headerView addSubview:self.headerView.itemView];
}

- (void)ItemViewForHeaderViewFrame:(CGItemViewFrame)frame
{
    [self.headerView.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.equalTo(self.headerView).mas_offset(0);
        make.height.mas_equalTo(frame.height);
    }];
    [self.headerView.itemView setNeedsUpdateConstraints];
}

#pragma mark --点击了第几张广告视图--
-(void)DidClickPage:(XHScrollPageView *)view atIndex:(NSInteger)index{

}

#pragma mark --监听回调(滑动太快 监听会漏 例如offset: 12 13 14 18 19)
/**
 监听当前显示TableView的 contentOffset
 @param offset 偏移值 默认 -(240 +64)
 */
- (void)GetNewContentInset:(CGFloat)offset{
    
    if (offset<=-search_height && offset>= -(item_height+search_height))
    {//如果偏移量 在 0(itemView的底部即是0) ~ -(search_height+item_height)之间
        if (self.headerView.itemViewAddHeaderView)
        {//如果当前ItemView被加载到HeaderView上 换到VC.view上 (itemView 与HeaderView无缝连接)
            [self ItemViewAddSelfView];
            [self ItemViewForSelfViewFrame:(CGItemViewFrame){0,search_height,SCREEN_W,item_height}];
            self.headerView.itemViewAddHeaderView =!self.headerView.itemViewAddHeaderView;
        }
        
        CGFloat search_y=-(offset +item_height+search_height);//随着偏移量变化 searchView伸缩(前提_searchViewAgainShow为NO)
        if (search_y <-item_height)
        {//searchView 高度64 默认Y 为0 最多向上偏移 44长度
            search_y =-item_height;
        }

        if (_searchViewIsShowFromAnimation ==NO)
        {
            [self SearchHeaderForSelfViewFrame:(CGItemViewFrame){0,search_y,SCREEN_W,search_height}];
            [self setNeedsStatusBarAppearanceUpdate]; //通知返回状态栏样式颜色
        }
    }
    else if (offset < -(item_height+search_height))
    {//当下拉TableView 偏移量小与-(item_height+search_height) 是 要将之前的headerView重新加载到TableView 上
        if (!self.headerView.itemViewAddHeaderView)
        {
            [self ItemViewAddHeaderView];
            [self ItemViewForHeaderViewFrame:(CGItemViewFrame){0,header_height-item_height,SCREEN_W,item_height}];
            self.headerView.itemViewAddHeaderView =!self.headerView.itemViewAddHeaderView;
            [self setNeedsStatusBarAppearanceUpdate];//通知返回状态栏样式颜色
            
            _searchViewIsShowFromAnimation =NO;
        }
    
    }
    else
    { //规避错误
        if (self.headerView.itemViewAddHeaderView)
        {//如果当前ItemView被加载到HeaderView上 换到VC.view上 (itemView 与HeaderView无缝连接)
            [self ItemViewAddSelfView];
            [self ItemViewForSelfViewFrame:(CGItemViewFrame){0,0,SCREEN_W,item_height}];
            self.headerView.itemViewAddHeaderView =!self.headerView.itemViewAddHeaderView;
        }
    }
    
    [self ItemHeaderViewForAlpha:offset];
}

#pragma mark    --HeaderView颜色透明度变化
- (void)ItemHeaderViewForAlpha:(CGFloat)offset
{
    if (offset >-(item_height +search_height) && offset<-search_height)
    {// searchView透明度变化 由深到浅 itemView相反
        CGFloat alpha =(fabs(offset)-search_height)/item_height;
        self.searchHeaderView.alpha=alpha<0.7?0.7:alpha;
        
    }
    else if (offset <= -(item_height +search_height))
    {
        self.searchHeaderView.alpha=1;
        self.headerView.itemView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
    }
    //防止快速滑动出现bug 规避
    if (_searchViewIsShowFromAnimation)
    {
        self.searchHeaderView.alpha=1;
    }
}

#pragma mark --UISCrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //切换TableView 重新设置showTableView
    if ((scrollView.contentOffset.x / scrollView.frame.size.width >=2))
    {
        _showTableView =self.tableViewFind;

    }
    else if ((scrollView.contentOffset.x / scrollView.frame.size.width >=1))
    {
        _showTableView =self.tableViewDress;

    }
    else
    {
        _showTableView =self.tableViewFood;

    }
    self.headerView.tableView =_showTableView;
    if (!_isHeaderAddShowTable)
    { //切换TableView后 如果没有添加TableView上 添加到TableView 上
         [self HeaderViewAddTableView];
    }
    
    if (scrollView.tag !=10 && scrollView.tag !=11 && scrollView.tag !=12)
    {//切换TableView 更新ItemView透明度状态
        [self GetNewContentInset:_showTableView.contentOffset.y];
    }
    
    self.headerView.itemView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //当前滑动的是TableVIew
    if (scrollView.tag ==10 ||scrollView.tag ==11 ||scrollView.tag ==12) {

        if (!self.headerView.itemViewAddHeaderView &&scrollView.contentOffset.y>-(search_height)) {

            if (scrollView.contentOffset.y >_lastOffsetY && _noRepeatUpdateConstraint ==0)
            {//向上滑动
                _noRepeatUpdateConstraint =1;
                _searchViewY =-item_height;
                
                [self.view setNeedsUpdateConstraints];
                [self.view updateConstraintsIfNeeded];
                [UIView animateWithDuration:0.2 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }
            else if(scrollView.contentOffset.y <_lastOffsetY && _noRepeatUpdateConstraint ==1 && scrollView.contentOffset.y<(scrollView.contentSize.height -scrollView.frame.size.height))
            {//向下滑动 小与可滑动区域高度 是为了上拉加载恢复的时候 searchView伸缩
                _noRepeatUpdateConstraint =0;
                _searchViewY =0;
                _searchHeaderView.alpha=1;
                // 告诉self.view约束需要更新
                [self.view setNeedsUpdateConstraints];
                // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
                [self.view updateConstraintsIfNeeded];
                [UIView animateWithDuration:0.2 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }
            
        }
        _lastOffsetY =scrollView.contentOffset.y;
        
        if (scrollView.contentOffset.y <= -64)
        {
            _tableViewFoodScreenShow = _tableViewDressScreenShow =_tableViewFindScreenShow =NO;
            if (scrollView.tag ==10)
            {
                _tableViewDress.contentOffset =_tableViewFind.contentOffset =_tableViewFood.contentOffset;

            }
            if (scrollView.tag ==11)
            {
                _tableViewFood.contentOffset =_tableViewFind.contentOffset =_tableViewDress.contentOffset;

            }
            if (scrollView.tag ==12)
            {
                _tableViewFood.contentOffset =_tableViewDress.contentOffset =_tableViewFind.contentOffset;

            }
        }
        else
        {
            if (scrollView.tag ==10 && _tableViewDressScreenShow ==NO && _tableViewFindScreenShow ==NO)
            {
                _tableViewFoodScreenShow =YES;
                _tableViewDress.contentOffset =_tableViewFind.contentOffset =CGPointMake(0, -64);
            }
            if (scrollView.tag ==11 && _tableViewFoodScreenShow ==NO && _tableViewFindScreenShow ==NO)
            {
                _tableViewDressScreenShow =YES;
                _tableViewFood.contentOffset =_tableViewFind.contentOffset =CGPointMake(0, -64);
            }
            if (scrollView.tag ==12 && _tableViewFoodScreenShow ==NO && _tableViewDressScreenShow ==NO)
            {
                _tableViewFindScreenShow =YES;
                _tableViewFood.contentOffset =_tableViewDress.contentOffset =CGPointMake(0, -64);
            }
        }

        if (!_isHeaderAddShowTable)
        { //如果没有添加TableView上 添加到TableView 上
            [self HeaderViewAddTableView];
        }
        return;
    }
    //当前滑动的是MainScrollView
    if (!self.headerView.itemViewAddHeaderView)
    {//如果ItemView不在headerView上 在SelfView上
        self.headerView.itemView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    }
    if (_isHeaderAddShowTable)
    {//如果HeaderView在_showTabelView上

        if (!self.headerView.itemViewAddHeaderView)
        {//且ItemView没有被Add到HeaderView上  滑动的时候HeaderView必然不显示
            if (_lastOffsetY >=-64) {
                [self HeaderViewAddSelfView:(CGItemViewFrame){0,-240+64,SCREEN_W, header_height}];
            }
            else
            {
                
                [self HeaderViewAddSelfView:(CGItemViewFrame){0,-240-_lastOffsetY,SCREEN_W, header_height}];
            }
        }
        else
        {
            CGFloat contentOffsetY =_showTableView.contentOffset.y;
            
            [self HeaderViewAddSelfView:(CGItemViewFrame){0,-contentOffsetY -header_height,SCREEN_W, header_height}];
        }
        
    }
}

#pragma mark --TableView DataSource--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    [cell.textLabel setText:[NSString stringWithFormat:@"tableViewTag:%ld test cell %ld",(long)tableView.tag,(long)indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor grayColor]];
}
#pragma mark --懒加载--
- (XHScrollHeaderView *)headerView
{
    if (_headerView ==nil) {
        _headerView =[[XHScrollHeaderView alloc]init];
        _headerView.deleagte =self;
    }
    return _headerView;
}

- (XHSearchHeadView *)searchHeaderView
{
    if (_searchHeaderView ==nil) {
        _searchHeaderView =[[XHSearchHeadView alloc]init];
        _searchHeaderView.backgroundColor =[UIColor redColor];
    }
    return _searchHeaderView;
}

- (UIView *)statusBackView
{
    if (_statusBackView ==nil) {
        _statusBackView =[[UIView alloc]init];
        _statusBackView.backgroundColor =[UIColor redColor];
    }
    return _statusBackView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
