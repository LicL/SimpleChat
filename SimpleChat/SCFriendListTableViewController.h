//
//  SCFriendListTableViewController.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"

#import "SCUser.h"
#import "SCChatMessage.h"
#import "SCMessageViewController.h"

@interface SCFriendListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *accessToken;
@property (nonatomic, strong) NSString *myUserName;
@property (strong, nonatomic) NSMutableDictionary *friendList;
@property (strong, nonatomic) NSMutableDictionary *chatList;

@end
