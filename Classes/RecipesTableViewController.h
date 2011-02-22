//
//  RecipesTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "MealfireTableViewController.h"

@class RecipeViewController;
@class LoginViewController;
@class ASIHTTPRequest;
@class MBProgressHUD;

@interface RecipesTableViewController : MealfireTableViewController <IconDownloaderDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *recipesTableView;
	IBOutlet UISearchBar *searchBar;
	NSMutableArray *recipesArray;
	NSMutableArray *searchRecipesArray;
	RecipeViewController *recipeViewController;
	BOOL searching;
	LoginViewController *loginView;
	NSMutableDictionary *imageDownloadsInProgress;
}

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (NSMutableArray *) viewableRecipes;
- (void)startIconDownload:(Recipe *)recipe forIndexPath:(NSIndexPath *)indexPath;
- (void) loadRecipes;

@property (nonatomic, retain) RecipeViewController *recipeViewController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *recipesArray;
@property (nonatomic, retain) NSMutableArray *searchRecipesArray;
@property (nonatomic, retain) LoginViewController *loginView;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@end
