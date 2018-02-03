//
//  MenuItemCell.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/20/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface MenuItemCell : UITableViewCell 
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageVIew;
@property (strong, nonatomic) IBOutlet UILabel *lblItemName;

@property (strong, nonatomic) IBOutlet UILabel *lblItemPrice;
@end
