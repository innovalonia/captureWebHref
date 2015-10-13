//
//  NSString+CWHrefFields.h
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 8/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CWHrefFields)

/**
 * Class method to find all the list of "a" tags with regular expression
 */
+ (NSArray *)listOfATagFields:(NSString *)htmlSourceCode;

/**
 * Class method to extract only hrefs in each "a" tag
 */
+ (NSString *)extractHrefFromString:(NSString *)dirtyString;

@end
