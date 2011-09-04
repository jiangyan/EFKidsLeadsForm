//
//  Helper.h
//  EFKidsLeadsForm
//
//  Created by yan jiang on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject{
}
// Methods
+ (NSString*) ReturnSplitSecondString:(NSString*)str;
+ (NSString*)trim:(NSString*)str;
+ (BOOL)IsEmailValid:(NSString*)email;

@end
