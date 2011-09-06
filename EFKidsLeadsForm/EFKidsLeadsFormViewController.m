//
//  EFKidsLeadsFormViewController.m
//  EFKidsLeadsForm
//
//  Created by yan jiang on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EFKidsLeadsFormViewController.h"

#import "SBJson.h"
#import "ASIFormDataRequest.h"

#import "Helper.h"
#import "EFKidsLeadsSubmittedViewController.h"

@implementation EFKidsLeadsFormViewController

@synthesize Button_School;
@synthesize Button_Channel;
@synthesize Button_Birth;

@synthesize TextField_Email;
@synthesize TextField_Name;
@synthesize TextField_Mobile;
@synthesize TextView_Comment;
@synthesize TextField_Promoter;
@synthesize TextField_VisitTime;
@synthesize TextField_MarketPlace;

@synthesize Label_Error;

@synthesize DatePicker_Birth;

@synthesize ViewController_Submitted;

@synthesize _schoolDict;
@synthesize _channelArray;
@synthesize _schoolCodeArray;

@synthesize postRequest;

static NSString* __post_url = @"http://devcn.englishtown.com/partners/e1/leads/form/home/submit";

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc {
    [postRequest setDelegate:nil];
	[postRequest setUploadProgressDelegate:nil];
	[postRequest cancel];
	[postRequest release];
    [_schoolCodeArray release];
    [_schoolDict release];
    [_channelArray release];
    [ViewController_Submitted release];
    [super dealloc];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
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

#pragma mark - Events

-(IBAction)ButtonClick_SelectBirth:(id)sender {
    [self presentSemiModalViewController:DatePicker_Birth];
}

- (IBAction)ButtonClick_SelectSchool:(id)sender {

    _alertType = SCHOOL;
    [self showTableListView];
}

- (IBAction)ButtonClick_SelectChannel:(id)sender {
    _alertType = CHANNEL;
    [self showTableListView];
}

-(IBAction)ButtonClick_SubmitForm:(id)sender {
    
    NSString* ret = [self validateFormData];
    if ([ret isEqualToString:(@"")] || [ret length] == 0) {

        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        // Regisete for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        
        HUD.labelText = @"信息正在提交...";
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(postFormData) onTarget:self withObject:nil animated:YES];
    } else {
        Label_Error.text = ret;
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
    if (_post_success == true) {
        [self flipToSubmittedView];
    }
}


#pragma mark - Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:DatePicker_Birth];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int year   =    [[calendar components:NSYearCalendarUnit fromDate:viewController.datePicker.date] year];
    int month  =    [[calendar components:NSMonthCalendarUnit fromDate:viewController.datePicker.date] month];
    int day    =    [[calendar components:NSDayCalendarUnit fromDate:viewController.datePicker.date] day];
    NSString* title = [NSString stringWithFormat:@"%d-%d-%d", year, month, day];
    [self.Button_Birth setTitle:title forState:UIControlStateNormal];
}


-(void)datePickerCancel:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:DatePicker_Birth];
}

#pragma mark - SBTableAlertDataSource

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell.textLabel setText:[self getCellText:indexPath.row]];
	
	return cell;
}


- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
    switch (tableAlert.view.tag) {
        case 0: // SCHOOL
            return 11;
        case 1: // CHANNEL
            return 3;
            
        default:
            return 0;
    }
}

#pragma mark - SBTableAlertDelegate

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    [self setButtonText:index];
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[tableAlert release];
}

#pragma mark - Class Methods

