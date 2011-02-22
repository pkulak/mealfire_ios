//
//  StoreTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealfireTableViewController.h"

@interface StoreTableViewController : MealfireTableViewController {
	NSMutableArray *categories;
	NSDecimalNumber	*storeID;
}

@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSDecimalNumber *storeID;

@end
