//
//  MealfireHelper.m
//  Mealfire
//
//  Created by Phil Kulak on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MealfireHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MealfireAppDelegate.h"

@implementation MealfireHelper

+ (NSString *)baseURL {
	return @"http://mealfire.com/api/";
}

+ (NSURL *)apiUrlForAction:(NSString *)action {
	return [NSURL URLWithString:[[self baseURL] stringByAppendingString:action]];
}

+ (ASIFormDataRequest *)apiRequestForAction:(NSString *)action {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[MealfireHelper apiUrlForAction:action]];
	[request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"token"];
	return request;
}

@end
