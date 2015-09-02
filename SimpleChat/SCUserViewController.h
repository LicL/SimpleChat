//
//  SCUserViewController.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"

#import "SCUser.h"
#import "SCFriendListTableViewController.h"

@interface SCUserViewController : UIViewController

@property (strong, nonatomic) SCUser *user;
@property (strong, nonatomic) NSMutableDictionary *friendList;

@end
