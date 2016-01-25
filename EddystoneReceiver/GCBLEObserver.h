//
//  GCBLEObserver.h
//  EddystoneReceiver
//
//  Created by HagaHitoshi on 2016/01/25.
//  Copyright © 2016年 GClue, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCEddystoneData.h"
@class GCBLEObserver;

@protocol GCBLEObserverDelegate <NSObject>
@optional
-(void)didReceiveEddystoneData:(GCEddystoneData*)eddystone;

@end

@interface GCBLEObserver : NSObject

@property (nonatomic, weak) id<GCBLEObserverDelegate> delegate;

-(void)startObserving;
-(void)stopObserving;

@end
