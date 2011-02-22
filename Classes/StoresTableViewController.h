//
//  StoreTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealfireTableViewController.h"

@class StoreTableViewController;

@interface StoresTableViewController : MealfireTableViewController {
	NSArray *stores;
	StoreTableViewController *storeController;
}

@property (nonatomic, retain) NSArray *stores;
@property (nonatomic, retain) StoreTableViewController *storeController;

@end
