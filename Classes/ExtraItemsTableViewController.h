//
//  ExtraItemsTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealfireTableViewController.h"

@class AddExtraItemViewController;

@interface ExtraItemsTableViewController : MealfireTableViewController {
	NSMutableArray *extraItems;
	AddExtraItemViewController *addController;
}

- (void)startEdit:(id)sender;
- (void)endEdit:(id)sender;
- (void)addItem:(id)sender;
- (void)addedItem:(NSString *)name id:(NSDecimalNumber *)id;

@property (nonatomic, retain) NSMutableArray *extraItems;
@property (nonatomic, retain) AddExtraItemViewController *addController;

@end
