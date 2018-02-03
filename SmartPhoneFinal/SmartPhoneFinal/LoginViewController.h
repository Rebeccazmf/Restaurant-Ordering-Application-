//
//  LoginViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/19/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface LoginViewController : UIViewController
- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtUserame;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property(strong, nonatomic) NSString *tempPass;
@property(strong,nonatomic) NSString *tempUsername;
@end
