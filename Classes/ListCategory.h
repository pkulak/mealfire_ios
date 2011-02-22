//
//  ListCategory.h
//  Mealfire
//
//  Created by Phil Kulak on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListCategory : NSObject {
	NSString *name;
	NSMutableArray *items;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *items;

@end
