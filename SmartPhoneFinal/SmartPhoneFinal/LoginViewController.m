//
//  LoginViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/19/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
        FIRDatabaseHandle _refHandle;
}
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self configureDatabase];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    [[_ref child:@"password"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        _tempPass = snapshot.value;

    }];
    [[_ref child:@"username"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        _tempUsername = snapshot.value;
            }];
   }


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


- (IBAction)btnLoginClicked:(id)sender {
    NSLog(@"%@", _txtPassword.text);
    if( [_txtUserame.text isEqualToString:_tempUsername] && [_txtPassword.text isEqualToString:_tempPass]){
        
        [self performSegueWithIdentifier:@"adminView" sender:self];
        
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Invalid username or password!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
   
}
- (IBAction)btnCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
