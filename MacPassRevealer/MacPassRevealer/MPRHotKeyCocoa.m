//
//  MPRHotKeyCocoa.m
//  MacPassRevealer
//
//  Created by George Snow on 6/25/19.
//  Copyright © 2019 George Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "MPRHotKeyCocoa.h"



@interface MPRHotKeyCocoa ()
@property(readonly) unsigned short keyCode;
@property id globalEventHandler;
@property id localEventHandler;
@end

@implementation MPRHotKeyCocoa

- (instancetype)init {
  
  self = [super init];
  
  if(self)
  {
    [self registerCocoaKeys];
    
  }
  return self;
}

-(void)registerCocoaKeys {
  
   self.globalEventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSEventMaskKeyDown) handler:^(NSEvent *event){
    ///code
    int keyCodeNeeded = [event keyCode];
    //NSLog(@"keyCodedNeeded %d", keyCodeNeeded);
    //NSLog(@"%@", event.characters);
//    if (self->_keyCode == 50)
    if (keyCodeNeeded == 50 && (([event modifierFlags] & NSEventModifierFlagCommand)) &&  (([event modifierFlags] & NSEventModifierFlagOption))) {
      NSLog(@"global -got the keycode / cntrl+opt+~ and control key");

      [NSApplication.sharedApplication activateIgnoringOtherApps:YES];

    }

  }];
  
  self.localEventHandler = [NSEvent addLocalMonitorForEventsMatchingMask:(NSEventMaskKeyDown) handler:^NSEvent* (NSEvent *localEvent) {
    ///code
    int keyCodeNeeded = [localEvent keyCode];
    //NSLog(@"keyCodedNeeded %d", keyCodeNeeded);
    //NSLog(@"%@", event.characters);
    if (keyCodeNeeded == 50 && (([localEvent modifierFlags] & NSEventModifierFlagCommand)) &&  (([localEvent modifierFlags] & NSEventModifierFlagOption))) {
      NSLog(@"local -got the keycode  cntrl+opt+~and control key");
      [NSApplication.sharedApplication hide:nil];
      
    }
    return localEvent;
  }];
}



- (void) dealloc {
  
  [NSEvent removeMonitor:self.globalEventHandler];
  [NSEvent removeMonitor:self.localEventHandler];
}
@end

