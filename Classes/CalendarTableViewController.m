//
//  CalendarTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableViewController.h"
#import "MealfireHelper.h"
#import "Recipe.h"
#import "RecipeViewController.h"

@implementation CalendarTableViewController

@synthesize days;
@synthesize imageDownloadsInProgress;
@synthesize recipeViewController;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Calendar";
	self.tableView.rowHeight = 60;
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	[self loadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(loadData)
		name:UIApplicationWillEnterForegroundNotification
		object:nil];
}

- (ASIFormDataRequest *)getRequest {
	return [MealfireHelper apiRequestForAction:@"get_calendar"];
}

- (void)dataLoaded:(id)data {
	[imageDownloadsInProgress removeAllObjects];
	
	for (NSDictionary *day in data) {
		NSMutableArray *recipes = [NSMutableArray array];
		
		for (NSDictionary *recipe in [day objectForKey:@"recipes"]) {
			id r = [[Recipe alloc] initFromDictionary:recipe];
			[recipes addObject:r];
			[r release];
		}
		
		[day setValue:recipes forKey:@"recipes"];
	}
	
	self.days = data;
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
    return [days count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *day = [days objectAtIndex:section];
	NSArray *recipes = [day objectForKey:@"recipes"];
	return [recipes count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *day = [days objectAtIndex:section];
	return [day objectForKey:@"day"];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
	NSDictionary *day = [days objectAtIndex:indexPath.section];
	Recipe *recipe = [[day objectForKey:@"recipes"] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = recipe.name;
	
	// Only load cached images; defer new downloads until scrolling ends
	if (!recipe.image) {
		if (recipe.imageUrl == nil) {
			cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
		}
		else {
			if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
				[self startIconDownload:recipe forIndexPath:indexPath];
			}
			// if a download is deferred or in progress, return a placeholder image
			cell.imageView.image = [UIImage imageNamed:@"PlaceholderBlank.png"];
		}
	}
	else {
		cell.imageView.image = recipe.image;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (recipeViewController == nil) {
		RecipeViewController *view = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
		self.recipeViewController = view;
		[view release];
	}
	
	NSDictionary *day = [days objectAtIndex:indexPath.section];
	Recipe *recipe = [[day objectForKey:@"recipes"] objectAtIndex:indexPath.row];
	recipeViewController.title = recipe.name;
	recipeViewController.recipeID = recipe.recipeID;
	[[self navigationController] pushViewController:recipeViewController animated:YES];
	[recipeViewController loadRecipe];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Recipe *)recipe forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.recipe = recipe;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		NSDictionary *day = [days objectAtIndex:indexPath.section];
		Recipe *recipe = [[day objectForKey:@"recipes"] objectAtIndex:indexPath.row];
		
		if (!recipe.image) // avoid the app icon download if the app already has an icon
		{
			if (recipe.imageUrl == nil) {
				UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
				cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
			}
			else {
				[self startIconDownload:recipe forIndexPath:indexPath];
			}
		}
	}
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.recipe.image;
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)dealloc {
	[days release];
	[recipeViewController release];
	[super dealloc];
}


@end

