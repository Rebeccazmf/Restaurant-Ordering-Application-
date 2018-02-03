//
//  ItemTableViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/9/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface ItemTableViewController : UITableViewController
@property (strong, nonatomic) NSString *menuKey;
- (void)setMenuKey:(NSString *)menuKey;
@end
