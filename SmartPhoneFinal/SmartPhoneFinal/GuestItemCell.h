//
//  GuestItemCell.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/26/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *guestImageIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblGuestItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblGuestItemPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblGuestDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblViewItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblViewDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblViewPrice;

@end
