//
//  ZHStoryCell.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHStoryCell.h"
#import "ZHCacheControl.h"
#import "ZHStory.h"

@interface ZHStoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;

@end

@implementation ZHStoryCell

- (void)awakeFromNib
{
    [self refreshColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged:)
                                                 name:kThemeChangedNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChanged:(NSNotification *)notification
{
    [self refreshColor];
}

- (void)refreshColor
{
    [self setSelected:self.selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [[ZHCacheControl cacheControl] setRead:self.story];
        self.titleLabel.alpha = 0.5;
    }
    
    if (selected) {
        self.contentView.backgroundColor = nightMode ? [UIColor darkGrayColor] : [UIColor colorWithRed:217.0 / 255.0
                                                                                                 green:217.0 / 255.0
                                                                                                  blue:217.0 / 255.0
                                                                                                 alpha:1.0];
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setStory:(ZHStory *)story
{
    _story = story;

    self.titleLabel.text = story.title;
    if ([[ZHCacheControl cacheControl] isRead:story]) {
        self.titleLabel.alpha = 0.5;
    } else {
        self.titleLabel.alpha = 1.0;
    }
    
    if (story.imageUrls.count) {
        NSURL *url = [NSURL URLWithString:story.imageUrls[0]];
        [self.storyImageView sd_setImageWithURL:url];
        
        CGRect frame = CGRectMake(97.0, 10.0, 217.0, 75.0);
        self.titleLabel.frame = frame;
        self.storyImageView.hidden = NO;
    } else {
        CGRect frame = CGRectMake(10, 10, 304.0, 75.0);
        self.titleLabel.frame = frame;
        self.storyImageView.hidden = YES;
    }
}

@end
