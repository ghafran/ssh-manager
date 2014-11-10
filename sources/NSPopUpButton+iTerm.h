//
//  NSPopUpButton+iTerm.h
//  iTerm
//
//  Created by George Nachman on 4/7/14.
//
//

#import <Cocoa/Cocoa.h>

@interface NSPopUpButton (iTerm)

// Add profile names and select the indicated one.
- (void)populateWithProfilesSelectingGuid:(NSString *)selectedGuid;

@end
