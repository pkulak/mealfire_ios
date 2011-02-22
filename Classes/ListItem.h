//
//  ListItem.h
//  Mealfire
//
//  Created by Phil Kulak on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListItem : NSObject {
	NSString *name;
	BOOL checked;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic) BOOL checked;

@end
