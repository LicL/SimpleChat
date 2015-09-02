//
//  SCChatMessage.h
//  SimpleChat
//
//  Created by Devi Eddy on 9/2/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCChatMessage : NSObject

@property (nonatomic, strong) NSString* created_at;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *msg;

@end
