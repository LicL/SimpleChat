//
//  SCChatMessageCell.h
//  SimpleChat
//
//  Created by Devi Eddy on 9/3/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCChatMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *myMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendMessageLabel;

@end
