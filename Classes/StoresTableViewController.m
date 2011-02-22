//
//  StoreTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StoresTableViewController.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "JSON.h"
#import "StoreTableViewController.h"

@implementation StoresTableViewController

@synthesize stores;
@synthesize storeController;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Stores";
	self.stores = [NSMutableArray array];
	[self loadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(loadData)
		name:UIApplicationWillEnterForegroundNotification
		object:nil];
}

- (ASIFormDataRequest *)getRequest {
	return [MealfireHelper apiRequestForAction:@"get_stores"];
}

- (void)dataLoaded:(id)data {
	self.stores = data;
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stores count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *store = [stores objectAtIndex:indexPath.row];
	cell.textLabel.text = [store objectForKey:@"name"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *store = [stores objectAtIndex:indexPath.row];
	
	if (storeController == nil) {
		StoreTableViewController *controller = [[StoreTableViewController alloc] initWithNibName:@"StoreTableView" bundle:nil];
		controller.title = [store objectForKey:@"name"];
		self.storeController = controller;
		[controller release];
	}
	
	storeController.storeID = [store objectForKey:@"id"];
	[[self navigationController] pushViewController:storeController animated:YES];
	[storeController loadData];
}


- (void)dealloc {
	[super dealloc];
	[stores release];
	[storeController release];
}


@end

