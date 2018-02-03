//
//  MasterViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/5/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "MasterViewController.h"
#import "Constants.h"
#import "ItemTableViewController.h"
#import "AddMenuViewController.h"

@interface MasterViewController ()<UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate>{
    FIRDatabaseHandle _refHandle;
}
//@property NSMutableArray *objects;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *menus;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *items;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ;
    self.title = @"Menu List";
    _menus = [[NSMutableArray alloc] init];
    [self configureDatabase];
    
    //[self configureRemoteConfig];
    //[self fetchConfig];
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
   
    
}

- (void)viewWillAppear:(BOOL)animated {
     [self.navigationController setToolbarHidden:NO animated:YES];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[_ref child:@"menus"] removeObserverWithHandle:_refHandle];
}

- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    _refHandle = [[_ref child:@"menus"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {        
        [_menus addObject:snapshot];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_menus.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *menuSnapshot = _menus[indexPath.row];
    NSDictionary<NSString *, NSString *> *menu = menuSnapshot.value;
    NSString *name = menu[MessageFieldsname];
    NSString *type =[NSString stringWithFormat:@"Type: %@", menu[MessageFieldstype]];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = type;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
        return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

        if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Delete Confirmation" message:@"Are you sure to delete?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"YES"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            // call method whatever u need
                                            NSString *menuKey = [[_menus objectAtIndex:indexPath.row] key];
                                            [[[_ref child:@"menus"] child:menuKey] removeValue];
                                            [_menus removeObjectAtIndex:indexPath.row];
                                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                            
                                            
                                            UIAlertController* successAlert = [UIAlertController alertControllerWithTitle:@"Delete Successfully!"
                                                                                                                  message:nil
                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                  handler:^(UIAlertAction * action) {
                                                                                                     [self performSegueWithIdentifier:@"showItem" sender:self];
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
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *menuKey = [[_menus objectAtIndex:indexPath.row] key];
    if ([[segue identifier] isEqualToString:@"Add"])
   {      
//        AddMenuViewController *controller = (AddMenuViewController *)[[segue destinationViewController] topViewController];      
//        [controller setMenuKey:menuKey];
       if([segue.destinationViewController respondsToSelector:@selector(setMenuKey:)]) {
           [segue.destinationViewController performSelector:@selector(setMenuKey:) withObject:menuKey];
       }
    }
    if ([[segue identifier] isEqualToString:@"showItem"]) {
        ItemTableViewController *controller = (ItemTableViewController *)[[segue destinationViewController] topViewController];
        [controller setMenuKey:menuKey];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}




- (IBAction)btnEditClicked:(id)sender {
    if ([self.toolbarbutton.title isEqualToString:@"Edit"])
    {
        [self.tableView setEditing:YES animated:YES];
        self.toolbarbutton.title = @"Done";

    }
    else
    {
        [self.tableView setEditing:NO animated:YES];
        self.toolbarbutton.title = @"Edit";
    }
}

- (IBAction)btnHomeClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    
}

//- (IBAction)btnAddClicked:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AddMenuViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Add"];
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//    
//
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
//    popController.delegate = self;
//    popController.sourceView = self.view;
//    popController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 300, 300);
//    popController.permittedArrowDirections = 0;
//    
//
//      //[self.splitViewController performSegueWithIdentifier:@"Add" sender:self];
//}
@end
