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
  UIView *noMessageView;
}

@synthesize scrollView = _scrollView;
@synthesize messageTextField = _messageTextField;
@synthesize accessToken = _accessToken;
@synthesize myUserName = _myUserName;
@synthesize friendUserName = _friendUserName;
@synthesize chatList = _chatList;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = _friendUserName;
  
  messageHistoryTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  messageHistoryTableView.delegate = self;
  messageHistoryTableView.dataSource = self;
  [messageHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [messageHistoryTableView reloadData];
  [messageHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageList"];
  [self.view addSubview:messageHistoryTableView];
  
  if ([_chatList count] == 0)
  {
    noMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    noMessageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noMessageView];
    
    UILabel *noMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 30.0)];
    [noMessageLabel setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [noMessageLabel setText:@"No Message"];
    [noMessageLabel setTextColor:[UIColor darkGrayColor]];
    [noMessageView addSubview:noMessageLabel];
  }
  
  UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  sendMessageButton.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-31, 50.0, 30.0);
  [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [sendMessageButton setBackgroundColor:[UIColor lightGrayColor]];
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
  return [_chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"MessageList";
  UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  SCChatMessage *chatMessage = [[SCChatMessage alloc] init];
  chatMessage = [_chatList objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
  if ([chatMessage.user_name isEqualToString:_myUserName])
    cell.textLabel.textAlignment = UITextAlignmentRight;
  cell.textLabel.text = chatMessage.msg;
  
  return cell;
}

- (void)sendMessageRequestWithText:(NSString*)textMessage at:(NSString*)createdTime
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:@"http://104.155.215.148:5566/msgs"
     parameters:@{@"access_token":_accessToken, @"user_name": _friendUserName, @"msg": textMessage}
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"User: %@", responseObject);
          if ([[responseObject objectForKey:@"status"] intValue] == 0)
          {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Send Message Failed"
                                                              message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error"]]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
          }
          else
          {
            NSUInteger totalChat = [_chatList count];
            if (totalChat == 0)
            {
              [noMessageView removeFromSuperview];
              [messageHistoryTableView reloadData];
            }
            
            SCChatMessage *chatMessage = [[SCChatMessage alloc] init];
            chatMessage.created_at = createdTime;
            chatMessage.user_name = _myUserName;
            chatMessage.msg = textMessage;
            [_chatList setObject:chatMessage  forKey:[NSString stringWithFormat:@"%lu", (unsigned long)[_chatList count]+1]];
            _messageTextField.text = @"";
            
            [messageHistoryTableView reloadData];
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

- (void)sendMessageButtonPressed:(UIButton *)button
{
  [_messageTextField resignFirstResponder];
  
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:@"EEE, dd MMM yyy HH:mm:ss"];
  NSDate *now = [[NSDate alloc] init];
  NSString *dateString = [NSString stringWithFormat:@"%@ GMT", [format stringFromDate:now]];
  
  if (![_messageTextField.text isEqualToString:@""])
    [self sendMessageRequestWithText:_messageTextField.text at:dateString];
}

@end
