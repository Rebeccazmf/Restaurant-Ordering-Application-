//
//  ItemTableViewController.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/9/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "ItemTableViewController.h"
#import "AddItemViewController.h"
#import "ViewItemViewController.h"
#import "Constants.h"
#import "MenuItemCell.h"

@interface ItemTableViewController ()<UITableViewDataSource>{
 FIRDatabaseHandle _refHandle;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *items;
@property (strong, nonatomic) FIRStorageReference *storageRef;

@end

@implementation ItemTableViewController

- (void)setMenuKey:(NSString *)menuKey {
    if (_menuKey != menuKey) {
        _menuKey = menuKey;

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _items = [[NSMutableArray alloc] init];
       // [self configureStorage];
      self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
   // [self.navigationController setToolbarHidden:NO animated:YES];
    //[self.navigationController reloadInputViews];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
   [_items removeAllObjects];
    [self.tableView reloadData];
    
    [self configureDatabase];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}

- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    if(_menuKey != nil){
    _refHandle = [[[[_ref child:@"menus"] child:_menuKey] child:@"items"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_items addObject:snapshot];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_items.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
       // [NSArray arrayWithObject:indexPath]

    }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem" forIndexPath:indexPath];
    
    FIRDataSnapshot *itemSnapshot = _items[indexPath.row];
    NSDictionary<NSString *, NSString *> *item = itemSnapshot.value;
    NSString *name = item[MessageFieldsname];
    NSString *price = item[MessageFieldsprice];
   // NSString *description =item[MessageFieldsdescription];
    cell.lblItemName.text = name;
    cell.lblItemPrice.text = [NSString stringWithFormat:@"$%@",price];
  //  cell.detailTextLabel.text = [NSString stringWithFormat:@"price: %@, description: %@",price, description];
    
    NSString *imageURL = item[MessageFieldsimageURL];
    if (imageURL) {
        if ([imageURL hasPrefix:@"gs://"]) {
            [[[FIRStorage storage] referenceForURL:imageURL] dataWithMaxSize:INT64_MAX
                                                                  completion:^(NSData *data, NSError *error) {
                                                                      if (error) {
                                                                          NSLog(@"Error downloading: %@", error);
                                                                          return;
                                                                      }
                                                                      cell.itemImageVIew.image =[UIImage imageWithData:data];
                                                                      //cell.imageView.image = [UIImage imageWithData:data];
                                                                                                                                        }];
        } else {
            cell.itemImageVIew.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            //cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        }
    }
    else{
        cell.itemImageVIew.image =  [UIImage imageNamed: @"foodIcon.png"];
    }
    return cell;
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
        NSString *itemKey = [[_items objectAtIndex:indexPath.row] key];
        [[[[[_ref child:@"menus"] child:_menuKey] child:@"items"] child:itemKey] removeValue];
        [_items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self performSegueWithIdentifier:@"showItem" sender:self];
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode  
        return UITableViewCellEditingStyleDelete;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //For select an item in table view
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *itemKey = [[_items objectAtIndex:indexPath.row] key];
        if ([segue.destinationViewController respondsToSelector:@selector(setItemKey:MenuKey:)]) {
                [segue.destinationViewController performSelector:@selector(setItemKey:MenuKey:) withObject:itemKey withObject: _menuKey];
                    }
        
    }
    //For add a new item
    if ([[segue identifier] isEqualToString:@"AddItem"]) {
        if(_menuKey == nil){
            
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please select a menu to add first!"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            
        }
        if([segue.destinationViewController respondsToSelector:@selector(setMenuKey:)]) {
            [segue.destinationViewController performSelector:@selector(setMenuKey:) withObject:_menuKey];
        }

    }
}


@end
