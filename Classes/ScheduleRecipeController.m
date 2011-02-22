//
//  ScheduleRecipeController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleRecipeController.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "RecipeViewController.h"
#import "MealfireAppDelegate.h"
#import "CalendarTableViewController.h"

@implementation ScheduleRecipeController

@synthesize dates;
@synthesize recipeID;
@synthesize parent;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 14;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Today";
	}
	else if (indexPath.row == 1) {
		cell.textLabel.text = @"Tomorrow";
	}
	else {
		NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:86400 * indexPath.row];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateFormat:@"EEE',' MMMM d"];
		
		cell.textLabel.text = [dateFormatter stringFromDate:date];
		
		[date release];
		[dateFormatter release];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:86400 * indexPath.row];
	NSCalendar *calendar = [NSCalendar currentCalendar]; 
	NSDateComponents *parts = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
	
	// Start the request to schedule this recipe.
	ASIFormDataRequest *request = [MealfireHelper apiRequestForAction:@"schedule_recipe"];
	request.delegate = self;
	[request setPostValue:[NSString stringWithFormat:@"%d", [parts day]]  forKey:@"day"];
	[request setPostValue:[NSString stringWithFormat:@"%d", [parts month]]  forKey:@"month"];
	[request setPostValue:[NSString stringWithFormat:@"%d", [parts year]]  forKey:@"year"];
	[request setPostValue:recipeID forKey:@"recipe_id"];
	[request startAsynchronous];
	
	// Send us back whence we came.
	[[self navigationController] popViewControllerAnimated:YES];
	
	// And let them know about it.
	[self.parent recipeScheduledFor:date];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Refresh the Calendar.
	[[[MealfireAppDelegate delegate] calendarTVC] loadData];
}

- (void)dealloc {
	[dates release];
	[recipeID release];
	[parent release];
	[super dealloc];
}


@end

