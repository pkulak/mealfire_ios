//
//  ListTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListTableViewController.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "MealfireAppDelegate.h"
#import "JSON.h"
#import "ListCategory.h"
#import "ListItem.h"

@implementation ListTableViewController

@synthesize listID;
@synthesize categories;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.categories = [NSMutableArray array];
}

- (ASIFormDataRequest *)getRequest {
	ASIFormDataRequest *request = [MealfireHelper apiRequestForAction:@"get_list"];
	[request setPostValue:listID forKey:@"id"];
	return request;
}

- (void)dataLoaded:(id)data {
	[self.categories removeAllObjects];
	
	for (NSDictionary *dic in data) {
		ListCategory * cat = [[ListCategory alloc] init];
		cat.name = [dic objectForKey:@"name"];
		cat.items = [NSMutableArray array];
		
		for (NSString *i in [dic objectForKey:@"children"]) {
			ListItem *item = [[ListItem alloc] init];
			item.name = i;
			item.checked = NO;
			[cat.items addObject:item];
			[item release];
		}
		
		[self.categories addObject:cat];
		[cat release];
	}
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
    if ([categories count] == 0)
		return 1;
	else
		return [categories count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([categories count] == 0) {
		return 0;
	} else {
		ListCategory *cat = [categories objectAtIndex:section];
		return [cat.items count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([categories count] == 0)
		return [NSString string];
	else
		return [(ListCategory *) [categories objectAtIndex:section] name];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ListCategory *cat = [categories objectAtIndex:indexPath.section];
	ListItem *item = [cat.items objectAtIndex:indexPath.row];
	
	cell.textLabel.text = item.name;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	
	if (item.checked)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ListCategory *cat = [categories objectAtIndex:indexPath.section];
	ListItem *item = [cat.items objectAtIndex:indexPath.row];
	
	NSString *cellText = item.name;
	UIFont *cellFont = [UIFont boldSystemFontOfSize:18.0];
	CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	return labelSize.height + 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	ListCategory *cat = [self.categories objectAtIndex:indexPath.section];
	ListItem *item = [cat.items objectAtIndex:indexPath.row];
	
	if (item.checked) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		item.checked = NO;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		item.checked = YES;
	}
	
	cell.selected = NO;
}

- (void)dealloc {
	[listID release];
	[categories release];
	[super dealloc];
}


@end

