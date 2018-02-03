//
//  AddItemViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/11/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) FIRStorageMetadata *imagedata;
@property (strong, nonatomic) NSString *path;
@end

@implementation AddItemViewController
- (void)setMenuKey:(NSString *)menuKey {
    if (_menuKey != menuKey) {
        _menuKey = menuKey;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDatabase];
    [self configureStorage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSaveItemClicked:(id)sender {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[[_txtItemName text] stringByTrimmingCharactersInSet: set] length] == 0 ||
        [[[_txtItemPrice text] stringByTrimmingCharactersInSet: set] length] == 0 ||
        [[[_txtItemDescription text] stringByTrimmingCharactersInSet: set] length] == 0
        ){
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Every field is required!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    BOOL isNumber = [nf numberFromString:_txtItemPrice.text] != nil;
    if(!isNumber){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Please input a valid number!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSMutableDictionary *mdata = [[NSMutableDictionary alloc]init];
    mdata[MessageFieldsname] = _txtItemName.text;
    mdata[MessageFieldsprice] = _txtItemPrice.text;
    mdata[MessageFieldsdescription] = _txtItemDescription.text;
    mdata[MessageFieldsimageURL] = _path;
    // Push data to Firebase Database
    [[[[[_ref child:@"menus"] child:_menuKey] child:@"items"] childByAutoId] setValue:mdata];
    UIAlertController* successAlert = [UIAlertController alertControllerWithTitle:@"Save Successfully!"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* successAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              _txtItemName.text = @"";
                                                              _txtItemPrice.text = @"";
                                                              _txtItemDescription.text = @"";
                                                              _itemImageView.image =  [UIImage imageNamed: @"image_holder.jpg"];}];
    
    [successAlert addAction:successAction];
    [self presentViewController:successAlert animated:YES completion:nil];
    return;

}

- (IBAction)addPictureClicked:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   // }
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSURL *referenceURL = info[UIImagePickerControllerReferenceURL];
    self.itemImageView.image = info[UIImagePickerControllerEditedImage];
    // if it's a photo from the library, not an image from the camera
    if (referenceURL) {
        PHFetchResult* assets = [PHAsset fetchAssetsWithALAssetURLs:@[referenceURL] options:nil];
        PHAsset *asset = assets.firstObject;
        [asset requestContentEditingInputWithOptions:nil
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageFile = contentEditingInput.fullSizeImageURL;
                                       NSString *filePath = [NSString stringWithFormat:@"%lld/%@",(long long)([NSDate date].timeIntervalSince1970 * 1000.0),referenceURL.lastPathComponent];
                                       [[_storageRef child:filePath] putFile:imageFile metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                            if (error) {
                                                NSLog(@"Error uploading: %@", error);
                                                return;
                                            }
                                           _path = [_storageRef child:metadata.path].description;
                                        }
                                        ];
                                   }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
