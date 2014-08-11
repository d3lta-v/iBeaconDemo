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
    NSInteger *firstProximity;
    
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"Estimote Region"];
    
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
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
        // Handle your found beacons here
        if ([beacons count] > 1) {
            self.statusLabel.text = @"2 or more beacons are in range";
        } else {
            self.statusLabel.text = @"Beacons are in range";
        }
        
        // Get the nearest found beacon
        beacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity != %d", CLProximityUnknown]];
        beacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity != %d", -1]];
        if (beacons.count==0) {
            self.statusLabel.text = @"No beacons in range";
            self.uuidLabel.text = @"NULL";
            self.majorLabel.text = @"NULL";
            self.minorLabel.text = @"NULL";
            self.proximityLabel.text = @"Unknown";
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
        self.proximityLabel.text = @"Out of range";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
