//
//  WebPageViewController.h
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 7/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Displays a given default url in webView
 */
@interface WebPageViewController : UIViewController

- (instancetype)initWithURL:(NSURL *)URL;

@end
