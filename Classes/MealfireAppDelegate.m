//
//  MealfireAppDelegate.m
//  Mealfire
//
//  Created by Phil Kulak on 3/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
//  The Mealfire.com mobile application lets you easily view and schedule all your recipes and gives you access to your shopping lists, extra items, and stores. A free account at Mealfire.com is required.
//

#import "MealfireAppDelegate.h"
#import "MealfireHelper.h"

@implementation MealfireAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize calendarTVC;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	[window addSubview:rootController.view];
	[window makeKeyAndVisible];
}

+ (MealfireAppDelegate *)delegate {
	return [[UIApplication sharedApplication] delegate];
}

- (void)dealloc {
	[rootController release];	
	[window release];
	[calendarTVC release];
	[super dealloc];
}

@end
