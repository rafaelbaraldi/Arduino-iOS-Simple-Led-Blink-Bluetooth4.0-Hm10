//
//  ViewController.m
//  testArduino
//
//  Created by Rafael Baraldi on 22/05/16.
//  Copyright © 2016 Rafael BAraldi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _lista = [NSMutableArray new];
    
    _centrallManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _deviceManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[advertisementData description]]);
    
    NSLog(@"%@",[NSString stringWithFormat:@"Discover:%@,RSSI:%@\n",[advertisementData objectForKey:@"kCBAdvDataLocalName"],RSSI]);
    NSLog(@"Discovered %@", peripheral.name);
    
    [_lista addObject:peripheral];
    
//    [mgr  connectPeripheral:peripheral options:nil];
    
    [_table reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CBPeripheral* bt = [_lista objectAtIndex:indexPath.row];
    
    [_centrallManager connectPeripheral:[_lista objectAtIndex:indexPath.row] options:nil];
    
    _peripheral = bt;
    
//    [bt writeValue:[@"A" dataUsingEncoding:NSUTF8StringEncoding] forDescriptor:ni]
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"%@", peripheral.services);
    
    for (CBService* service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@", service.characteristics);
    for (int i = 0; i < service.characteristics.count; i++) {
        _characteristc = [service.characteristics objectAtIndex:i];
        [peripheral setNotifyValue:YES forCharacteristic:_characteristc];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error reading characteristics: %@", [error localizedDescription]);
        return;
    }
    
    if (characteristic.value != nil) {
        //value here.
        NSLog(@"%@", [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
        
        _lbl.text = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSString* connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", connected);
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"%ld", (long)peripheral.state);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *messtoshow;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            messtoshow=[NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        }
        case CBCentralManagerStateResetting:
        {
            messtoshow=[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            messtoshow=[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            messtoshow=[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            NSLog(@"%@",messtoshow);
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            
            [_centrallManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey :@NO}];
            
            NSLog(@"%@",messtoshow);
            break;
            
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [UITableViewCell new];
    
    cell.textLabel.text = ((CBPeripheral*)[_lista objectAtIndex:indexPath.row]).name;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lista.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)offclick:(id)sender {
    [_peripheral writeValue:[@"B" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristc type:CBCharacteristicWriteWithoutResponse];
}

- (IBAction)onclick:(id)sender {
    [_peripheral writeValue:[@"A" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristc type:CBCharacteristicWriteWithoutResponse];
}
@end
