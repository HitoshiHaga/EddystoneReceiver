//
//  GCEddystoneData.h
//  EddystoneReceiver
//
//  Created by HagaHitoshi on 2016/01/25.
//  Copyright © 2016年 GClue, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCEddystoneData : NSObject

@property (nonatomic, strong) NSString* nid;
@property (nonatomic, strong) NSString* bid;
@property (nonatomic) NSInteger txPower;
@property (nonatomic) NSInteger frameType;
@property (nonatomic) NSInteger rssi;

-(id)initWithAdvertisementData:(NSData*)data rssi:(NSInteger)rssi;
@end
