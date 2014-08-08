//
//  ZHMasterViewController.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHMasterViewController.h"
#import "ZHDetailViewController.h"
#import "NSString+Date.h"
#import "NSDate+String.h"
#import "ZHClient.h"
#import "ZHStoryCell.h"

@interface ZHMasterViewController ()
@property (weak, nonatomic) ZHDetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *footerActivityIndicator;
@property (strong, nonatomic) NSMutableArray *sectionHeaderViews;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSMutableDictionary *stories;
@end

@implementation ZHMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationController *nc = self.splitViewController.viewControllers.lastObject;
    self.detailViewController = nc.viewControllers.firstObject;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged:)
                                                 name:kThemeChangedNotification
                                               object:nil];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.dates = [NSMutableArray new];
    self.stories = [NSMutableDictionary new];
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshStories)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self refreshStories];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChanged:(NSNotification *)notification
{
    if (self.sectionHeaderViews) {
        for (UIView *headerView in self.sectionHeaderViews) {
            headerView.backgroundColor = nightMode ? [UIColor colorWithWhite:0.3 alpha:0.95] : [UIColor colorWithWhite:0.95 alpha:0.95];
            
            UILabel *label = headerView.subviews[0];
            label.textColor = nightMode ? [UIColor lightGrayColor] : [UIColor blackColor];
        }
    }
    
    self.tableView.backgroundColor = nightMode ? nightModeContentBackgroundColor : lightModeContentBackgroundColor;
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
            
            if (self.detailViewController.story) {
                for (ZHStory *story in stories) {
                    if ([story.storyId isEqualToString:self.detailViewController.story.storyId]) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[stories indexOfObject:story] inSection:0];
                        [self.tableView selectRowAtIndexPath:indexPath
                                                    animated:NO
                                              scrollPosition:UITableViewScrollPositionNone];
                        break;
                    }
                }
            }
            
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
    
    ZHClient *client = [ZHClient client];
    [client getPastStoriesWithDate:[self.dates lastObject]
                           success:^(NSString *date, NSArray *stories) {
                               [self.dates addObject:date];
                               [self.stories setObject:stories forKey:date];
                               
                               NSInteger section = self.dates.count - 1;
                               NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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
    view.backgroundColor = nightMode ? [UIColor colorWithWhite:0.3 alpha:0.95] : [UIColor colorWithWhite:0.95 alpha:0.95];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = nightMode ? [UIColor lightGrayColor] : [UIColor blackColor];

    NSDate *date = [self.dates[section] toDate];
    NSString *weekdayString = [date weekdayString];
    label.text = [NSString stringWithFormat:@"%@・%@", [date toDisplayString], weekdayString];
    
    if (!self.sectionHeaderViews) {
        self.sectionHeaderViews = [NSMutableArray new];
    }
    [view addSubview:label];
    [self.sectionHeaderViews addObject:view];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell" forIndexPath:indexPath];
    
    ZHStory *story = self.stories[self.dates[indexPath.section]][indexPath.row];
    cell.story = story;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHStory *story = self.stories[self.dates[indexPath.section]][indexPath.row];
    [self.detailViewController setStory:story];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y > scrollView.contentSize.height - 1000) {
        [self loadNext];
    }
}

@end
