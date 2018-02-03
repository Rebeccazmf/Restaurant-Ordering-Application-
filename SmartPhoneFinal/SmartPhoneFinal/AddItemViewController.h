//
//  AddItemViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/11/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@import Firebase;
@import Photos;
@interface AddItemViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)btnSaveItemClicked:(id)sender;
- (IBAction)addPictureClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtItemName;
@property (strong, nonatomic) IBOutlet UITextField *txtItemPrice;
@property (strong, nonatomic) IBOutlet UITextView *txtItemDescription;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) NSString *menuKey;
- (void)setMenuKey:(NSString *)menuKey;
@end
