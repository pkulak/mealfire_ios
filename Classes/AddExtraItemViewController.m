//
//  AddExtraItemViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddExtraItemViewController.h"
#import "MealfireAppDelegate.h"
#import "MealfireHelper.h"
#import "ASIFormDataRequest.h"
#import "ExtraItemsTableViewController.h"

@implementation AddExtraItemViewController

@synthesize textField;
@synthesize parent;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[textField becomeFirstResponder];
}

- (void)addItem:(id)sender {
	[textField resignFirstResponder];
	
	// Start the request to grab the extra items.
	ASIFormDataRequest *request = [MealfireHelper apiRequestForAction:@"add_extra_item"];
	[request setPostValue:[self.textField text] forKey:@"name"];
	[request setDelegate:self];
	[request startAsynchronous];
	
	// Start the wait.
	self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	self.hud.labelText = @"Adding item...";
	self.hud.graceTime = 0.2;
	self.hud.taskInProgress = YES;
	[self.navigationController.view addSubview:self.hud];
	[self.hud show:YES];	
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
	[self addItem:self];
    [field resignFirstResponder];
    return NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Stop waiting.
	[self.hud removeFromSuperview];
    self.hud = nil;
	
	// Pop this view off the stack.
	[self.navigationController popViewControllerAnimated:TRUE];
	
	// Let the parent controller know what we just did.
	[parent addedItem:[textField text] id:[NSDecimalNumber decimalNumberWithString:[request responseString]]];
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
	[textField release];
	[parent release];
	[hud release];
	[super dealloc];
}


@end
