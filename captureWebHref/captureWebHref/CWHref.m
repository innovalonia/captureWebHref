//
//  CWHref.m
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 7/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import "CWHref.h"

@implementation CWHref

- (instancetype)initWithHref:(NSString *)hrefLink title:(NSString *)hrefTitle
{
    if (self = [super init]) {
        _href = hrefLink;
        _title = hrefTitle;
    }
    return self;
}

@end
