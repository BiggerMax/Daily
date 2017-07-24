//
//  YJReadViewController.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJReadViewController.h"

#import <WebKit/WebKit.h>
#import "YJFloationView.h"

@interface YJReadViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
{
    CGFloat _contentOffset_y;
}
@property(nonatomic,strong)UIView *loadingView;
@property(nonatomic,strong)UIImageView *loadingImageView;
@property(nonatomic,strong)YJFloationView *suspensionView;
@end

@implementation YJReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
    }
    return _loadingView;
}
-(UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [UIImageView new];
        NSMutableArray *imageMutableArray = [NSMutableArray new];
        for (int i = 0; i < 93; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"QDArticleLoading_0%d",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [imageMutableArray addObject:image];
        }
        _loadingImageView.animationImages = imageMutableArray;
        _loadingImageView.animationRepeatCount = MAXFLOAT;
        _loadingImageView.animationDuration = 2.0;
    }
    return _loadingImageView;
}
-(YJFloationView *)suspensionView
{
    if (!_suspensionView) {
        _suspensionView = [[YJFloationView alloc] initWithFrame:CGRectMake(20, SCREENH_HEIGHT-60, 61, 61)];
        _suspensionView.YJFloatingButtonStyle = YJFloatingButtonStyleBackType;
        __weak typeof(self) weakSelf = self;
        [_suspensionView backBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [self destoryJFSuspensionView];
        }];
    }
    return _suspensionView;
}
-(void)loadView
{
    [super loadView];
    WKWebView *rederWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    rederWebView.navigationDelegate = self;
    rederWebView.scrollView.delegate = self;
    [rederWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_newsUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7.0]];
    [self.view addSubview:rederWebView];
    [self.view addSubview:self.loadingView];
    [self.loadingView addSubview:self.loadingImageView];
    [self.view addSubview:self.suspensionView];
    [self customUI];
}
-(void)customUI
{
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}
-(void)setNewsUrl:(NSString *)newsUrl
{
    _newsUrl = newsUrl;
}
- (void)destoryJFSuspensionView {
    self.suspensionView.hidden = YES;
    self.suspensionView = nil;
}
#pragma mark --WKNavigationDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.loadingImageView startAnimating];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.loadingView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.loadingImageView stopAnimating];
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.loadingImageView stopAnimating];
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"加载失败，请检查网络";
    [hud hideAnimated:YES afterDelay:1.3];

    [NSThread sleepForTimeInterval:1.3];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIScrollDelegate
/// 滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //_contentOffset_Y + 80（隐藏悬浮按钮的阀值）
    if (scrollView.contentOffset.y > _contentOffset_y + 80) {
        [self hideSuspenstionButton];
    } else if (scrollView.contentOffset.y < _contentOffset_y) {
        [self showSuspenstionButton];
    }
}

/// 停止滚动时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _contentOffset_y = scrollView.contentOffset.y;
    
    //滑动停止后显示悬浮按钮
    [self showSuspenstionButton];
}
/// 显示悬浮按钮
- (void)showSuspenstionButton {
    if (self.suspensionView.layer.frame.origin.y == SCREENH_HEIGHT
        - 60) return;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect tempFrame = self.suspensionView.layer.frame;
                         tempFrame.origin.y -= 60;
                         self.suspensionView.layer.frame = tempFrame;
                     }];
}
/// 隐藏悬浮按钮
- (void)hideSuspenstionButton {
    if (self.suspensionView.layer.frame.origin.y == SCREENH_HEIGHT) return;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect tempFrame = self.suspensionView.layer.frame;
                         tempFrame.origin.y += 60;
                         self.suspensionView.layer.frame = tempFrame;
                     }];
}

@end
