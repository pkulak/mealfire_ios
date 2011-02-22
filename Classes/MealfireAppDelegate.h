//
//  MealfireAppDelegate.h
//  Mealfire
//
//  Created by Phil Kulak on 3/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarTableViewController;

@interface MealfireAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	IBOutlet UITabBarController *rootController;
	IBOutlet CalendarTableViewController *calendarTVC;
}

+ (MealfireAppDelegate *)delegate;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) CalendarTableViewController *calendarTVC;

@end

