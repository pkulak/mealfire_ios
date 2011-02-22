//
//  ListTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealfireTableViewController.h"

@interface ListTableViewController : MealfireTableViewController {
	NSDecimalNumber *listID;
	NSMutableArray *categories;
}

@property (nonatomic, retain) NSDecimalNumber *listID;
@property (nonatomic, retain) NSMutableArray *categories;

@end
