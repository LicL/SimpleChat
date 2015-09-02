//
//  SCLoginViewController.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

#import "SCUser.h"
#import "SCUserViewController.h"

@interface SCLoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) SCUser *user;

@end
