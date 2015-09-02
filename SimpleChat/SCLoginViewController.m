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

@synthesize userNameTextField = _userNameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize user = _user;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  _user = [[SCUser alloc] init];
  
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

- (void)loginRequestWithUsername: (NSString*)Username andPassword:(NSString*)Password
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:@"http://104.155.215.148:5566/login"
     parameters:@{@"user_name":Username, @"password": Password}
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"User: %@", responseObject);
          if ([[responseObject objectForKey:@"status"] intValue] == 0)
          {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                              message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error"]]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
          }
          else
          {
            _user.accessToken = [[responseObject objectForKey:@"data"] objectForKey:@"access_token"];
            _user.user_name = [[responseObject objectForKey:@"data"] objectForKey:@"user_name"];
            _user.display_name = [[responseObject objectForKey:@"data"] objectForKey:@"display_name"];
            _user.imageURL = [[responseObject objectForKey:@"data"] objectForKey:@"avatar"];
            if ([[responseObject objectForKey:@"data"] objectForKey:@"gender"] == 0)
              _user.gender = @"Female";
            else
              _user.gender = @"Male";
            _user.age = [[responseObject objectForKey:@"data"] objectForKey:@"age"];
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
  userViewController.user = _user;
  UINavigationController *navigationUserViewController = [[UINavigationController alloc]initWithRootViewController:userViewController];
  [self presentModalViewController:navigationUserViewController animated:NO];
}

- (BOOL)checkInputWithUsername:(NSString*)Username andPassword:(NSString*)Password
{
  if([Username isEqualToString:@""] && [Password isEqualToString:@""])
  {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                      message:[NSString stringWithFormat:@"%@", @"Blank Username and Password"]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    return FALSE;
  }
  else if ([Username isEqualToString:@""])
  {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                      message:[NSString stringWithFormat:@"%@", @"Blank Username"]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    return FALSE;
    
  }
  else if([Password isEqualToString:@""])
  {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                      message:[NSString stringWithFormat:@"%@", @"Blank Password"]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    return FALSE;
    
  }
  else
  {
    return TRUE;
  }
  
}

- (void)loginClicked:(UIButton *)button
{
  [_userNameTextField resignFirstResponder];
  [_passwordTextField resignFirstResponder];
  
  if ([self checkInputWithUsername:_userNameTextField.text andPassword:_passwordTextField.text]) {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self loginRequestWithUsername:_userNameTextField.text andPassword:_passwordTextField.text];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
  }
  
}

@end