- (void) postFormData {
    _post_success = false;
    @try {
        
        NSDictionary* jsonDict = 
            [[NSDictionary alloc] initWithObjectsAndKeys:
            //inquiryDate, @"InquiryDate",
            TextField_Name.text, @"Name",
            TextField_Mobile.text, @"Mobile",
            TextField_Email.text, @"Email",
            TextField_Promoter.text, @"Promoter",
            Button_Birth.titleLabel.text, @"Birth",
            _currentChannelCode, @"ChannelCode",
            _currentSchoolCode, @"SchoolCode",
            TextView_Comment.text, @"Comment",
            TextField_VisitTime.text, @"VisitTime",
            TextField_MarketPlace.text, @"MarketPlace",
            nil];
        
        [postRequest cancel];
        [self setPostRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:__post_url]]];
        NSString* json = [jsonDict JSONRepresentation];
        if (!json) {
            Label_Error.text = @"JSON序列化错误，请重试，或联系maggie.xie@ef.com";
            _post_success = false;
            return;
        }
        [postRequest appendPostData:[[jsonDict JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [postRequest addRequestHeader:@"Accept" value:@"application/json"];
        [postRequest setRequestMethod:@"POST"];
        [postRequest setTimeOutSeconds:20];
        
        
        // Synchronous POST JSON
        [postRequest startSynchronous];
        
        [jsonDict release];
        
        NSError *error = [postRequest error];
        if (!error) {
            NSString *responseString = [postRequest responseString];
            if (responseString && [responseString caseInsensitiveCompare:@"true"] == NSOrderedSame) {
                Label_Error.text = @"";
                _post_success = true;
                return;
            }
        }
    } @catch (NSException* ex) {
        NSLog(@"EFKidsLeadsFormViewController::postFormData: Caught %@: %@", [ex name], [ex reason]);
    } @finally {
        // Clean up
    }
    Label_Error.text = @"数据提交错误，请重试！请联系maggie.xie@ef.com";
    _post_success = false;
}

- (void)flipToSubmittedView {
    if (ViewController_Submitted == nil) { 
        ViewController_Submitted = [[EFKidsLeadsSubmittedViewController alloc] 
                                    initWithNibName:@"EFKidsLeadsSubmittedViewController" 
                                    bundle:nil];
        NSLog(@"create submitted view instance");
    }
    ViewController_Submitted.ViewController_Form = self; 
    
    [UIView beginAnimations:@"flipping view" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    
    [self.view addSubview:ViewController_Submitted.view];
    [UIView commitAnimations];

}

- (void) clearForm {
    [TextField_Name setText:@""];
    [TextField_Email setText:@""];
    [TextField_Mobile setText:@""];
    [TextField_MarketPlace setText:@""];
    [TextField_Promoter setText:@""];
    [TextField_VisitTime setText:@""];
    [TextView_Comment setText:@""];
    [Button_Birth setTitle:@"请选择出生年月" forState:UIControlStateNormal];
    [Button_School setTitle:@"请选择学校" forState:UIControlStateNormal];
    [Button_Channel setTitle:@"请选择Channel Code" forState:UIControlStateNormal];
}

- (void) initialize {
    
    // Init data
    _schoolCodeArray = [[NSArray alloc] initWithObjects:@"sh1", @"sh8", @"sh2", 
                        @"sh12", @"sh3", @"sh6", @"sh7", @"sh9", 
                        @"sh10", @"sh11", @"sh13", nil];
    _channelArray = [[NSArray alloc] initWithObjects:@"Fixed booth", @"Mobile booth", @"Mega booth", nil];
    _schoolDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                   
                   @"徐汇太原路中心", @"sh1", @"徐汇宜山路中心", @"sh8", 
                   @"浦东时代广场中心", @"sh2", @"金桥枣庄路中心", @"sh12", 
                   @"闵行仲盛商城中心", @"sh3", @"闵行顾戴路中心", @"sh6", 
                   @"中远两湾城", @"sh7", @"五角场中心", @"sh9", 
                   @"长宁百联西郊中心", @"sh10", @"黄浦西藏南路中心", @"sh11", 
                   @"中山公园中心", @"sh13",
                   nil];
    _alertType = NA;
    
    // Init controls
    [TextField_Name becomeFirstResponder];
}

- (void) setButtonText:(int)index {
    switch (_alertType) {
        case SCHOOL:
        {
            _currentSchoolCode = [_schoolCodeArray objectAtIndex:index];
            id school = [_schoolDict objectForKey:_currentSchoolCode];
            [Button_School setTitle:school forState:UIControlStateNormal];
        }
            break;
        case CHANNEL:{
            _currentChannelCode = [_channelArray objectAtIndex:index];
            [Button_Channel setTitle:_currentChannelCode forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
    

- (NSString*) getCellText:(int)index {
    switch (_alertType) {
        case SCHOOL:
        {
            id schoolCode = [_schoolCodeArray objectAtIndex:index];
            id school = [_schoolDict objectForKey:schoolCode];
            return school;
        }
        case CHANNEL:
        {
            id channel = [_channelArray objectAtIndex:index];
            return channel;
        }
            
        default:
            return @"";
    }
}

- (NSString*) getTableListViewTitle {
    switch (_alertType) {
        case SCHOOL:
            return @"请选择学校";
        case CHANNEL:
            return @"请选择Channel Code";
            
        default:
            return @"";
    }
}

- (void) showTableListView {
    SBTableAlert *alert;
    NSString* title;
    title = [self getTableListViewTitle];
    alert = [[SBTableAlert alloc] initWithTitle:title cancelButtonTitle:@"取消" messageFormat:nil];
	[alert setMaximumVisibleRows:6];
    
    switch (_alertType) {
        case SCHOOL:
            [alert.view setTag:0];
            break;
        case CHANNEL:
            [alert.view setTag:1];
            break;
            
        default:
            break;
    }
    
	[alert setDelegate:self];
	[alert setDataSource:self];
	
	[alert show];
}

- (NSString*)getSchoolCode:(int)index {
    id schoolCode = [_schoolCodeArray objectAtIndex:index];
    return [_schoolDict objectForKey:schoolCode];
}

#pragma Validation methods

- (NSString*)validateFormData {
    // Validate student name
    NSString* trimmedStr = [Helper trim:TextField_Name.text];
    if ([trimmedStr isEqualToString:(@"")] || [trimmedStr length] == 0) {
        return @"请输入学生姓名"; 
    }
    
    // Validate email
    trimmedStr = [Helper trim:TextField_Email.text];
    if ([trimmedStr isEqualToString:(@"")] || [trimmedStr length] == 0) {
        return @"请输入Email地址";
    }
    
    // TODO: Email regx validation
    if ([Helper IsEmailValid:trimmedStr] == NO) {
        return @"错误的Email格式";
    }
    
    // Validate mobile phone
    trimmedStr = [Helper trim:TextField_Mobile.text];
    if ([trimmedStr isEqualToString:(@"")] || [trimmedStr length] == 0) {
        return @"请输入手机号码"; 
    }
    
    // Mobile No has to be valid in China
    NSString* regexStr = @"^(13[0-9]|15[^4]|18[6|8|9])\\d{8}$";
    NSError* error;
    NSRegularExpression* regex = 
    [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    NSUInteger counter = 
    [regex numberOfMatchesInString:TextField_Mobile.text options:0 range:NSMakeRange(0, [TextField_Mobile.text length])];
    if (counter == 0) {
        return @"手机号格式错误";
    }
    
    NSString* tmp = @"请";
    
    if ([[Button_Birth.titleLabel.text substringToIndex:1] caseInsensitiveCompare:tmp] == NSOrderedSame) {
        return @"请选择出生年月";
    }
    if ([[Button_School.titleLabel.text substringToIndex:1] caseInsensitiveCompare:tmp] == NSOrderedSame) {
        return @"请选择学校";
    }
    if ([[Button_Channel.titleLabel.text substringToIndex:1] caseInsensitiveCompare:tmp] == NSOrderedSame) {
        return @"请选择Channel Code";
    }
    
    return @"";
}

@end
