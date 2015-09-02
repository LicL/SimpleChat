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

@synthesize user = _user;
@synthesize friendList = _friendList;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self.navigationController setTitle:@"Profile"];
  
  _friendList = [[NSMutableDictionary alloc] init];
  
  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_user.imageURL]];
  UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90.0, 160.0, 160.0)];
  userPic.image = [UIImage imageWithData:imageData];
  userPic.layer.cornerRadius = userPic.frame.size.height/2;
  userPic.clipsToBounds = YES;
  [userPic setCenter:CGPointMake(self.view.center.x, userPic.center.y)];
  [self.view addSubview:userPic];

  UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 270.0, 100.0, 30.0)];
  [userLabel setCenter:CGPointMake(self.view.center.x, userLabel.center.y)];
  [userLabel setText:_user.display_name];
  userLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:userLabel];

  UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 305.0, 100.0, 30.0)];
  [genderLabel setCenter:CGPointMake(self.view.center.x, genderLabel.center.y)];
  [genderLabel setText:_user.gender];
  genderLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:genderLabel];
  
  UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 340.0, 100.0, 30.0)];
  [ageLabel setCenter:CGPointMake(self.view.center.x, ageLabel.center.y)];
  [ageLabel setText:[NSString stringWithFormat:@"%@", _user.age]];
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

- (void)goToFriendList
{
  SCFriendListTableViewController *friendListTableViewController = [[SCFriendListTableViewController alloc] init];
  friendListTableViewController.accessToken = _user.accessToken;
  friendListTableViewController.myUserName = _user.user_name;
  friendListTableViewController.friendList = _friendList;
  [self.navigationController pushViewController:friendListTableViewController animated:YES];
}

- (void)friendListRequest
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:@"http://104.155.215.148:5566/users"
    parameters:@{@"access_token": _user.accessToken}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"Friend List : %@", responseObject);
         if ([[responseObject objectForKey:@"status"] intValue]==0)
         {
           UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                             message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error"]]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
           [message show];
         }
         else
         {
           NSUInteger totalFriend = [[responseObject objectForKey:@"data"] count]-1; //扣掉自己
           for (NSUInteger f=1; f<=totalFriend; f++)
           {
             SCUser *friend = [[SCUser alloc] init];
             friend.display_name = [[[responseObject objectForKey:@"data"] objectAtIndex:f] objectForKey:@"display_name"];
             friend.user_name = [[[responseObject objectForKey:@"data"] objectAtIndex:f] objectForKey:@"user_name"];
             friend.imageURL = [[[responseObject objectForKey:@"data"] objectAtIndex:f] objectForKey:@"avatar"];
             friend.age = [[[responseObject objectForKey:@"data"] objectAtIndex:f] objectForKey:@"age"];
             if ([[[responseObject objectForKey:@"data"] objectAtIndex:f] objectForKey:@"gender"] == 0)
               friend.gender = @"Female";
             else
               friend.gender = @"Male";
             [_friendList setObject:friend  forKey:[NSString stringWithFormat:@"%lu", (unsigned long)f-1]];
           }
           [self goToFriendList];
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

- (void)friendListButtonPressed:(UIButton *)button
{
  [self friendListRequest];
}

@end
