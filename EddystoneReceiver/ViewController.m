//
//  ViewController.m
//  EddystoneReceiver
//
//  Created by HagaHitoshi on 2016/01/25.
//  Copyright © 2016年 GClue, inc. All rights reserved.
//

#import "ViewController.h"
#import "GCBLEObserver.h"

@interface ViewController ()<GCBLEObserverDelegate>

@end

@implementation ViewController {
    GCBLEObserver* _observer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _observer = [GCBLEObserver new];
    [_observer setDelegate:self];
    
    [_observer startObserving];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - GCBLEObserverDelegate

-(void)didReceiveEddystoneData:(GCEddystoneData *)eddystone {
    NSLog(@"%@",eddystone.description);
}

@end
