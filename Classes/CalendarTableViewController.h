//
//  CalendarTableViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealfireTableViewController.h"
#import "IconDownloader.h"

@class RecipeViewController;

@interface CalendarTableViewController : MealfireTableViewController <IconDownloaderDelegate> {
	NSMutableArray *days;
	NSMutableDictionary *imageDownloadsInProgress;
	RecipeViewController *recipeViewController;
}

- (void)startIconDownload:(Recipe *)recipe forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, retain) NSMutableArray *days;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) RecipeViewController *recipeViewController;

@end
