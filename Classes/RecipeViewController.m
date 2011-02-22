//
//  RecipeViewController.m
//  Mealfire
//
//  Created by Phil Kulak on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RecipeViewController.h"
#import "MealfireHelper.h"

@implementation RecipeViewController

@synthesize webView;
@synthesize recipeID;
@synthesize hud;
@synthesize scheduleController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Add our edit button.
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithTitle:@"Schedule"
							   style:UIBarButtonItemStylePlain
							   target:self
							   action:@selector(scheduleRecipe)];
	
	self.navigationItem.rightBarButtonItem = button;
	[button release];
	
}

- (void)scheduleRecipe {
	if (scheduleController == nil) {
		ScheduleRecipeController *c = [[ScheduleRecipeController alloc] initWithNibName:@"ScheduleRecipeView" bundle:nil];
		self.scheduleController = c;
		self.scheduleController.title = @"Schedule";
		self.scheduleController.parent = self;
		[c release];
	}
	
	self.scheduleController.recipeID = self.recipeID;
	[self.navigationController pushViewController:scheduleController animated:YES];
}

- (void)loadRecipe {
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
	NSString *base = [[MealfireHelper baseURL] stringByAppendingString: @"get_recipe_html"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&token=%@", base, [recipeID description], token]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
}

- (void)recipeScheduledFor:(NSDate *)date {
	NSString *dateString = nil;
	NSCalendar *calendar = [NSCalendar currentCalendar]; 
	NSDateComponents *todayParts = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	NSDateComponents *dateParts = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];

	NSDate *today = [calendar dateFromComponents:todayParts];
	date = [calendar dateFromComponents:dateParts];
	NSTimeInterval interval = [date timeIntervalSinceDate:today];
	
	if (interval < 60 * 60 * 24) {
		dateString = @"today";
	}
	else if (interval < 60 * 60 * 48) {
		dateString = @"tomorrow";
	}
	else {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateFormat:@"EEE',' MMMM d"];
		dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];
	}
	
	[webView stringByEvaluatingJavaScriptFromString:
		[NSString stringWithFormat:@"var div=document.getElementById('notice');div.style.display='block';div.innerHTML='Scheduled for %@.';", dateString]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.hud = [[MBProgressHUD alloc] initWithView:self.view];
	self.hud.graceTime = 0.2;
	self.hud.taskInProgress = YES;
	[self.view addSubview:self.hud];
	[self.hud show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.hud removeFromSuperview];
    self.hud = nil;
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


- (void)dealloc {
	webView.delegate = nil;
	[webView release];
	[hud release];
	[recipeID release];
	[super dealloc];
}


@end
