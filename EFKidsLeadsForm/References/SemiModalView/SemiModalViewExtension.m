//
//  UIViewController+TDSemiModalExtension.m
//  TDSemiModal
//
//  Created by Nathan  Reed on 18/10/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import "SemiModalViewExtension.h"

@implementation UIViewController (TDSemiModalExtension)

// Use this to show the modal view (pops-up from the bottom)
- (void) presentSemiModalViewController:(TDSemiModalViewController*)vc {
#define DEGREES_TO_RADIANS(x) (M_PI * (x)/180.0)

//	UIView* modalView = vc.view;
//	UIView* coverView = vc.coverView;
//
//
//	[self.view addSubview:coverView];
//	[self.view addSubview:modalView];
//	
//	// Show it with a transition effect
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.6];
//	
//	coverView.alpha = 0.5;
//
//	[UIView commitAnimations];
    
    UIView* modalView = vc.view;
	UIView* coverView = vc.coverView;
    
	CGPoint middleCenter = self.view.center;
	CGSize offSize = [UIScreen mainScreen].bounds.size;
    
	CGPoint offScreenCenter = CGPointZero;
    
    //	if(orientation == UIInterfaceOrientationLandscapeLeft ||
    //	   orientation == UIInterfaceOrientationLandscapeRight) {
    //		
    //		offScreenCenter = CGPointMake(offSize.height / 2.0, offSize.width * 1.2);
    //		middleCenter = CGPointMake(middleCenter.y, middleCenter.x);
    //		[modalView setBounds:CGRectMake(0, 0, 480, 300)];
    //	}
	//else {
    offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.2);
    [modalView setBounds:CGRectMake(0, 400, 320, 460)];
    [coverView setFrame:CGRectMake(0, 400, 320, 460)];
	//}
	
	// we start off-screen
	modalView.center = offScreenCenter;
    
	coverView.alpha = 0.0f;
	
	[self.view addSubview:coverView];
	[self.view addSubview:modalView];
	
	// Show it with a transition effect
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	modalView.center = middleCenter;
	coverView.alpha = 0.5;
    
	[UIView commitAnimations];

}

// Use this to slide the semi-modal view back down.
-(void) dismissSemiModalViewController:(TDSemiModalViewController*)vc {
	double animationDelay = 0.7;
	UIView* modalView = vc.view;
	UIView* coverView = vc.coverView;

	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:animationDelay];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(dismissSemiModalViewControllerEnded:finished:context:)];
	coverView.alpha = 0.0f;
	[UIView commitAnimations];

	[coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animationDelay];

}

- (void) dismissSemiModalViewControllerEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIView* modalView = (UIView*)context;
	[modalView removeFromSuperview];

}

@end
