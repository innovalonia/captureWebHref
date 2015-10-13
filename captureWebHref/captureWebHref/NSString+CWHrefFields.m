//
//  NSString+CWHrefFields.m
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 8/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import "NSString+CWHrefFields.h"

@implementation NSString (CWHrefFields)

+ (NSArray *)listOfATagFields:(NSString *)htmlSourceCode
{    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]+href=\"(.*?)\"[^>]*>.*?</a>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlSourceCode options:0 range:NSMakeRange(0, [htmlSourceCode length])];
    NSMutableArray *arrayOfURLs = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString* substringForMatch = [htmlSourceCode substringWithRange:match.range];
        [arrayOfURLs addObject:[self extractHrefFromString:substringForMatch]];
    }

    return [NSArray arrayWithArray:arrayOfURLs];
}

+ (NSString *)extractHrefFromString:(NSString *)dirtyString
{
    NSString* deletePrefixString = [[dirtyString componentsSeparatedByString:@"href=\""] objectAtIndex:1];
    NSRange searchResult = [deletePrefixString rangeOfString:@"\""];
    NSRange range = NSMakeRange(0, searchResult.location);
    return [deletePrefixString substringWithRange:range];
}

@end
