//
//  WebPageViewController.m
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 7/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import "WebPageViewController.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface WebPageViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) NSInteger HUDCounter;
@property (nonatomic, strong) NSURL *URL;

@end

@implementation WebPageViewController

- (void)dealloc
{
    _webView.delegate = nil;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupWebView];
}

- (void)setupWebView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"webview"      : self.webView,
                                      @"topLayoutGuide" : self.topLayoutGuide,
                                      @"bottomLayoutGuide" : self.bottomLayoutGuide,
                                      };
    
    //width constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webview]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    //height constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][webview][bottomLayoutGuide]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    self.webView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishLoading
                                                        object:nil];
    [self hideLoadingHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingHUD];
}

#pragma mark - Loading HUD

- (void)showLoadingHUD
{
    [self showLoadingHUDWithTitle:@"Cargando..."];
}

- (void)showLoadingHUDWithTitle:(NSString *)title
{
    if (self.HUDCounter > 0) {
        self.HUDCounter++;
        return;
    }
    
    MBProgressHUD *hud;
    hud = [[MBProgressHUD alloc] initWithView:[self viewForAttachingLoadingHUD]];
    hud.dimBackground = YES;
    hud.labelText = title;
    
    [[self viewForAttachingLoadingHUD] addSubview:hud];
    [hud show:YES];
    
    self.HUDCounter++;
}

- (void)hideLoadingHUD
{
    if (self.HUDCounter > 0) {
        self.HUDCounter--;
        if (self.HUDCounter == 0) {
            [MBProgressHUD hideHUDForView:[self viewForAttachingLoadingHUD] animated:YES];
        }
    }
}

- (UIView *)viewForAttachingLoadingHUD
{
    return self.view;
}

@end
