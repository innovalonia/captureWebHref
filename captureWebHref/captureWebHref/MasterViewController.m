//
//  ViewController.m
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 6/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import "MasterViewController.h"
#import "HrefListViewController.h"
#import "WebPageViewController.h"
#import "Constants.h"
#import "NSString+CWHrefFields.h"

typedef NS_ENUM(NSUInteger, DisplayMode) {
    DisplayModeWeb,
    DisplayModeList,
};

@interface MasterViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) DisplayMode displayMode;
@property (nonatomic, copy) NSArray *hrefList;
@property (nonatomic, strong) UIBarButtonItem *switchButton;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadContentView];
    [self insertChildViewController:[self controllerForDisplayMode:self.displayMode]];
    [self loadNavigationBarItems];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData) name:kFinishLoading object:nil];
    self.switchButton.enabled = [self.hrefList count];
}

- (void)loadContentView
{
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentView];
}

- (void)insertChildViewController:(UIViewController *)controller
{
    NSParameterAssert(controller);
    
    [self addChildViewController:controller];
    controller.view.frame = self.contentView.bounds;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

#pragma mark - View controller switching

- (void)loadNavigationBarItems
{
    self.switchButton = [[UIBarButtonItem alloc] initWithTitle:[self switchButtonTitleForDisplayMode:self.displayMode] style:UIBarButtonItemStylePlain target:self action:@selector(switchViewControllers:)];
    self.navigationItem.rightBarButtonItem = self.switchButton;
    self.navigationItem.title = @"CaptureWebHref";
}

- (void)switchViewControllers:(UIBarButtonItem *)barButtonItem
{
    [self setDisplayMode:(self.displayMode == DisplayModeList ? DisplayModeWeb : DisplayModeList) animated:YES];
    barButtonItem.title = [self switchButtonTitleForDisplayMode:self.displayMode];
}

/**
 * Switch right controller to instance
 */
- (UIViewController *)controllerForDisplayMode:(DisplayMode)mode
{
    switch (mode) {
        case DisplayModeWeb: {
            NSURL *URL = [NSURL URLWithString:urlString];
            WebPageViewController *controller = [[WebPageViewController alloc] initWithURL:URL];
            return controller;
        }
        case DisplayModeList: {
            HrefListViewController *controller = [[HrefListViewController alloc] init];
            if (self.hrefList) {
                controller.hyperlinksArray = self.hrefList;
            }
            return controller;
        }
    }
}

- (NSString *)switchButtonTitleForDisplayMode:(DisplayMode)mode
{
    switch (mode) {
        case DisplayModeWeb:
            return @"List of Href";
            
        case DisplayModeList:
            return @"WebView";
    }
}

- (void)setDisplayMode:(DisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:YES];
}

- (void)setDisplayMode:(DisplayMode)displayMode animated:(BOOL)animated
{
    if (self.displayMode != displayMode) {
        UIViewController *firstViewController;
        UIViewController *secondViewController;
        
        firstViewController = [[self childViewControllers] lastObject];
        secondViewController = [self controllerForDisplayMode:displayMode];
        secondViewController.view.frame = self.contentView.bounds;
        secondViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [firstViewController willMoveToParentViewController:nil];
        [self addChildViewController:secondViewController];
        
        self.navigationController.view.userInteractionEnabled = NO;
        [self transitionFromViewController:firstViewController
                          toViewController:secondViewController
                                  duration:(animated ? 0.5 : 0.0)
                                   options:(displayMode == DisplayModeList ? UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight)
                                animations:^{}
                                completion:^(BOOL finished) {
                                    [firstViewController removeFromParentViewController];
                                    [secondViewController didMoveToParentViewController:self];
                                    self.navigationController.view.userInteractionEnabled = YES;
                                }];
        
        _displayMode = displayMode;
    }
}

/**
 * This method load html content of urlString and process to know list of tags.
 */
- (void)loadData
{
    self.switchButton.enabled = NO;
    NSURLSession *session = [NSURLSession sharedSession];
    __weak __typeof(&*self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            return;
        }
        NSString* htmlSourceCode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        weakSelf.hrefList = [NSString listOfATagFields:htmlSourceCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAlert];
        });
    }];
    
    [dataTask resume];
}

/**
 * Show alert when loadData finish
 */
- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information" message:[NSString stringWithFormat:@"The website %@ have %lu 'hrefs' fields in 'a' tags", urlString,(unsigned long)[self.hrefList count]] preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(&*self)weakSelf = self;
    UIAlertAction* visit = [UIAlertAction
                         actionWithTitle:@"Check List"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [weakSelf switchViewControllers:self.switchButton];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:visit];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
            self.switchButton.enabled = YES;
    }];
}

@end
