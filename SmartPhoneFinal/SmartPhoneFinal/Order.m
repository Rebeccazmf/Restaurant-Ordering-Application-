//
//  Orders.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "Order.h"

@implementation Order
-(id)init;
{
    self = [super init];
    if (self) {
        _orderItems = [NSMutableArray array];
    }
    return self;
}


-(id)addNewItem:(OrderItem *)newItem;
{
    
    [_orderItems addObject:newItem];
    return newItem;
}
@end
