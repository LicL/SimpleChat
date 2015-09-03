//
//  SCChatMessageCell.m
//  SimpleChat
//
//  Created by Devi Eddy on 9/3/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCChatMessageCell.h"

@implementation SCChatMessageCell

@synthesize myMessageLabel = _myMessageLabel;
@synthesize friendMessageLabel = _friendMessageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    _myMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2, 0, self.contentView.frame.size.width/2-10, 30.0)];
    [_myMessageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_myMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_myMessageLabel setTextAlignment:NSTextAlignmentRight];
    [_myMessageLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_myMessageLabel];
    
    _friendMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width/2-10, 30.0)];
    [_friendMessageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_friendMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_friendMessageLabel setTextAlignment:NSTextAlignmentLeft];
    [_friendMessageLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_friendMessageLabel];
  }
  
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
