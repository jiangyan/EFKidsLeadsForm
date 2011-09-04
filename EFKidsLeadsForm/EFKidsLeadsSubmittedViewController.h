//
//  EFKidsLeadsSubmittedViewController.h
//  EFKidsLeadsForm
//
//  Created by yan jiang on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFKidsLeadsFormViewController;

@interface EFKidsLeadsSubmittedViewController : UIViewController {
    
    // Parent view controller
    IBOutlet EFKidsLeadsFormViewController* ViewController_Form;
}

// Properties
@property(retain) IBOutlet EFKidsLeadsFormViewController* ViewController_Form;

// Events
- (IBAction) ButtonClick_Return:(id)sender;

@end
