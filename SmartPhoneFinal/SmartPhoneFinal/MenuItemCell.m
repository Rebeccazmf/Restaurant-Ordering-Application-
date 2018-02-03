//
//  MenuItemCell.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/20/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   // FIRDatabaseHandle _refHandle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)configureDatabase {
//    _ref = [[FIRDatabase database] reference];
//    // Listen for new messages in the Firebase database
//    if(_menuKey != nil){
//        _refHandle = [[[[_ref child:@"menus"] child:_menuKey] child:@"items"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//            [_items addObject:snapshot];
//            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_items.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
//            // [NSArray arrayWithObject:indexPath]
//            
//        }];
//    }
//}
@end
