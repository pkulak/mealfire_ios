//
//  RecipesTableViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RecipesTableViewController.h"
#import "RecipeViewController.h"
#import "MealfireAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "MealfireHelper.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "Recipe.h"
#import "MBProgressHUD.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7

@implementation RecipesTableViewController

@synthesize recipeViewController;
@synthesize searchBar;
@synthesize recipesArray;
@synthesize searchRecipesArray;
@synthesize loginView;
@synthesize imageDownloadsInProgress;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Your Recipes", @"Recipes");
	
	// Set up both our intitial states.
	
	self.tableView.rowHeight = kCustomRowHeight;
	searching = FALSE;
	
	[self loadRecipes];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(loadRecipes)
		name:UIApplicationWillEnterForegroundNotification
		object:nil];
}

- (void)loadRecipes {
	// Don't load new data while we're searching.
	if (searching)
		return;
	
	self.recipesArray = [NSMutableArray array];
	self.searchRecipesArray = [NSMutableArray array];
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	
	[self loadData];
}

- (void)dataLoaded:(id)data {
	[recipesArray removeAllObjects];
	
	for (NSDictionary *dic in data) {
		Recipe *r = [[Recipe alloc] initFromDictionary:dic];
		[recipesArray addObject:r];
		[r release];
	}
	
	self.searchRecipesArray = [NSMutableArray arrayWithArray:self.recipesArray];
}

- (ASIFormDataRequest *)getRequest {
	return [MealfireHelper apiRequestForAction:@"get_recipes"];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	searching = YES;
	
	// Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
		initWithBarButtonSystemItem:UIBarButtonSystemItemDone
		target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	if([searchText length] > 0) {
		searching = YES;
		[self searchTableView];
	}
	else {
		searching = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self searchTableView];
}

- (void) searchTableView {
	NSString *searchText = searchBar.text;
	
	[searchRecipesArray removeAllObjects];
	
	for (Recipe *r in recipesArray)
	{
		NSRange range = [r.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		BOOL tagsMatch = FALSE;
		
		for (NSString *tag in r.tags) {
			if ([tag rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0)
				tagsMatch = TRUE;
		}
		
		if (range.length > 0 || tagsMatch)
			[searchRecipesArray addObject:r];
	}
}

- (void) doneSearching_Clicked:(id)sender {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
 	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	
	[self.tableView reloadData];
}

// Either all recipes, or the recipes searched for, depending on the context.
- (NSMutableArray *) viewableRecipes {
	if (searching)
		return self.searchRecipesArray;
	else
		return self.recipesArray;
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
    return [[self viewableRecipes] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Recipe *recipe = [[self viewableRecipes] objectAtIndex:[indexPath row]];
	cell.textLabel.text = recipe.name;
	cell.detailTextLabel.text = [recipe.tags componentsJoinedByString:@", "];
	
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
	NSInteger row = [indexPath row];
	
	if (recipeViewController == nil) {
		RecipeViewController *view = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
		self.recipeViewController = view;
		[view release];
	}
	
	Recipe *recipe = [[self viewableRecipes] objectAtIndex:row];
	recipeViewController.title = recipe.name;
	recipeViewController.recipeID = recipe.recipeID;
	[[self navigationController] pushViewController:recipeViewController animated:YES];
	[recipeViewController loadRecipe];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
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
    if ([self.viewableRecipes count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Recipe *recipe = [self.viewableRecipes objectAtIndex:indexPath.row];
            
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
	[recipesArray release];
	[searchRecipesArray release];
	[recipeViewController release];
	[searchBar release];
	[loginView release];
	[imageDownloadsInProgress release];
	[super dealloc];
}


@end

