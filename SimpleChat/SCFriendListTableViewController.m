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
@synthesize friendListArray = _friendListArray;
@synthesize friendThumbnailArray = _friendThumbnailArray;

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
  _friendListArray = [[NSMutableArray alloc] init];
  _friendThumbnailArray = [[NSMutableArray alloc] init];
  
  [_friendListArray addObject:[NSString stringWithFormat:@"A"]];
  [_friendListArray addObject:[NSString stringWithFormat:@"B"]];
  [_friendListArray addObject:[NSString stringWithFormat:@"C"]];
  [_friendThumbnailArray addObject:[NSString stringWithFormat:@"starbucks.jpg"]];
  [_friendThumbnailArray addObject:[NSString stringWithFormat:@"starbucks.jpg"]];
  [_friendThumbnailArray addObject:[NSString stringWithFormat:@"starbucks.jpg"]];
  
  tableView = [self makeTableView];
  [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FriendList"];
  [self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
//  _activeDialogViewController = nil;
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
  return [_friendThumbnailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"FriendList";
  UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  cell.imageView.layer.cornerRadius = 20;
  cell.imageView.clipsToBounds = YES;
  cell.imageView.image = [UIImage imageNamed:[_friendThumbnailArray objectAtIndex:indexPath.row]];
  cell.textLabel.text = [_friendListArray objectAtIndex:indexPath.row];
  
  return cell;
}

#pragma mark - UITableViewDelegate

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"-- FriendListVC --");
  NSLog(@"%@", [_friendListArray objectAtIndex:indexPath.row]);
  NSLog(@"userToken: %@ friendToken: %@", _accessToken, _friendListArray[indexPath.row]);
  
  SCMessageViewController *messageViewController = [[SCMessageViewController alloc] init];
  messageViewController.accessToken = _accessToken;
  messageViewController.friendId = _friendListArray[indexPath.row];
  [self.navigationController pushViewController:messageViewController animated:YES];
}

@end
