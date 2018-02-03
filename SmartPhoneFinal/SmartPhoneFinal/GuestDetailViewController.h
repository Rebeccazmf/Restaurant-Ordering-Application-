//
//  GuestDetailViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Order.h"
#import "CartViewController.h"
@import Firebase;
@interface GuestDetailViewController : UIViewController
- (void)setItemKey:(NSString *)itemKey MenuKey:(NSString *)menuKey;
@property (strong, nonatomic) NSString *itemKey;
@property (strong, nonatomic) NSString *menuKey;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;

@property (strong, nonatomic) IBOutlet UILabel *lblItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblItemPrice;

@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
- (IBAction)btnAddToCartClicked:(id)sender;
@property (strong, nonatomic) Order *order;
@end
