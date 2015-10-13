//
//  HrefListViewController.h
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 7/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * TableView with results
 */
@interface HrefListViewController : UITableViewController

/**
* List of an array of hrefs links
*/
@property (nonatomic, copy) NSArray *hyperlinksArray;

@end
