//
//  HrefListViewController.m
//  captureWebHref
//
//  Created by Alejandro Ramos Grifé on 7/10/15.
//  Copyright © 2015 visualEngineering. All rights reserved.
//

#import "HrefListViewController.h"
#import "CWHref.h"
#import "HrefCell.h"

static NSString *const HyperlinkCellIdentifier = @"hrefCell";

@interface HrefListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HrefListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView
{
    UITableView *tableView;
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.estimatedRowHeight = 50;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:HrefCell.class forCellReuseIdentifier:HyperlinkCellIdentifier];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hyperlinksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HyperlinkCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.hyperlinksArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL *url = [NSURL URLWithString:self.hyperlinksArray[indexPath.row]];
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
