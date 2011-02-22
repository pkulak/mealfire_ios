//
//  ListsTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealfireTableViewController.h"

@class ListTableViewController;

@interface ListsTableViewController : MealfireTableViewController {
	NSMutableArray *items;
	ListTableViewController *listController;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) ListTableViewController *listController;

@end
