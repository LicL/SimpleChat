//
//  SCUserViewController.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCUserViewController.h"

@interface SCUserViewController ()

@end

@implementation SCUserViewController

@synthesize accessToken = _accessToken;
@synthesize imageURL = _imageURL;
@synthesize display_name = _display_name;
@synthesize gender = _gender;
@synthesize age = _age;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self.navigationController setTitle:@"Profile"];
  
  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]];
  
  UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90.0, 160.0, 160.0)];
  userPic.image = [UIImage imageWithData:imageData];
  userPic.layer.cornerRadius = userPic.frame.size.height/2;
  userPic.clipsToBounds = YES;
  [userPic setCenter:CGPointMake(self.view.center.x, userPic.center.y)];
  [self.view addSubview:userPic];

  UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 270.0, 100.0, 30.0)];
  [userLabel setCenter:CGPointMake(self.view.center.x, userLabel.center.y)];
  [userLabel setText:_display_name];
  userLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:userLabel];

  UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 305.0, 100.0, 30.0)];
  [genderLabel setCenter:CGPointMake(self.view.center.x, genderLabel.center.y)];
  [genderLabel setText:_gender];
  genderLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:genderLabel];
  
  UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 340.0, 100.0, 30.0)];
  [ageLabel setCenter:CGPointMake(self.view.center.x, ageLabel.center.y)];
  [ageLabel setText:[NSString stringWithFormat:@"%@", _age]];
  ageLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:ageLabel];

  UIButton *friendListButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  friendListButton.frame = CGRectMake(0, 400.0, 160.0, 30.0);
  [friendListButton setCenter:CGPointMake(self.view.center.x, friendListButton.center.y)];
  [friendListButton setTitle:@"Friend List" forState:UIControlStateNormal];
  [friendListButton addTarget:self
                       action:@selector(friendListButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:friendListButton];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)goToFrienList
{
  SCFriendListTableViewController *friendListTableViewController = [[SCFriendListTableViewController alloc] init];
  friendListTableViewController.accessToken = _accessToken;
  [self.navigationController pushViewController:friendListTableViewController animated:YES];
}

- (void)friendListButtonPressed:(UIButton *)button
{
  NSLog(@"-- UserVC --");
  NSLog(@"access_token: %@", _accessToken);
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:@"http://104.155.215.148:5566/users"
    parameters:@{@"access_token": _accessToken}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject objectForKey:@"status"])
         {
           
           [self goToFrienList];
         }
         else
         {
           UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                             message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error"]]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
           [message show];
         }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                           message:[NSString stringWithFormat:@"%@", error]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
         [message show];
       }];
}

@end
