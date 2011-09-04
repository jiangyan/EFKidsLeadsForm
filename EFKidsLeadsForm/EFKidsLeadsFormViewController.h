//
//  EFKidsLeadsFormViewController.h
//  EFKidsLeadsForm
//
//  Created by yan jiang on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBTableAlert.h"
#import "TDDatePickerController.h"

@class EFKidsLeadsSubmittedViewController;
@class ASIFormDataRequest;

typedef enum AlertViewType {
    NA,
    SCHOOL,
    CHANNEL
} AlertViewType;

@interface EFKidsLeadsFormViewController : UIViewController <SBTableAlertDelegate, SBTableAlertDataSource> {

    // Controls
    IBOutlet UIButton* Button_School;
    IBOutlet UIButton* Button_Channel;
    IBOutlet UIButton* Button_Birth;
    
    IBOutlet UITextField* TextField_Name;
    IBOutlet UITextField* TextField_Email;
    IBOutlet UITextField* TextField_Mobile;
    IBOutlet UITextField* TextField_MarketPlace;
    IBOutlet UITextField* TextField_Promoter;
    IBOutlet UITextField* TextField_VisitTime;
    IBOutlet UITextView* TextView_Comment;
    
    IBOutlet UILabel* Label_Error;
    
    IBOutlet TDDatePickerController* DatePicker_Birth;
    
    IBOutlet EFKidsLeadsSubmittedViewController* ViewController_Submitted;
    
    // Data
    NSString* _currentSchoolCode;
    NSString* _currentChannelCode;
    NSDictionary* _schoolDict;
    NSArray* _channelArray;
    NSArray* _schoolCodeArray;
    AlertViewType _alertType;
    
    // Member
    ASIFormDataRequest* postRequest;
}

// Properties
// Controls
@property(retain) IBOutlet UIButton* Button_School;
@property(retain) IBOutlet UIButton* Button_Channel;
@property(retain) IBOutlet UIButton* Button_Birth;

@property(retain) UITextField* TextField_Name;
@property(retain) UITextField* TextField_Email;
@property(retain) UITextField* TextField_Mobile;
@property(retain) UITextField* TextField_MarketPlace;
@property(retain) UITextField* TextField_Promoter;
@property(retain) UITextField* TextField_VisitTime;
@property(retain) UITextView* TextView_Comment;

@property(retain) UILabel* Label_Error;

@property(retain) IBOutlet TDDatePickerController* DatePicker_Birth;
@property(retain) IBOutlet EFKidsLeadsSubmittedViewController* ViewController_Submitted;

@property(nonatomic, retain) NSDictionary* _schoolDict;
@property(nonatomic, retain) NSArray* _channelArray;
@property(nonatomic, retain) NSArray* _schoolCodeArray;

@property (retain, nonatomic) ASIFormDataRequest* postRequest;

// Events

-(IBAction)ButtonClick_SelectBirth:(id)sender;
-(IBAction)ButtonClick_SelectSchool:(id)sender;
-(IBAction)ButtonClick_SelectChannel:(id)sender;
-(IBAction)ButtonClick_SubmitForm:(id)sender;

// Methods
- (void) initialize;
- (void) clearForm;
- (NSString*) getSchoolCode:(int)index;
- (void) showTableListView;
- (NSString*) getTableListViewTitle;
- (NSString*) getCellText:(int)index;
- (void) setButtonText:(int)index;
- (NSString*)validateFormData;
- (void)flipToSubmittedView;
- (BOOL) postFormData;
@end
