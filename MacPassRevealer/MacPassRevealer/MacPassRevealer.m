//
//  MacPassRevealer.m
//  MacPassRevealer
//
//  Copyright © 2019 George Snow. All rights reserved.
//


#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"
#import "MPRHotKeys.h"
#import "MPRStatusItem.h"
#import "MPRHotKeyCocoa.h"

//id eventHandlerGlobal;
//id eventHandlerLocal;

@interface MPRMacPassRevealer () 

@property (strong) MPRHotKeys *registerHotKeys;
@property (strong) MPRStatusItem *statusItem;
@property (strong) MPRHotKeyCocoa *registerCocoaKeys;
@end


@implementation MPRMacPassRevealer

+(void)initialize{
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"HotKey" : @YES, @"ShowStatusIcon" : @YES}];
}

- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {
//    self.registerHotKeys = [[MPRHotKeys alloc] init];
//    [self registerHotKeys];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"HotKey"];
//    [defaults setBool:YES forKey:@"ShowStatusIcon"];
    [defaults synchronize];
    BOOL hotkeyEnabled = [defaults boolForKey:@"HotKey"];
    NSLog(@"hot key enabled %hhd", hotkeyEnabled);
    
    self.statusItem = [[MPRStatusItem alloc] init];
    [self statusItem];
    self.registerCocoaKeys = [[MPRHotKeyCocoa alloc] init];
    [self registerCocoaKeys];
    

  }
  return self;
}
-(void)dealloc {
  
  [MPRHotKeyCocoa dealloc];
  
}

@end







