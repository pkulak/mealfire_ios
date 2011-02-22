//
//  StoreTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StoreTableViewController.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "MealfireAppDelegate.h"
#import "JSON.h"

@implementation StoreTableViewController

@synthesize categories;
@synthesize storeID;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.categories = [NSMutableArray array];
	self.tableView.allowsSelection = NO;
	[self.tableView setEditing:YES animated:NO];
}

- (ASIFormDataRequest *)getRequest {
	ASIFormDataRequest *request = [MealfireHelper apiRequestForAction:@"get_store"];
	[request setPostValue:storeID forKey:@"id"];
	return request;
}

- (void)dataLoaded:(id)data {
	self.categories = [NSMutableArray arrayWithArray:data];
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
    return [categories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *cat = [categories objectAtIndex:indexPath.row];
	cell.textLabel.text = [cat objectForKey:@"name"];
	cell.showsReorderControl = YES;
	
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// Update the datastore.
	[self.categories exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	
	// And tell the server.
	NSMutableArray *ids = [NSMutableArray array];
	
	for (NSDictionary *cat in self.categories) {
		[ids addObject:[cat objectForKey:@"id"]];
	}
		
	ASIFormDataRequest *request = [MealfireHelper apiRequestForAction:@"update_store"];
	[request setPostValue:storeID forKey:@"id"];
	[request setPostValue:[ids componentsJoinedByString:@","] forKey:@"categories"];
	[request startAsynchronous];
}

- (void)dealloc {
	[categories release];
	[storeID release];
	[super dealloc];
}


@end

