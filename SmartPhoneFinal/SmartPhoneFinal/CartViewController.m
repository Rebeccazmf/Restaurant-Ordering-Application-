//
//  CartViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()
@property (strong, nonatomic) FIRDataSnapshot *item;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation CartViewController
- (void)setOrder:(Order *)order {
    if (_order != order) {
        _order = order;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

   // [newBackButton release];
    //self.navigationController.navigationBar.topItem.title = @"Back";
    for(id item in _order.orderItems){
        _totalPrice += [[item orderItemPrice] doubleValue];
    }
    _lblTotalPrice.text = [NSString stringWithFormat:@"$%0.2f", _totalPrice];

    [self.view bringSubviewToFront:self.orderTableView];
    [self configureDatabase];
     [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
   // self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_order.orderItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    
    GuestItemCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:
//                UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//    }
    id item = [_order.orderItems objectAtIndex:indexPath.row];
    cell.lblViewItemName.text = [item orderItemName];
    cell.lblViewDescription.text = [item orderItemDescription];
    cell.lblViewPrice.text = [NSString stringWithFormat:@"$%@",[item orderItemPrice]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id item = [_order.orderItems objectAtIndex:indexPath.row];
         [_order.orderItems removeObjectAtIndex:indexPath.row];
        _totalPrice -= [[item orderItemPrice] doubleValue];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       }

    _lblTotalPrice.text = [NSString stringWithFormat:@"$%0.2f", _totalPrice];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPlaceOrderClicked:(id)sender {
    NSMutableDictionary *newItems = [[NSMutableDictionary alloc]init];
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];

    if([[[_txtTableID text] stringByTrimmingCharactersInSet: set] length] == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"You have to input a table ID!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    else{
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Order Confirm" message:@"Do you want to place order?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"YES"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        // call method whatever u need
                                       // NSString *orderKey = [[NSNumber numberWithLong:OrderKey--] stringValue];
                                        //NSString *orderKey = [NSString stringWithFormat:@"%f", 1e+13-(float)([NSDate date].timeIntervalSince1970 * 1000.0)];
                                        NSString *orderKey = [[[NSNumber numberWithLong:1e+13 - (long long)([NSDate date].timeIntervalSince1970 * 1000.0)] stringValue] substringFromIndex:2];
                                       // NSString *code = [sec substringFromIndex: [sec length] - 3];
                                       // NSString *orderKey = [NSString stringWithFormat:@"%@%@",code, _txtTableID.text];
                                        [[[[_ref child:@"orders"] child:orderKey] child:@"tableID"] setValue:_txtTableID.text];
                                        [[[[_ref child:@"orders"] child:orderKey] child:@"remarks"] setValue:_txtRemarks.text];
                                        for(id item in _order.orderItems){
                                            newItems[MessageFieldsname] = [item orderItemName];
                                            newItems[MessageFieldsdescription] = [item orderItemDescription];
                                            [[[[[_ref child:@"orders"] child:orderKey] child:@"items"] childByAutoId] setValue:newItems];
                                        }
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                        NSLog(@"you pressed Yes, please button");
                                        
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       // call method whatever u need
                                       NSLog(@"you pressed No, thanks button");
                                       return;
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        }
    
    
}
@end
