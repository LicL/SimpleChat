//
//  SCFriendListTableViewController.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCFriendListTableViewController.h"

@interface SCFriendListTableViewController ()

@end

@implementation SCFriendListTableViewController
{
  UITableView *tableView;
}

@synthesize accessToken = _accessToken;
@synthesize myUserName = _myUserName;
@synthesize friendList = _friendList;
@synthesize chatList = _chatList;

- (UITableView *)makeTableView
{
  tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  tableView.delegate = self;
  tableView.dataSource = self;
  [tableView reloadData];
  
  return tableView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title = @"Friend List";
  
  _chatList = [[NSMutableDictionary alloc] init];
  
  tableView = [self makeTableView];
  [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FriendList"];
  [self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
  return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"FriendList";
  UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  SCUser *friend = [[SCUser alloc] init];
  friend = [_friendList objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
  cell.imageView.layer.cornerRadius = 20;
  cell.imageView.clipsToBounds = YES;
  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:friend.imageURL]];
  cell.imageView.image = [UIImage imageWithData:imageData];
  cell.textLabel.text = friend.user_name;
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCUser *friend = [[SCUser alloc] init];
  friend = [_friendList objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
  [self messageRequestWithUsername:friend.user_name];
}

- (void)messageRequestWithUsername:(NSString*)Username
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:@"http://104.155.215.148:5566/msgs"
    parameters:@{@"access_token": _accessToken, @"user_name": Username}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"Messages : %@", responseObject);
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
           NSUInteger totalChat = [[responseObject objectForKey:@"data"] count];
           NSUInteger c = totalChat-1;
           for (NSUInteger i=0; i<totalChat; i++)
           {
             SCChatMessage *chatMessage = [[SCChatMessage alloc] init];
             chatMessage.created_at = [[[responseObject objectForKey:@"data"] objectAtIndex:c] objectForKey:@"created_at"];
             chatMessage.user_name = [[[responseObject objectForKey:@"data"] objectAtIndex:c] objectForKey:@"user_name"];
             if ([[[responseObject objectForKey:@"data"] objectAtIndex:c] objectForKey:@"msg"] != [NSNull null])
               chatMessage.msg = [[[responseObject objectForKey:@"data"] objectAtIndex:c] objectForKey:@"msg"];
             else
               chatMessage.msg = @"";
             [_chatList setObject:chatMessage  forKey:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
             c--;
           }
           [self goToMessageListWithUsername:Username];
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

- (void)goToMessageListWithUsername:(NSString*)Username
{
  SCMessageViewController *messageViewController = [[SCMessageViewController alloc] init];
  messageViewController.accessToken = _accessToken;
  messageViewController.myUserName = _myUserName;
  messageViewController.friendUserName = Username;
  messageViewController.chatList = _chatList;
  [self.navigationController pushViewController:messageViewController animated:YES];
}

@end
