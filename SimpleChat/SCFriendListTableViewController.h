//
//  SCFriendListTableViewController.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SCMessageViewController.h"// 不用了
#import "SCDialogViewController.h"

@interface SCFriendListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property (strong, nonatomic) SCDialogViewController *activeDialogViewController;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSMutableArray *friendListArray;
@property (strong, nonatomic) NSMutableArray *friendThumbnailArray;

@end
