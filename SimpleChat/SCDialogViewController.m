//
//  SCDialogViewController.m
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import "SCDialogViewController.h"

@interface SCDialogViewController ()

@end

@implementation SCDialogViewController
{
  UIScrollView *scrollView;
}

@synthesize scrollView = _scrollView;
@synthesize messageTextField = _messageTextField;
@synthesize messageHistoryTableView = _messageHistoryTableView;
@synthesize myUserId = _myUserId;
@synthesize friendId = _friendId;
@synthesize messageArray = _messageArray;
@synthesize activeTextField = _activeTextField;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title = _friendId;
  
  UIScrollView *tempScrollView=(UIScrollView *)self.view;
  tempScrollView.contentSize=CGSizeMake(1280,960);
  
  _messageArray = [[NSMutableArray alloc] init];
  _messageHistoryTableView.rowHeight = UITableViewAutomaticDimension;
  [self retrieveMessagesFromParseWithFriendID:_friendId];
  
  UITapGestureRecognizer *tapTableGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView)];
  [_messageHistoryTableView addGestureRecognizer:tapTableGR];
  [self registerForKeyboardNotifications];
}

- (void)loadView
{
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
  _scrollView.backgroundColor = [UIColor whiteColor];
  _scrollView.scrollEnabled = YES;
  _scrollView.pagingEnabled = YES;
  _scrollView.showsVerticalScrollIndicator = YES;
  _scrollView.showsHorizontalScrollIndicator = YES;
  _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height);
  [self.view addSubview:_scrollView];
  
  _messageTextField = [[UITextField alloc] init];
  _messageTextField.frame = CGRectMake(1, self.view.frame.size.height-31, self.view.frame.size.width-52.0, 30.0);
  _messageTextField.borderStyle = UITextBorderStyleRoundedRect;
  _messageTextField.placeholder = @"Type your message...";
  _messageTextField.delegate = self;
  [self.view addSubview:_messageTextField];
  
  _messageHistoryTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _messageHistoryTableView.delegate = self;
  _messageHistoryTableView.dataSource = self;
  [_messageHistoryTableView reloadData];
  [_messageHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageList"];
  [self.view addSubview:_messageHistoryTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(messageDelivered:)
//                                               name:SINCH_MESSAGE_RECIEVED
//                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(messageDelivered:)
//                                               name:SINCH_MESSAGE_SENT
//                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didTapOnTableView
{
  [self.activeTextField resignFirstResponder];
}

#pragma mark - keyboard movements
- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
  NSDictionary* info = [notification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(kbSize.height, 0.0, kbSize.height, 0.0);
  _scrollView.contentInset = contentInsets;
  _scrollView.scrollIndicatorInsets = contentInsets;
  
  CGRect aRect = self.view.frame;
  aRect.size.height -= kbSize.height;
  if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
    [_scrollView scrollRectToVisible:self.activeTextField.frame animated:NO];
  }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  _scrollView.contentInset = contentInsets;
  _scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  _activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  _activeTextField = nil;
}

- (void)messageDelivered:(NSNotification *)notification
{
  SCChatMessage *chatMessage = [[notification userInfo] objectForKey:@"message"];
  [_messageArray addObject:chatMessage];
  [_messageHistoryTableView reloadData];
  [self scrollTableToBottom];
}

-(void)sendMessage:(id)sender
{
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate sendTextMessage:_messageTextField.text toRecipient:_friendId];
}

- (void)scrollTableToBottom
{
  int rowNumber = [_messageHistoryTableView numberOfRowsInSection:0];
  if (rowNumber > 0) [_messageHistoryTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber-1 inSection:0]
                                                     atScrollPosition:UITableViewScrollPositionBottom
                                                             animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;//[_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"FriendList";
  SCMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  [self configureCell:messageCell forIndexPath:indexPath];
  
  return messageCell;
}

#pragma mark Method to configure the appearance of a message list prototype cell

- (void)configureCell:(SCMessageTableViewCell *)messageCell forIndexPath:(NSIndexPath *)indexPath
{
  
  SCChatMessage *chatMessage = self.messageArray[indexPath.row];
  
  if ([[chatMessage senderId] isEqualToString:self.myUserId])
  {
    // If the message was sent by myself
    messageCell.friendChatLabel.text = @"";
    messageCell.myChatLabel.text = chatMessage.text;
  }
  else
  {
    // If the message was sent by the chat mate
    messageCell.myChatLabel.text = @"";
    messageCell.friendChatLabel.text = chatMessage.text;
  }
}

- (void)retrieveMessagesFromParseWithFriendID:(NSString *)friendId
{
  NSArray *userNames = @[_myUserId, _friendId];
  
//  PFQuery *query = [PFQuery queryWithClassName:@"SinchMessage"];
//  [query whereKey:@"senderId" containedIn:userNames];
//  [query whereKey:@"recipientId" containedIn:userNames];
//  [query orderByAscending:@"timestamp"];
//  
//  __weak typeof(self) weakSelf = self;
//  [query findObjectsInBackgroundWithBlock:^(NSArray *chatMessageArray, NSError *error)
//  {
//    if (!error)
//    {
//      // Store all retrieve messages into historicalMessagesArray
//      for (int i = 0; i < [chatMessageArray count]; i++)
//      {
//        SCChatMessage *chatMessage = [[SCChatMessage alloc] init];
//        
//        [chatMessage setMessageId:chatMessageArray[i][@"messageId"]];
//        [chatMessage setSenderId:chatMessageArray[i][@"senderId"]];
//        [chatMessage setRecipientIds:[NSArray arrayWithObject:chatMessageArray[i][@"recipientId"]]];
//        [chatMessage setText:chatMessageArray[i][@"text"]];
//        [chatMessage setTimestamp:chatMessageArray[i][@"timestamp"]];
//        
//        [weakSelf.messageArray addObject:chatMessage];
//      }
//      [weakSelf.historicalMessagesTableView reloadData];  // Refresh the table view
//      [weakSelf scrollTableToBottom];  // Scroll to the bottom of the table view
//    }
//    else
//    {
//      NSLog(@"Error: %@", error.description);
//    }
//  }];
}

//- (void)sendMessageButtonPressed:(UIButton *)button
//{
//  NSString *msg = _messageTextField.text;
//  NSLog(@"-- MessageVC --");
//  NSLog(@"%@", msg);
//}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
