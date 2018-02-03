//
//  GuestMasterViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GuestItemViewController.h"
@import Firebase;
@interface GuestMasterViewController : UITableViewController
- (IBAction)btnHomeClicked:(id)sender;
@property (strong, nonatomic) Order *order;
- (void)setOrder:(Order *)order;
@end
