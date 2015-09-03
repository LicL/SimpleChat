//
//  SCMessageViewController.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCMessageViewController.h"

static NSString *cellIdentifier = @"MessageList";

@interface SCMessageViewController ()

@end

@implementation SCMessageViewController
{
  UIScrollView *scrollView;
  UITableView *messageHistoryTableView;
  UIView *noMessageView;
}

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
  [self checkForDuplicates];
  
  scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.toolbar.frame.size.height+21, self.view.frame.size.width, self.view.frame.size.height-55.0)];
  scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  scrollView.showsVerticalScrollIndicator = YES;
  scrollView.scrollEnabled = YES;
  scrollView.userInteractionEnabled = YES;
  [self.view addSubview:scrollView];
  
  messageHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.toolbar.frame.size.height+21, self.view.frame.size.width, self.view.frame.size.height-55.0)];
  messageHistoryTableView.delegate = self;
  messageHistoryTableView.dataSource = self;
  messageHistoryTableView.rowHeight = UITableViewAutomaticDimension;
  [messageHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [messageHistoryTableView reloadData];
  [messageHistoryTableView registerClass:[SCChatMessageCell class] forCellReuseIdentifier:cellIdentifier];
  [self.view addSubview:messageHistoryTableView];
  
  if ([_chatList count] == 0)
  {
    noMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    noMessageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noMessageView];
    
    UILabel *noMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 30.0)];
    [noMessageLabel setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [noMessageLabel setText:@"No Message"];
    [noMessageLabel setTextColor:[UIColor darkGrayColor]];
    [noMessageView addSubview:noMessageLabel];
  }
  
  _messageTextField = [[UITextField alloc] init];
  _messageTextField.frame = CGRectMake(1, self.view.frame.size.height-31, self.view.frame.size.width-52.0, 30.0);
  _messageTextField.borderStyle = UITextBorderStyleRoundedRect;
  _messageTextField.placeholder = @"Type your message...";
  _messageTextField.delegate = self;
  [self.view addSubview:_messageTextField];
  
  UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  sendMessageButton.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-31, 50.0, 30.0);
  [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [sendMessageButton setBackgroundColor:[UIColor lightGrayColor]];
  [sendMessageButton setTitle:@"Send" forState:UIControlStateNormal];
  [sendMessageButton addTarget:self
                        action:@selector(sendMessageButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:sendMessageButton];
  
  [self scrollTableToBottom];
}

- (void)checkForDuplicates
{
  NSMutableDictionary *newChatList = [NSMutableDictionary dictionaryWithCapacity:[_chatList count]];
  for(id item in [_chatList allValues]){
    NSArray * keys = [_chatList allKeysForObject:item];
    [newChatList setObject:item forKey:[keys objectAtIndex:0]];
  }
  _chatList = [[[NSMutableDictionary alloc] initWithDictionary:newChatList] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)scrollTableToBottom
{
  NSUInteger rowNumber = [messageHistoryTableView numberOfRowsInSection:0];
  if (rowNumber > 0) [messageHistoryTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber-1 inSection:0]
                                                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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

#pragma mark - Keyboard Movements
- (void)keyboardWillShow:(NSNotification *)notification
{
  [self scrollTableToBottom];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  [self configureCell:cell forIndexPath:indexPath];
  
  return cell;
}

#pragma mark - Method to configure the appearance of a message list prototype cell

- (void)configureCell:(SCChatMessageCell*)messageCell forIndexPath:(NSIndexPath*)indexPath
{
  SCChatMessage *chatMessage = [[SCChatMessage alloc] init];
  chatMessage = [_chatList objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
  if ([chatMessage.user_name isEqualToString:_myUserName])
  {
    messageCell.friendMessageLabel.text = @"";
    messageCell.myMessageLabel.text = chatMessage.msg;
  }
  else
  {
    messageCell.myMessageLabel.text = @"";
    messageCell.friendMessageLabel.text = chatMessage.msg;
  }
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
            [_chatList setObject:chatMessage  forKey:[NSString stringWithFormat:@"%lu", (unsigned long)[_chatList count]]];
            _messageTextField.text = @"";
            
            [messageHistoryTableView reloadData];
            [self scrollTableToBottom];
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
