//
//  RecipeViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ScheduleRecipeController.h"

@interface RecipeViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSDecimalNumber *recipeID;
	MBProgressHUD *hud;
	ScheduleRecipeController *scheduleController;
}

- (void)loadRecipe;
- (void)recipeScheduledFor:(NSDate *)date;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSDecimalNumber *recipeID;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) ScheduleRecipeController *scheduleController;

@end
