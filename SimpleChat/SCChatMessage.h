//
//  SCChatMessage.h
//  SimpleChat
//
//  Created by Devi Eddy on 8/31/15.
//  Copyright (c) 2015 Devi Eddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCChatMessage : NSObject

@property (nonatomic, strong) NSString* messageId;
@property (nonatomic, strong) NSArray* recipientIds;
@property (nonatomic, strong) NSString* senderId;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic, strong) NSDictionary* headers;

@end
