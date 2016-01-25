//
//  GCEddystoneData.m
//  EddystoneReceiver
//
//  Created by HagaHitoshi on 2016/01/25.
//  Copyright © 2016年 GClue, inc. All rights reserved.
//

#import "GCEddystoneData.h"

typedef struct __attribute__((packed)) {
    u_int8_t frameType;
    u_int8_t txPower;
    u_int8_t nid[10];
    u_int8_t bid[6];
    u_int8_t rfu[2];
}EddystonePacketStructure;

@implementation GCEddystoneData

#pragma mark - public

-(id)initWithAdvertisementData:(NSData*)data rssi:(NSInteger)rssi {
    self = [super init];
    if(!self) {
        return nil;
    }
    
    EddystonePacketStructure packetFields;
    
    [data getBytes:&packetFields
            length:sizeof(EddystonePacketStructure)];
    
    NSString* nid = [self idStringFromData:[NSData dataWithBytes:packetFields.nid length:sizeof(packetFields.nid)] isLittleEndian:NO];
    NSString* bid = [self idStringFromData:[NSData dataWithBytes:packetFields.bid length:sizeof(packetFields.bid)] isLittleEndian:NO];
    
    self.frameType = packetFields.frameType;
    self.txPower = packetFields.txPower;
    self.nid = nid;
    self.bid = bid;
    self.rssi = rssi;
    
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"nid: %@, bid: %@, rssi: %d", self.nid,self.bid,(int)self.rssi];
}

#pragma mark - private

-(NSString*)idStringFromData:(NSData*)data isLittleEndian:(BOOL)isLittleEndian{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength = [data length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    if(!isLittleEndian) {
        for (int i = 0; i < dataLength; ++i) {
            [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
        }
    }else {
        for (int i = (int)(dataLength-1); i >= 0; --i) {
            [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
        }
    }
    return [NSString stringWithString:hexString];
}

@end
