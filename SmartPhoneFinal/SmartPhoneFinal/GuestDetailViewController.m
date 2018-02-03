//
//  GuestDetailViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "GuestDetailViewController.h"

@interface GuestDetailViewController ()
@property (strong, nonatomic) FIRDataSnapshot *item;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation GuestDetailViewController
- (void)setOrder:(Order *)order {
    if (_order != order) {
        _order = order;
    }
}
- (void)setItemKey:(NSString *)itemKey MenuKey:(NSString *)menuKey {
    if (_itemKey != itemKey) {
        _itemKey = itemKey;
    }
    if (_menuKey != menuKey) {
        _menuKey = menuKey;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDatabase];
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    [self.navigationController setToolbarHidden:NO animated:YES];
    if(_itemKey != nil){
        [[[[[_ref child:@"menus"] child:_menuKey] child:@"items"] child:_itemKey] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            
            _lblItemName.text = snapshot.value[MessageFieldsname];
            _lblItemPrice.text = snapshot.value[MessageFieldsprice];
            _lblDescription.text = snapshot.value[MessageFieldsdescription];
             self.title = _lblItemName.text;
            
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
            }
            else{
                self.detailImageView.image = [UIImage imageNamed:@"food-background-unavailable.jpg"];
            }
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated {
   // self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    NSInteger i = [_order.orderItems count];
    if (i == 0)
    {
        self.navigationItem.rightBarButtonItem.title = @"Cart";
    }
    else
    {
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Cart(%ld)",(long)i ];
    }

}
- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewCart"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setOrder:)]) {
            [segue.destinationViewController performSelector:@selector(setOrder:) withObject:_order];       
        }
    }
}


- (IBAction)btnAddToCartClicked:(id)sender {
     NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if([[[_lblItemName text] stringByTrimmingCharactersInSet: set] length] == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"You have to select an item!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
   
    }else{
        OrderItem *newItem = [[OrderItem alloc] initWithItemName:_lblItemName.text itemPrice:_lblItemPrice.text itemDescription:_lblDescription.text];
        [_order addNewItem:newItem];
        UIAlertController* successAlert = [UIAlertController alertControllerWithTitle:@"Add to Cart Successfully!"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* successAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        
        [successAlert addAction:successAction];
        [self presentViewController:successAlert animated:YES completion:nil];
        _lblItemName.text = @"";
        _lblItemPrice.text = @"";
        _lblDescription.text = @"";
        _detailImageView.image = nil;
        self.title = @"";
        NSInteger i = [_order.orderItems count];
        if (i == 0)
        {
            self.navigationItem.rightBarButtonItem.title = @"Cart";
        }
        else
        {
            self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Cart(%ld)",(long)i ];
        }
        return;
    }
}

@end
