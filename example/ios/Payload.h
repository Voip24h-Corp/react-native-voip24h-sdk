//
//  Payload.h
//  example
//
//  Created by Phát Nguyễn on 30/11/2023.
//

#ifndef Payload_h
#define Payload_h

#import <PushKit/PushKit.h>

@interface PushPayload : PKPushPayload

@property (copy) NSDictionary *customDictionaryPayload;

@end

#endif /* Payload_h */
