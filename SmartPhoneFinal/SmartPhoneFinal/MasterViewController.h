//
//  MasterViewController.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/5/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@import Firebase;
@interface MasterViewController : UITableViewController<UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) ViewController *vc;
- (IBAction)btnEditClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toolbarbutton;
- (IBAction)btnHomeClicked:(id)sender;

//- (IBAction)btnAddClicked:(id)sender;
@end
