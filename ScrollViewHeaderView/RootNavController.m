//
//  RootNavController.m
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/10/12.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import "RootNavController.h"
#import "ViewController.h"
@interface RootNavController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation RootNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置透明
    self.navigationBar.translucent = NO;
    
    //设置字体
    NSShadow        * shadow;
    shadow =[[NSShadow alloc] init];
    shadow.shadowColor  = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(0,0);
    NSDictionary *fontStyle = @{
                                NSForegroundColorAttributeName:[UIColor blackColor],
                                NSShadowAttributeName:shadow,
                                NSFontAttributeName:[UIFont systemFontOfSize:20.0]
                                };
    [self.navigationBar setTitleTextAttributes:fontStyle];
    
    //更改后退按钮颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    //更改背景色
    [self.navigationBar setBarTintColor:[UIColor redColor]];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate =(id)self;
    
    //automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
//    [viewController setHidesBottomBarWhenPushed:YES];
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
//    if ([self.viewControllers count] ==2){ //方法执行完回到主界面
//        
//        [self.visibleViewController setHidesBottomBarWhenPushed:NO];
//    }
//    
    return [super popViewControllerAnimated:animated];
    
}

/**
 * 当前VC即将显示
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([viewController isKindOfClass:[ViewController class]]) {
        [self setNavigationBarHidden:YES animated:YES];
    }
}

//
///**
// * 当前VC已经显示
// */
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//
//    if (navigationController.viewControllers.count >2){ //大于2级的时候 可以侧滑
//        self.currentShowVC = viewController;
//    }
//    else{
//        self.currentShowVC = nil;
//    }
//
//}
///**用代理返回是否可以侧滑
// * param gestureRecognizer 滑动手势
// */
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//
//        if ((self.currentShowVC == self.topViewController)) {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    return YES;
//}






















































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
