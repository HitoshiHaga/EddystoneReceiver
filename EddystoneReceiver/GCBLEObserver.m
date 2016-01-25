//
//  GCBLEObserver.m
//  EddystoneReceiver
//
//  Created by HagaHitoshi on 2016/01/25.
//  Copyright © 2016年 GClue, inc. All rights reserved.
//

#import "GCBLEObserver.h"
#import "GCEddystoneData.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface GCBLEObserver ()<CBCentralManagerDelegate>

@end

@implementation GCBLEObserver {
    CBCentralManager* _centralManager;
}


dispatch_queue_t my_serial_queue() {
    static dispatch_queue_t serial_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serial_queue = dispatch_queue_create("com.gclue.gcbelobserver.central", DISPATCH_QUEUE_SERIAL);
    });
    
    return serial_queue;
}


-(id)init {
    self = [super init];
    
    
    
    return self;
}


#pragma mark - public


-(void)startObserving {
    NSDictionary* options = @{
                              CBCentralManagerOptionShowPowerAlertKey:@NO
                              };
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:my_serial_queue() options:options];
}

-(void)stopObserving {
    if(_centralManager) {
        [_centralManager stopScan];
        _centralManager = nil;
    }
}

#pragma mark - private

-(void)startScanning {
    [_centralManager scanForPeripheralsWithServices:nil
                                            options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
}

-(void)didReceiveAdvertisementData:(NSDictionary*)advertisementData rssi:(NSInteger)rssi {
    NSArray* serviceUUIDs = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    
    NSData* eddyStoneUIDData;
    
    if(serviceUUIDs) {
        for(CBUUID* serviceUUID in serviceUUIDs) {
            if([serviceUUID isEqual:[CBUUID UUIDWithString:@"FEAA"]]) {
                NSDictionary* allServiceData = [advertisementData objectForKey:CBAdvertisementDataServiceDataKey];
                eddyStoneUIDData = [allServiceData objectForKey:serviceUUID];
                break;
            }
        }

    }
    
    if(eddyStoneUIDData) {
        GCEddystoneData* data = [[GCEddystoneData alloc] initWithAdvertisementData:eddyStoneUIDData rssi:rssi];
        
        if(_delegate && [_delegate respondsToSelector:@selector(didReceiveEddystoneData:)]) {
            [_delegate didReceiveEddystoneData:data];
        }
    }
}

#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self startScanning];
            break;
        case CBCentralManagerStatePoweredOff:
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        default:
            break;
    }
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [self didReceiveAdvertisementData:advertisementData rssi:[RSSI integerValue]];
}

@end
