//
//  User.h
//  SimpleChat
//
//  Created by Devi Eddy on 9/2/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *display_name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSMutableArray *chatHistory;

@end
