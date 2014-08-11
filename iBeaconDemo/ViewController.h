//
//  ViewController.h
//  iBeaconDemo
//
//  Created by Pan Ziyue on 10/8/14.
//  Copyright (c) 2014 StatiX Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (weak, nonatomic) IBOutlet UILabel* statusLabel;
@property (weak, nonatomic) IBOutlet UILabel* uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel* majorLabel;
@property (weak, nonatomic) IBOutlet UILabel* minorLabel;
@property (weak, nonatomic) IBOutlet UILabel* inferredLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel* proximityLabel;

@end

