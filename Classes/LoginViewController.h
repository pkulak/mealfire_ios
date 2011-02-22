//
//  LoginViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class ASIHTTPRequest;

@interface LoginViewController : UIViewController {	
	UITextField IBOutlet *emailTextField;
	UITextField IBOutlet *passwordTextField;
	UIButton IBOutlet *button;
	NSObject *delegate;
	MBProgressHUD *hud;
}

- (IBAction)login;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSObject *delegate;
@property (nonatomic, retain) MBProgressHUD *hud;

@end
