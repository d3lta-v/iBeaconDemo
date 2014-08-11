//
//  ViewController.m
//  iBeaconDemo
//
//  Created by Pan Ziyue on 10/8/14.
//  Copyright (c) 2014 StatiX Industries. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL bluetoothEnabled;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Check if bluetooth is on or off
    [self startBluetoothStatusMonitoring];
    
    // Initialize the location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"Estimote Region"];
    
    // Start monitoring
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    
    if (!bluetoothEnabled) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Bluetooth is off" message:@"Please turn on your Bluetooth to use this app." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.myBeaconRegion];
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
            
            break;
        case CLRegionStateOutside:
            NSLog(@"outside");
        case CLRegionStateUnknown:
        default:
            // stop ranging beacons, etc
            NSLog(@"Region unknown");
    }
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] > 0) {
        // Detect amount of beacons in range
        if ([beacons count]==1)
            self.statusLabel.text = @"Beacon is in range";
        else if ([beacons count]==2)
            self.statusLabel.text = @"2 beacons are in range";
        else if ([beacons count]==3)
            self.statusLabel.text = @"3 beacons are in range";
        else if ([beacons count]==4)
            self.statusLabel.text = @"4 beacons are in range";
        else
            self.statusLabel.text = @"Several beacons are in range";
        
        // Get the nearest found beacon
        beacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity != %d", CLProximityUnknown]];
        beacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity != %d", -1]];
        if (beacons.count==0) {
            self.statusLabel.text = @"No beacons in range";
            self.uuidLabel.text = @"NULL";
            self.majorLabel.text = @"NULL";
            self.minorLabel.text = @"NULL";
            self.inferredLocationLabel.text = @"NULL";
            self.proximityLabel.text = @"Bad signal";
        } else {
            CLBeacon *foundBeacon = [beacons firstObject];
            
            NSString *uuid = foundBeacon.proximityUUID.UUIDString;
            NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
            NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
            
            self.uuidLabel.text = uuid;
            self.majorLabel.text = major;
            self.minorLabel.text = minor;
            switch (foundBeacon.proximity) {
                case 1:
                    self.proximityLabel.text = @"Immediate";
                    break;
                case 2:
                    self.proximityLabel.text = @"Near";
                    break;
                case 3:
                    self.proximityLabel.text = @"Far";
                    break;
                default:
                    self.proximityLabel.text = @"Unknown";
                    break;
            }
            if ([major isEqual:@"5114"] && [minor isEqual:@"20025"])
                self.inferredLocationLabel.text = @"Icy Marshmallow";
            else if ([major isEqual:@"57973"] && [minor isEqual:@"10283"])
                self.inferredLocationLabel.text = @"Blueberry Pie";
        }
    } else {
        self.statusLabel.text = @"No beacons in range";
        self.uuidLabel.text = @"NULL";
        self.majorLabel.text = @"NULL";
        self.minorLabel.text = @"NULL";
        self.inferredLocationLabel.text = @"NULL";
        self.proximityLabel.text = @"No signal";
    }
}

- (void)startBluetoothStatusMonitoring {
    // Horrible formatting, but nicer for blog-width!
    self.bluetoothManager = [[CBCentralManager alloc]
                             initWithDelegate:self
                             queue:dispatch_get_main_queue()
                             options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        bluetoothEnabled = YES;
    }
    else {
        bluetoothEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
