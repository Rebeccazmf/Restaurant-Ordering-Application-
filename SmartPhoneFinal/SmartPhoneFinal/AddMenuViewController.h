//
//  AddMenuViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/9/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface AddMenuViewController : UIViewController<UIPopoverPresentationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) NSString *menuKey;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *resType;

- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtMenuName;
@property (strong, nonatomic) IBOutlet UIPickerView *menuTypePicker;

- (void)setMenuKey:(NSString *)menuKey;
@end
