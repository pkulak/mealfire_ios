//
//  MeafireTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@class LoginViewController;
@class ASIFormDataRequest;

@interface MealfireTableViewController : UITableViewController {
	MBProgressHUD *hud;
	LoginViewController *loginViewController;
}

- (ASIFormDataRequest *)getRequest;
- (void)dataLoaded:(id)data;
- (void)loadData;
- (void)showLoginWindow;

@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) LoginViewController *loginViewController;

@end
