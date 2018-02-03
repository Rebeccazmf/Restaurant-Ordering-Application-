//
//  ViewItemViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/12/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface ViewItemViewController : UIViewController
- (void)setItemKey:(NSString *)itemKey MenuKey:(NSString *)menuKey;
- (IBAction)btnDeleteClicked:(id)sender;

@property (strong, nonatomic) NSString *itemKey;
@property (strong, nonatomic) NSString *menuKey;
@property (strong, nonatomic) IBOutlet UITextField *txtViewItemName;
@property (strong, nonatomic) IBOutlet UITextField *txtViewItemPrice;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;

@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@end
