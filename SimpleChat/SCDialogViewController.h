//
//  SCDialogViewController.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "SCMessageTableViewCell.h"
#import "SCChatMessage.h"

@interface SCDialogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) IBOutlet UITableView *messageHistoryTableView;
@property (nonatomic, strong) NSString *myUserId;
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) NSMutableArray* messageArray;
@property (nonatomic, strong) UITextField *activeTextField;

- (IBAction)sendMessage:(id)sender;

@end
