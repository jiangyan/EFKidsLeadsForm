//
//  EFKidsLeadsFormAppDelegate.h
//  EFKidsLeadsForm
//
//  Created by yan jiang on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFKidsLeadsFormViewController;

@interface EFKidsLeadsFormAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet EFKidsLeadsFormViewController *viewController;

@end
