//
//  ChefMasterViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "ChefMasterViewController.h"

@interface ChefMasterViewController ()
{
     FIRDatabaseHandle _refHandle;
}
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *orders;
@property (strong, nonatomic) FIRDatabaseReference *ref;
//@property long count;
@end

@implementation ChefMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // _count = 0;
    _orders = [[NSMutableArray alloc] init];
    [self configureDatabase];
      // [self updateTableContentInset];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
  
    // [self.navigationController setToolbarHidden:NO animated:YES];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
     // [self.tableView reloadData];
    
}
- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    _refHandle = [[_ref child:@"orders"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_orders addObject:snapshot];
     //   _count = [_orders count];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_orders.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_orders count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    //NSArray *os = _orders.reverseObjectEnumerator.allObjects;

    FIRDataSnapshot *orderSnapshot = _orders[indexPath.row];
    //NSDictionary<NSString *, NSString *> *order = orderSnapshot.value;
    NSString *orderKey = orderSnapshot.key;
   // long i = OrderKey - [orderKey intValue];
    NSString *showKey = [NSString stringWithFormat:@"%lld",10000 - [[[orderKey substringFromIndex:3] substringToIndex:4] longLongValue]];
   // NSString *showKey = [[NSNumber numberWithLong:1e+13 - [orderKey longLongValue]] stringValue];
      // long c =[_orders count] ;
      // NSString *showKey = [NSString stringWithFormat:@"%ld", c];
    //NSString *tableID = order[MessageFieldsname];
   // NSString *type = menu[MessageFieldstype];
    cell.textLabel.text = [NSString stringWithFormat:@"NO. %@", showKey];
    return cell;
}

- (void)updateTableContentInset {
    NSInteger numRows = [self tableView:self.tableView numberOfRowsInSection:0];
    CGFloat contentInsetTop = self.tableView.bounds.size.height;
    for (NSInteger i = 0; i < numRows; i++) {
        contentInsetTop -= [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (contentInsetTop <= 0) {
            contentInsetTop = 0;
            break;
        }
    }
    self.tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *orderKey = [[_orders objectAtIndex:indexPath.row] key];
       
        [_orders removeObjectAtIndex:indexPath.row];
        [[[_ref child:@"orders"] child:orderKey] removeValue];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if([_orders count] != 0){
            [self performSegueWithIdentifier:@"showOrder" sender:self];
        }
        else{
            [tableView reloadData];
            [self performSegueWithIdentifier:@"empty" sender:self];
        }
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *orderKey = [[_orders objectAtIndex:indexPath.row] key];
    ChefDetailViewController *controller = (ChefDetailViewController *)[[segue destinationViewController] topViewController];
    if ([[segue identifier] isEqualToString:@"showOrder"]) {
        //ChefDetailViewController *controller = (ChefDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setOrderKey:orderKey];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    else{
        [controller setOrderKey:nil];
        }
    
}


- (IBAction)btnDeleteAllClicked:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Delete Confirm" message:@"Do you want to delete all  order records?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    // call method whatever u need
                                    [[_ref child:@"orders"] removeValue];
                                    [_orders removeAllObjects];
                                    [self.tableView reloadData];
//                                    ChefDetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];

//                                    UISplitViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"chef"];
//                                    [vc reloadInputViews];
                                    //[self presentViewController:vc animated:YES completion:nil];
                                   // [self performSegueWithIdentifier:@"empty" sender:self];
                                     NSLog(@"you pressed Yes, please button");
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   // call method whatever u need
                                   NSLog(@"you pressed No button");
                                   return;
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
   }

- (IBAction)btnHomeClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
