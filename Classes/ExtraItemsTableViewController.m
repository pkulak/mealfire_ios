//
//  ExtraItemsTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExtraItemsTableViewController.h"
#import "MealfireAppDelegate.h"
#import "AddExtraItemViewController.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "JSON.h"

@implementation ExtraItemsTableViewController

@synthesize extraItems;
@synthesize addController;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = NSLocalizedString(@"Extra Items", @"Extras");
	
	// Set up both our arrays and initial states.
	NSMutableArray *a = [[NSMutableArray  alloc] init];
	self.extraItems = a;
	[a release];
	self.tableView.allowsSelection = FALSE;
	
	// Add our edit button.
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
							   target:self
							   action:@selector(startEdit:)];
	
	self.navigationItem.rightBarButtonItem = button;
	[button release];
	
	// And our add button.
	button = [[UIBarButtonItem alloc]
			  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
			  target:self
			  action:@selector(addItem:)];
	
	self.navigationItem.leftBarButtonItem = button;
	[button release];

	[self loadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(loadData)
		name:UIApplicationWillEnterForegroundNotification
		object:nil];
}

- (ASIFormDataRequest *)getRequest {
	return [MealfireHelper apiRequestForAction:@"get_extra_items"];
}

- (void)dataLoaded:(id)data {
	self.extraItems = data;
}

- (void)startEdit:(id)sender {
	[(UITableView *) self.view setEditing:TRUE animated:TRUE];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
							   target:self
							   action:@selector(endEdit:)];
	
	self.navigationItem.rightBarButtonItem = button;
	[button release];
}

- (void)endEdit:(id)sender {
	[(UITableView *) self.view setEditing:FALSE animated:TRUE];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
							   target:self
							   action:@selector(startEdit:)];
	
	self.navigationItem.rightBarButtonItem = button;
	[button release];
}

- (void)addItem:(id)sender {
	if (addController == nil) {
		AddExtraItemViewController *view = [[AddExtraItemViewController alloc]
											initWithNibName:@"AddExtraItemViewController" bundle:nil];
		view.parent = self;
		view.title = @"Add Item";
		self.addController = view;
		[view release];
	}
	
	[self.navigationController pushViewController:addController animated:YES];
}

- (void)addedItem:(NSString *)name id:(NSDecimalNumber *)id {
	NSDictionary *newItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:name, id, nil]
							 forKeys:[NSArray arrayWithObjects:@"name", @"id", nil]];
	
	[self.extraItems addObject:newItem];
	
	NSUInteger indexArr[] = {0, [self.extraItems count] - 1};
	NSIndexPath *path = [NSIndexPath indexPathWithIndexes:indexArr length:2];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)view commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	// This should never happen, but just to make sure...
	if (editingStyle != UITableViewCellEditingStyleDelete)
		return;
	
	NSDictionary *item = [[[self extraItems] objectAtIndex:[indexPath row]] retain];
	
	// Send the request off to the server.
	ASIFormDataRequest *request = [MealfireHelper apiRequestForAction:@"delete_extra_item"];
	[request setPostValue:[item objectForKey:@"id"] forKey:@"id"];
	[request startAsynchronous];
	
	// Delete from the datasource.
	[[self extraItems] removeObjectAtIndex:[indexPath row]];
	
	// And delete the row from the view.
	[(UITableView *) self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
					 withRowAnimation:UITableViewRowAnimationFade];
	
	[item release];
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
    return [extraItems count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *item = [[self extraItems] objectAtIndex:[indexPath row]];
	cell.textLabel.text = [item objectForKey:@"name"];
	
    return cell;
}

- (void)dealloc {
	[extraItems release];
	[addController release];
	[super dealloc];
}

@end

