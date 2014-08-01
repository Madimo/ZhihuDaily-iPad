//
//  ZHMasterViewController.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHMasterViewController.h"
#import "NSString+Date.h"
#import "NSDate+String.h"
#import "ZHClient.h"
#import "ZHStoryCell.h"

@interface ZHMasterViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *footerActivityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSMutableDictionary *stories;
@end

@implementation ZHMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dates = [NSMutableArray new];
    self.stories = [NSMutableDictionary new];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(refreshStories)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self refreshStories];
}

- (void)refreshStories
{
    [self.refreshControl beginRefreshing];
    
    ZHClient *client = [ZHClient client];
    [client getLatestStoriesWithSuccess:^(NSString *date, NSArray *stories, NSArray *topStories) {
        [self.dates removeAllObjects];
        [self.stories removeAllObjects];
        [self.dates addObject:date];
        [self.stories setObject:stories forKey:date];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    }
    failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    }];
}

- (void)loadNext
{
    if (self.footerActivityIndicator.isAnimating ||
        self.refreshControl.isRefreshing  ||
        !self.dates.count) {
        return;
    }
    
    [self.footerActivityIndicator startAnimating];
    
    NSDate *date = [((NSString *)[self.dates lastObject]) toDate];
    NSDate *loadDate = [NSDate dateWithTimeInterval:-(24 * 3600) sinceDate:date];
    NSString *loadDateString = [loadDate toString];
    
    ZHClient *client = [ZHClient client];
    [client getPastStoriesWithDate:loadDateString
                           success:^(NSString *date, NSArray *stories) {
                               [self.dates addObject:date];
                               [self.stories setObject:stories forKey:date];
                               
                               NSInteger section = self.dates.count - 1;
                               NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                                   [self.footerActivityIndicator stopAnimating];
                               });
                           }
                           failure:^(NSError *error) {
                               [self.footerActivityIndicator stopAnimating];
                           }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stories[self.dates[section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 30);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = self.dates[section];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell" forIndexPath:indexPath];
    
    ZHStory *story = self.stories[self.dates[indexPath.section]][indexPath.row];
    cell.story = story;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y > scrollView.contentSize.height - 1000) {
        [self loadNext];
    }
}

@end
