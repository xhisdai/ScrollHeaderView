//
//  XHItemView.h
//  ScrollViewHeaderView
//
//  Created by huhaifeng on 16/9/28.
//  Copyright © 2016年 huhaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHItemViewDelegate <NSObject>

- (NSArray *)GetItemTitlesArray;

@end

@interface XHItemView : UIView
@property (nonatomic ,readwrite,strong)NSArray<NSString *> * titleArray;
@property (nonatomic ,strong)NSMutableArray<UIButton *> * btnArray;
@property (nonatomic ,weak)id<XHItemViewDelegate> itemViewDelegate;

@end
