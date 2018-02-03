//
//  Orders.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"
@interface Order : NSObject
@property NSMutableArray<OrderItem *> *orderItems;
-(id)addNewItem:(OrderItem *)newItem;
@end
