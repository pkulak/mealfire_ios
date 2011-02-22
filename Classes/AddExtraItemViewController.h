//
//  AddExtraItemViewController.h
//  Mealfire
//
//  Created by Phil Kulak on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class ExtraItemsTableViewController;

@interface AddExtraItemViewController : UIViewController {
	IBOutlet UITextField *textField;
	ExtraItemsTableViewController *parent;
	MBProgressHUD *hud;
}

- (void)addItem:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) ExtraItemsTableViewController	*parent;
@property (nonatomic, retain) MBProgressHUD *hud;

@end
