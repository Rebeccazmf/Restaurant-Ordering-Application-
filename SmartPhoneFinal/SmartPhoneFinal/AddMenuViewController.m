//
//  AddMenuViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/9/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "AddMenuViewController.h"
#import "ItemTableViewController.h"
#import "Constants.h"

@interface AddMenuViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation AddMenuViewController
- (void)setMenuKey:(NSString *)menuKey {
    if (_menuKey != menuKey) {
        _menuKey = menuKey;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDatabase];
    _pickerData = @[@"Breakfast",@"Brunch", @"Lunch", @"Dinner", @"Dessert", @"Drinks", @"Speciality"];
    self.menuTypePicker.dataSource = self;
    self.menuTypePicker.delegate = self;
    //popover
//    ItemTableViewController* myViewController = [[ItemTableViewController alloc] init];
//    CGSize viewSize = myViewController.view.frame.size;
//   // CGFloat wid = viewSize.width - self.splitViewController.maximumPrimaryColumnWidth;
//   // self.preferredContentSize = viewSize;
//    self.preferredContentSize = CGSizeMake(viewSize.width/2, viewSize.height/2);
//    self.modalInPopover = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _resType = _pickerData[row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}

- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
}
//
- (IBAction)btnCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)btnSaveClicked:(id)sender {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[[_txtMenuName text] stringByTrimmingCharactersInSet: set] length] == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Please input a menu name!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if(_resType == nil){
        _resType = @"Breakfast";
    }
    NSMutableDictionary *mdata = [[NSMutableDictionary alloc]init];
    mdata[MessageFieldsname] = _txtMenuName.text;
    mdata[MessageFieldstype] = _resType;
    // Push data to Firebase Database
    [[[_ref child:@"menus"] childByAutoId] setValue:mdata];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
