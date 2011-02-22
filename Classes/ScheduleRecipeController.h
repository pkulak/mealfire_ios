//
//  ScheduleRecipeController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecipeViewController;

@interface ScheduleRecipeController : UITableViewController {
	NSMutableArray *dates;
	NSDecimalNumber *recipeID;
	RecipeViewController *parent;
}

@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) NSDecimalNumber *recipeID;
@property (nonatomic, retain) RecipeViewController *parent;

@end
