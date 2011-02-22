//
//  ListsTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListsTableViewController.h"
#import "ListTableViewController.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "MealfireAppDelegate.h"
#import "JSON.h"

@implementation ListsTableViewController

@synthesize items;
@synthesize listController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Lists";
	self.items = [NSMutableArray array];
	[self loadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(loadData)
		name:UIApplicationWillEnterForegroundNotification
		object:nil];
}

- (ASIFormDataRequest *)getRequest {
	return [MealfireHelper apiRequestForAction:@"get_lists"];
}

- (void)dataLoaded:(id)data {
	self.items = data;
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
    return [items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *item = [[self items] objectAtIndex:[indexPath row]];
	cell.textLabel.text = [item objectForKey:@"name"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (listController == nil) {
		ListTableViewController *view = [[ListTableViewController alloc] initWithNibName:@"ListTableView" bundle:nil];
		view.title = @"Shopping List";
		self.listController = view;
		[view release];
	}
	
	NSDictionary *item = [[self items] objectAtIndex:[indexPath row]];
	listController.listID = [item objectForKey:@"id"];
	
	[self.navigationController pushViewController:listController animated:YES];
	[listController loadData];
}

- (void)dealloc {
	[listController release];
	[super dealloc];
}


@end

