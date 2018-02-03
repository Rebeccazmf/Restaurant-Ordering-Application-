//
//  ViewItemViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/12/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "ViewItemViewController.h"
#import "Constants.h"
@interface ViewItemViewController (){
    FIRDatabaseHandle _refHandle;
}
@property (strong, nonatomic) FIRDataSnapshot *item;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@end

@implementation ViewItemViewController
- (void)setItemKey:(NSString *)itemKey MenuKey:(NSString *)menuKey {
    if (_itemKey != itemKey) {
        _itemKey = itemKey;
    }
    if (_menuKey != menuKey) {
        _menuKey = menuKey;
    }
}

- (IBAction)btnDeleteClicked:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Delete Confirmation" message:@"Are you sure to delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    // call method whatever u need
                                    [[[[[_ref child:@"menus"] child:_menuKey] child:@"items"] child:_itemKey] removeValue];
                                    

                                    UIAlertController* successAlert = [UIAlertController alertControllerWithTitle:@"Delete Successfully!"
                                                                                                   message:nil
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction * action) {
                                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                                            }];
                                    
                                    [successAlert addAction:defaultAction];
                                    [self presentViewController:successAlert animated:YES completion:nil];
                                    return;
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   // call method whatever u need
                                   NSLog(@"you pressed No, thanks button");
                                   return;
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _txtViewItemName.enabled = NO;
    _txtViewItemPrice.enabled = NO;
    _txtViewDescription.editable = NO;
    [self configureDatabase];
    [self configureStorage];
    if(_itemKey != nil){
        [[[[[_ref child:@"menus"] child:_menuKey] child:@"items"] child:_itemKey] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            _txtViewItemName.text = snapshot.value[MessageFieldsname];
            _txtViewItemPrice.text = snapshot.value[MessageFieldsprice];
            _txtViewDescription.text = snapshot.value[MessageFieldsdescription];
            NSString *imageURL = snapshot.value[MessageFieldsimageURL];
            if (imageURL) {
                if ([imageURL hasPrefix:@"gs://"]) {
                    [[[FIRStorage storage] referenceForURL:imageURL] dataWithMaxSize:INT64_MAX
                                                                          completion:^(NSData *data, NSError *error) {
                                                                              if (error) {
                                                                                  NSLog(@"Error downloading: %@", error);
                                                                                  return;
                                                                              }
                                                                              self.detailImageView.image = [UIImage imageWithData:data];
                                                                            
                                                                          }];
                }
            }//end if of imageURL
            else {
                self.detailImageView.image = [UIImage imageNamed:@"noimage_holder.jpg"];
            }
        }];
        
    }
}
- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
}
- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
