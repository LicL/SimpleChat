//
//  SCMessageViewController.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

#import "SCUser.h"
#import "SCChatMessage.h"
#import "SCChatMessageCell.h"

@interface SCMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *myUserName;
@property (nonatomic, strong) NSString *friendUserName;
@property (strong, nonatomic) NSMutableDictionary *chatList;


@end
