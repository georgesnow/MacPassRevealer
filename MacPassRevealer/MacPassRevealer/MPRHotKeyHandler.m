//
//  MPRHotKeyHandler.m
//  MacPassRevealer
//
//  Created by George Snow on 7/16/19.
//  Copyright © 2019 George Snow. All rights reserved.
//


#import "MPRHotKeyHandler.h"

#import "MPSettingsHelper.h"

#import "DDHotKeyCenter.h"
#import "DDHotKey+MacPassAdditions.h"
#import "MacPassRevealer.h"

NSString *const kMPSettingsKeyHotKeyDataKey           = @"kMPSettingsKeyHotKeyDataKey";

@interface MPHotKeyHandler ()

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) NSData *hotKeyData;
@property (strong) DDHotKey *registredHotKey;

@end

@implementation MPHotKeyHandler

-(instancetype)init {
  self = [super init];
  if (self) {
    _enabled = NO;
    
//    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
//    _enabled = [defaultsController boolForKey:kMPRSettingsKeyHotKey];
    
    [self bind:NSStringFromSelector(@selector(enabled))
      toObject:NSUserDefaultsController.sharedUserDefaultsController
   withKeyPath:[MPSettingsHelper defaultControllerPathForKey:kMPRSettingsKeyHotKey]
       options:nil];
    [self bind:NSStringFromSelector(@selector(hotKeyData))
      toObject:NSUserDefaultsController.sharedUserDefaultsController
   withKeyPath:[MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyHotKeyDataKey]
       options:nil];
    
    //[self _registerHotKey];
    
//    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
//    BOOL hotkeyEnabled = [defaultsController boolForKey:kMPRSettingsKeyHotKey];
//    if (hotkeyEnabled){
//      NSLog(@"hot key enabled handler");
//      [self _registerHotKey];
//    }
//    else {
//      NSLog(@"hot key disable handler");
//    }
    
  }
  return self;
}

- (void)dealloc {
  
  [self unbind:NSStringFromSelector(@selector(hotKeyData))];
}

- (void)setEnabled:(BOOL)enabled {
  if(_enabled != enabled) {
    _enabled = enabled;
    self.enabled ? [self _registerHotKey] : [self _unregisterHotKey];
  }
}

- (void)setHotKeyData:(NSData *)hotKeyData {
  if(![_hotKeyData isEqualToData:hotKeyData]) {
    [self _unregisterHotKey];
    _hotKeyData = [hotKeyData copy];
    if(self.enabled) {
      [self _registerHotKey];
    }
  }
}

- (void)_registerHotKey {
  if(!self.hotKeyData) {
    return;
  }
  __weak MPHotKeyHandler *welf = self;
  DDHotKeyTask aTask = ^(NSEvent *event) {
    [welf _didPressHotKey];
  };
  self.registredHotKey = [[DDHotKeyCenter sharedHotKeyCenter] registerHotKey:[DDHotKey hotKeyWithKeyData:self.hotKeyData task:aTask]];
  
}

- (void)_unregisterHotKey {
  if(self.registredHotKey) {
    [[DDHotKeyCenter sharedHotKeyCenter] unregisterHotKey:self.registredHotKey];
    self.registredHotKey = nil;
  }
}
- (void)_didPressHotKey {
  NSLog(@"holy smokes hotkey worked!");
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  
  NSLog(@"frontApp: %@", frontMostApplication);
  if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
  
}

@end




