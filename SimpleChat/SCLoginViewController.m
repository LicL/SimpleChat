//
//  SCLoginViewController.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCLoginViewController.h"

@interface SCLoginViewController ()

@end

@implementation SCLoginViewController
{
  NSString *imageURL;
  NSString *display_name;
  NSString *gender;
  NSString *age;
}

@synthesize userNameTextField = _userNameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize accessToken = _accessToken;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 90.0, 100.0, 30.0)];
  [userLabel setText:@"Username"];
  [self.view addSubview:userLabel];
  
  _userNameTextField = [[UITextField alloc] init];
  _userNameTextField.frame = CGRectMake(140.0, 90.0, 160.0, 30.0);
  _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
  _userNameTextField.placeholder = @"username";
  [self.view addSubview:_userNameTextField];
  
  UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 130.0, 100.0, 30.0)];
  [passwordLabel setText:@"Password"];
  [self.view addSubview:passwordLabel];
  
  _passwordTextField = [[UITextField alloc] init];
  _passwordTextField.frame = CGRectMake(140.0, 130.0, 160.0, 30.0);
  _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
  _passwordTextField.placeholder = @"password";
  _passwordTextField.secureTextEntry = YES;
  [self.view addSubview:_passwordTextField];
  
  UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  loginButton.frame = CGRectMake(225.0, 175.0, 100.0, 30.0);
  [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
  [loginButton addTarget:self
                  action:@selector(loginClicked:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)loginRequest
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:@"http://104.155.215.148:5566/login"
     parameters:@{@"user_name": _userNameTextField.text, @"password": _passwordTextField.text}
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          if ([responseObject objectForKey:@"status"]==0)
          {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                              message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error"]]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
          }
          else
          {
            _accessToken = [[responseObject objectForKey:@"data"] objectForKey:@"access_token"];
            imageURL = [[responseObject objectForKey:@"data"] objectForKey:@"avatar"];
            display_name = [[responseObject objectForKey:@"data"] objectForKey:@"display_name"];
            if ([[responseObject objectForKey:@"data"] objectForKey:@"gender"] == 0)
              gender = @"Female";
            else
              gender = @"Male";
            age = [[responseObject objectForKey:@"data"] objectForKey:@"age"];
            [self loginData];
          }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                            message:[NSString stringWithFormat:@"%@", error]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
          [message show];
        }
   ];
}

- (void)loginData
{
  SCUserViewController *userViewController = [[SCUserViewController alloc] init];
  userViewController.accessToken = _accessToken;
  userViewController.imageURL = imageURL;
  userViewController.display_name = display_name;
  userViewController.gender = gender;
  userViewController.age = age;
  UINavigationController *navigationUserViewController = [[UINavigationController alloc]initWithRootViewController:userViewController];
  [self presentModalViewController:navigationUserViewController animated:NO];
}

- (void)loginClicked:(UIButton *)button
{
  NSLog(@"-- LoginVC --");
  [_userNameTextField resignFirstResponder];
  [_passwordTextField resignFirstResponder];
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self loginRequest];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  });
}

@end
