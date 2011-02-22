//
//  ListItem.m
//  Mealfire
//
//  Created by Phil Kulak on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

@synthesize name;
@synthesize checked;

- (void)dealloc {
	[name release];
	[super dealloc];
}

@end
