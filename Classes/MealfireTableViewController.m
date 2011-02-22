//
//  MeafireTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MealfireTableViewController.h"
#import "MealfireAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "MealfireHelper.h"

@implementation MealfireTableViewController

@synthesize hud;
@synthesize loginViewController;

- (void)loadData {
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
		[self showLoginWindow];
		return;
	}
	
	// Start the request.
	ASIFormDataRequest *request = [self getRequest];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestSuccess:)];
	[request setDidFailSelector:@selector(requestFailure:)];
	[request startAsynchronous];
	
	// Show the progress HUD.
	self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	self.hud.graceTime = 0.2;
	self.hud.taskInProgress = YES;
	[self.navigationController.view addSubview:self.hud];
	[self.hud show:YES];
}

- (void)requestSuccess:(ASIHTTPRequest *)request {
	[self.hud removeFromSuperview];
    self.hud = nil;
	
	if ([request responseStatusCode] == 400 && [[request responseString] isEqualToString:@"Invalid Token"]) {
		[self showLoginWindow];
	}
	else {
		SBJSON *parser = [[SBJSON alloc] init];
		id data = [parser objectWithString:[request responseString] error:nil];
		[self dataLoaded:data];
		[parser release];
		[self.tableView reloadData];
	}
}

- (void)showLoginWindow {
	if (loginViewController == nil) {
		LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
		
		// Bump it down 20 pixels.
		CGRect theRect = lvc.view.frame;
		theRect = CGRectOffset(theRect, 0.0, 20.0);
		lvc.view.frame = theRect;
		
		lvc.delegate = self;
		self.loginViewController = lvc;
		[lvc release];
	}
	
	[[[MealfireAppDelegate delegate] window] addSubview:loginViewController.view];
}

- (void)requestFailure:(ASIHTTPRequest *)request {
	[self.hud removeFromSuperview];
    self.hud = nil;
	
	// Ask the user if he or she would like to give it another shot.
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Request Failed"
		message:@"The data could not be downloaded from the internet. Would you like to try again?"
		delegate:self
		cancelButtonTitle:@"No"
		otherButtonTitles:@"Yes", nil];
	
	[av show];
	[av release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1)
		[self loadData];
}

- (void)loginSuccessful {
	[loginViewController.view removeFromSuperview];
	self.loginViewController = nil;
	[self loadData];
}

- (ASIFormDataRequest *)getRequest {
	return nil;
}

- (void)dataLoaded:(id)data {
}

- (void)dealloc {
	[hud release];
	[loginViewController release];
	[super dealloc];
}

@end

