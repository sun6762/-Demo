//
//  RefreshControl.h
//  下拉刷新Demo
//
//  Created by 孙博 on 16/8/12.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RefreshViewState) {
    // 正常
    RefreshViewStateNormal = -1,
    // 下拉过线
    RefreshViewStatePull = 0,
    // 正在刷新
    RefreshViewStateRefresh = 1,
};

@interface RefreshControl : UIControl

// 记录刷新状态
@property (nonatomic, assign) RefreshViewState refreshViewState;

@end
