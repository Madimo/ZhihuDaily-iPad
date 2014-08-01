//
//  ZHStoryCell.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHStoryCell.h"
#import "ZHStory.h"

@interface ZHStoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;

@end

@implementation ZHStoryCell

- (void)setStory:(ZHStory *)story
{
    _story = story;
    
    self.titleLabel.text = story.title;
    
    NSURL *url = [NSURL URLWithString:story.imageUrls[0]];
    [self.storyImageView sd_setImageWithURL:url];
}

@end
