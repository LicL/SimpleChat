//
//  SCMessageViewController.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCMessageViewController.h"

@interface SCMessageViewController ()

@end

@implementation SCMessageViewController
{
  UITableView *messageHistoryTableView;
}

@synthesize scrollView = _scrollView;
@synthesize messageTextField = _messageTextField;
//@synthesize messageHistoryTableView = _messageHistoryTableView;
@synthesize accessToken = _accessToken;
@synthesize friendId = _friendId;
@synthesize messageArray = _messageArray;
@synthesize activeTextField = _activeTextField;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  messageHistoryTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  messageHistoryTableView.delegate = self;
  messageHistoryTableView.dataSource = self;
  [messageHistoryTableView reloadData];
  [messageHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageList"];
  [self.view addSubview:messageHistoryTableView];
  
  _messageArray = [[NSMutableArray alloc] init];
  [_messageArray addObject:[NSString stringWithFormat:@"D"]];
  [_messageArray addObject:[NSString stringWithFormat:@"E"]];
  [_messageArray addObject:[NSString stringWithFormat:@"F"]];
  [_messageArray addObject:[NSString stringWithFormat:@"G"]];
  
  UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  sendMessageButton.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-31, 50.0, 30.0);
  [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [sendMessageButton setBackgroundColor:[UIColor purpleColor]];
  [sendMessageButton setTitle:@"Send" forState:UIControlStateNormal];
  [sendMessageButton addTarget:self
                       action:@selector(sendMessageButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:sendMessageButton];
  
  _messageTextField = [[UITextField alloc] init];
  _messageTextField.frame = CGRectMake(1, self.view.frame.size.height-31, self.view.frame.size.width-52.0, 30.0);
  _messageTextField.borderStyle = UITextBorderStyleRoundedRect;
  _messageTextField.placeholder = @"Type your message...";
  _messageTextField.delegate = self;
  [self.view addSubview:_messageTextField];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)sendMessageButtonPressed:(UIButton *)button
{
  NSString *msg = _messageTextField.text;
  NSLog(@"-- MessageVC --");
  NSLog(@"%@", msg);
}

- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  [UIView animateWithDuration:0.3 animations:^{
    CGRect f = self.view.frame;
    f.origin.y = -keyboardSize.height;
    self.view.frame = f;
  }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
  [UIView animateWithDuration:0.3 animations:^{
    CGRect f = self.view.frame;
    f.origin.y = 0.0f;
    self.view.frame = f;
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
  return [_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"MessageList";
  UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  cell.textLabel.text = [_messageArray objectAtIndex:indexPath.row];
  
  return cell;
}

@end
