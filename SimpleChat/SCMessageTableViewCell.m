//
//  SCMessageTableViewCell.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCMessageTableViewCell.h"

@implementation SCMessageTableViewCell

@synthesize friendChatLabel = _friendChatLabel;
@synthesize myChatLabel = _myChatLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    [self initiate];
  }
  return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self initiate];
}

- (void)initiate
{
  _friendChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 260, 16)];
  _friendChatLabel.backgroundColor = [UIColor greenColor];
  //    _friendChatLabel.textColor = [UIColor blackColor];
  //    _friendChatLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
  [self addSubview:_friendChatLabel];
  
  _myChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(332, 8, 260, 16)];
  _myChatLabel.backgroundColor = [UIColor blueColor];
  [self addSubview:_myChatLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
