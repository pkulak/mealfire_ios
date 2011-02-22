//
//  ListCategory.m
//  Mealfire
//
//  Created by Phil Kulak on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListCategory.h"

@implementation ListCategory

@synthesize name;
@synthesize items;

- (void)dealloc {
	[name release];
	[items release];
	[super dealloc];
}

@end
