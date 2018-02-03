//
//  GuestItemViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GuestItemCell.h"
#import "GuestDetailViewController.h"
@import Firebase;
@interface GuestItemViewController : UITableViewController
@property (strong, nonatomic) NSString *menuKey;
- (void)setMenuKey:(NSString *)menuKey;
@property (strong, nonatomic) Order *order;
- (void)setOrder:(Order *)order;
@end
