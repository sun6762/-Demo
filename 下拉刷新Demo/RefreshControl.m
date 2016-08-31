//
//  RefreshControl.m
//  下拉刷新Demo
//
//  Created by 孙博 on 16/8/12.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "RefreshControl.h"

#define RefreshViewHeight 50

@interface RefreshControl ()

// 文字
@property (nonatomic, weak) UILabel *lb_text;
// 菊花
@property (nonatomic, weak) UIActivityIndicatorView *indicator;
// 记录父控件
@property (nonatomic, weak)UIScrollView *scroll;


@end

@implementation RefreshControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, -RefreshViewHeight, [UIScreen mainScreen].bounds.size.width, RefreshViewHeight)]) {
        
        [self setupUI];
    }
    return  self;
}
#pragma
#pragma mark -该控件将要加载父视图的时候
- (void)willMoveToSuperview:(UIView *)newSuperview{
    UIScrollView *scroll = (UIScrollView *)newSuperview;
    self.scroll = scroll;
    [self.scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    NSLog(@"%@",keyPath);
    
//    NSLog(@"%.2f",self.scroll.contentOffset.y);
    
    [self judgeCurrentStateWith:self.scroll.contentOffset.y];
}

// MARK: - 判断下拉状态 -
- (void)judgeCurrentStateWith:(CGFloat) offset{
    
    // 获取顶部位置
   __block CGFloat topLoc = self.scroll.contentInset.top;
    if (self.scroll.dragging) {
        self.refreshViewState = RefreshViewStateNormal;
        // 正在下拉
        if ( offset <= -(topLoc + RefreshViewHeight) && self.refreshViewState == RefreshViewStateNormal) {
            // 将要进行刷新
            self.refreshViewState = RefreshViewStatePull;
            self.lb_text.text = @"下拉中";
//            NSLog(@"将要刷新");
        }else if (offset > -(topLoc + RefreshViewHeight) && self.refreshViewState == RefreshViewStatePull){
            // 正常状态
            self.lb_text.text = @"正常";
            self.refreshViewState = RefreshViewStatePull;
        }
    }else {
        // 用户的手松开了 如果此时在将要刷新状态 就进行刷新
        if (self.refreshViewState == RefreshViewStatePull) {
            self.refreshViewState = RefreshViewStateRefresh;
            
            self.lb_text.text = @"刷新中";
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:1 animations:^{
                [weakSelf.indicator startAnimating];
                self.scroll.contentInset = UIEdgeInsetsMake(topLoc+RefreshViewHeight, 0, 0, 0);
                NSString *string = weakSelf.lb_text.text;
                
                
                
            } completion:^(BOOL finished) {
                self.scroll.contentInset = UIEdgeInsetsMake(topLoc, 0, 0, 0);
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }];
        }
    }
}

    // MARK: - 设置UI -
- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.refreshViewState = RefreshViewStateNormal;
    
    UILabel *lb = [[UILabel alloc]init];
    self.lb_text = lb;
    [self addSubview:self.lb_text];
    self.lb_text.text = @"正常";
    self.lb_text.textColor = [UIColor blackColor];
    self.lb_text.font = [UIFont systemFontOfSize:15];
//    self.lb_text.textColor = [UIColor whiteColor];
    
    // 菊花
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator = indicatorView;
    [self addSubview:indicatorView];
    indicatorView.color = [UIColor redColor];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.lb_text.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lb_text attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lb_text attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
