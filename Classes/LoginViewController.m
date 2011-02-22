//
//  LoginViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "MealfireAppDelegate.h"
#import "MealfireHelper.h"

@protocol HandlesLogin
-(void) loginSuccessful;
@end

@implementation LoginViewController

@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize button;
@synthesize delegate;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)login
{
	NSString *email = [emailTextField text];
	NSString *pass = [passwordTextField text];
	NSString *errorMessage = nil;
	
	// Validation
	if ([email length] == 0) {
		errorMessage = @"Please enter your email address.";
	}
	else if ([pass length] == 0) {
		errorMessage = @"Please enter your password.";
	}
	
	if (errorMessage) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
			message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[emailTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	
	// Start the request for the authentication token.	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[MealfireHelper apiUrlForAction:@"get_token"]];
	
	[request setPostValue:email forKey:@"email"];
	[request setPostValue:pass forKey:@"password"];
	
	[request setDelegate:self];
	[request startAsynchronous];
	
	self.hud = [[MBProgressHUD alloc] initWithView:self.view];
	self.hud.labelText = @"Logging in...";
	self.hud.taskInProgress = YES;
	[self.view addSubview:self.hud];
	[self.hud show:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
	[self login];
    return NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[self.hud removeFromSuperview];
    self.hud = nil;
	
	if ([request responseStatusCode] == 400)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
			message:[request responseString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		NSString *token = [request responseString];
		
		// Store our token.
		[[NSUserDefaults standardUserDefaults] setObject:token forKey:@"authToken"];
		
		// Let the parent know that we've logged in.
		if ([delegate respondsToSelector:@selector(loginSuccessful)])
			[delegate performSelector:@selector(loginSuccessful)];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.hud removeFromSuperview];
    self.hud = nil;
	
	NSString *message = @"You could not be logged in. Please try again later.";

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
		message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[emailTextField release];
	[passwordTextField release];
	[button release];
	[delegate release];
	[hud release];
	[super dealloc];
}


@end
