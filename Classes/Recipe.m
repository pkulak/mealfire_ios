//
//  Recipe.m
//  Mealfire
//
//  Created by Phil Kulak on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"


@implementation Recipe

@synthesize name;
@synthesize recipeID;
@synthesize tags;
@synthesize imageUrl;
@synthesize image;

- (id)initFromDictionary:(NSDictionary *)dic {
	if (self = [super init]) {
		self.name = [dic objectForKey:@"name"];
		self.recipeID = (NSDecimalNumber *) [dic objectForKey:@"id"];
		self.tags = [dic objectForKey:@"tags"];
		
		if ([dic objectForKey:@"img"] != [NSNull null])
			self.imageUrl = [dic objectForKey:@"img"];
	}
	
	return self;
}

- (void)dealloc {
	[recipeID release];
	[name release];
	[tags release];
	[imageUrl release];
	[image release];
	[super dealloc];
}


@end
