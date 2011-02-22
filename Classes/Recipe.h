//
//  Recipe.h
//  Mealfire
//
//  Created by Phil Kulak on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject {
	NSString *name;
	NSDecimalNumber *recipeID;
	NSArray *tags;
	NSString *imageUrl;
	UIImage *image;
}

- (id)initFromDictionary:(NSDictionary *)dic;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDecimalNumber *recipeID;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) UIImage *image;

@end
