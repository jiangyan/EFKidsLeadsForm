//
//  EFKidsLeadsSubmittedViewController.m
//  EFKidsLeadsForm
//
//  Created by yan jiang on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EFKidsLeadsSubmittedViewController.h"

#import "EFKidsLeadsFormViewController.h"

@implementation EFKidsLeadsSubmittedViewController

@synthesize ViewController_Form;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc {
    [super dealloc];
}

#pragma mark - Events
- (IBAction) ButtonClick_Return:(id)sender {
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp
                           forView:self.view.superview cache:YES];
    
    // Clear form view
    [ViewController_Form clearForm];
    
    [self.view removeFromSuperview];
    [UIView commitAnimations];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
