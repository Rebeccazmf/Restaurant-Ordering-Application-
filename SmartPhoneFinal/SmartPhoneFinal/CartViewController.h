//
//  CartViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Order.h"
#import "GuestItemCell.h"
@import Firebase;
@interface CartViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *tableID;
@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) NSMutableArray *orderItems;
@property double totalPrice;
- (void)setOrder:(Order *)order;

@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;

@property (strong, nonatomic) IBOutlet UITextField *txtTableID;
@property (strong, nonatomic) IBOutlet UITextView *txtRemarks;

@property (strong, nonatomic) IBOutlet UITableView *orderTableView;
- (IBAction)btnPlaceOrderClicked:(id)sender;

@end
