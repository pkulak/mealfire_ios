//
//  MealfireHelper.h
//  Mealfire
//
//  Created by Phil Kulak on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIFormDataRequest;
@class MealfireAppDelegate;

@interface MealfireHelper : NSObject {}

+ (NSString *)baseURL;
+ (NSURL *)apiUrlForAction:(NSString *)action;
+ (ASIFormDataRequest *)apiRequestForAction:(NSString *)action;

@end
