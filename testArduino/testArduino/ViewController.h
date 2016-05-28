//
//  ViewController.h
//  testArduino
//
//  Created by Rafael Baraldi on 22/05/16.
//  Copyright © 2016 Rafael BAraldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate>

@property NSMutableArray* lista;

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property CBPeripheral* peripheral;

@property CBCharacteristic* characteristc;

- (IBAction)offclick:(id)sender;

- (IBAction)onclick:(id)sender;

@property CBCentralManager* centrallManager;
@property CBPeripheralManager* deviceManager;

@end

