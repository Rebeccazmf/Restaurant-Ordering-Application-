//
//  ChefDetailViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@import Firebase;
@interface ChefDetailViewController : UIViewController
@property (strong, nonatomic) NSString *orderKey;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (void)setOrderKey:(NSString *)orderKey;
@property (strong, nonatomic) IBOutlet UILabel *lblRemarks;
@end
