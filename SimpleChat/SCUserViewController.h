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
#import "SCFriendListTableViewController.h"

@interface SCUserViewController : UIViewController

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *display_name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *age;

@end
