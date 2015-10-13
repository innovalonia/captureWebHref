//
//  captureWebHrefTests.m
//  captureWebHrefTests
//
//  Created by Alejandro Ramos Grifé on 6/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MasterViewController.h"
#import "WebPageViewController.h"
#import "HrefListViewController.h"
#import "NSString+CWHrefFields.h"

@interface captureWebHrefTests : XCTestCase

@property (nonatomic, copy) NSString *htmlCode;
@property (nonatomic, copy) NSString *urlString;

@end

@implementation captureWebHrefTests

- (void)setUp
{
    [super setUp];
    
    self.htmlCode = @"<a href=\"http://www.google.es\"></a><a href=\"http://www.amazon.es\"></a><a href=\"http://www.apple.es\"></a>";
}

- (void)testListArray
{
    XCTAssertTrue([[NSString listOfATagFields:self.htmlCode] isKindOfClass:[NSArray class]], @"list of tags should be NSArray");
}

- (void)testCountListArray
{
    XCTAssertTrue([NSString listOfATagFields:self.htmlCode].count == 3, @"number of hrefs should be 3");
}

- (void)testTrue
{
    XCTAssert(true, @"true should be true");
}

- (void)testFalse
{
    XCTAssertFalse(false, @"false should be false");
}

- (void)testNil {
    XCTAssertNil(nil, @"nil should be nil");
}

- (void)testNotNil {
    XCTAssertNotNil(@"hello", @"hello should not be nil");
}

@end
