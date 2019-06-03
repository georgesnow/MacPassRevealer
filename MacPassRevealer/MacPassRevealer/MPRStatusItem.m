//
//  MPRStatusItem.m
//  MacPassRevealer
//
//  Created by George Snow on 6/3/19.
//  Copyright © 2019 HicknHack Software GmbH. All rights reserved.
//
#import "Cocoa/Cocoa.h"
#import <Foundation/Foundation.h>
#import "MPRStatusItem.h"

@interface MPRStatusItem ()

@property (strong) NSStatusItem *statusItem;

@end

@implementation MPRStatusItem


- (instancetype)init {
  self = [super init];
  if(self)
  {
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    // TODO: Use scalable graphic (e.g. PDF)
    self.statusItem.button.image = [bundle imageForResource:@"Lock3"];
    self.statusItem.button.action = @selector(itemClicked:);
    self.statusItem.button.target = self;
    [self statusItem];
    
  }
  return self;
}


- (void)activateMacPass {
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  NSEvent *event = [NSApp currentEvent];
  if([event modifierFlags] & NSEventModifierFlagOption) {
    //NSLog(@"hey option key and click");
    [NSApplication.sharedApplication terminate:self];
  }
  else if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}
-(void)menuDidClose:(NSNotification *)notification{
  NSLog(@"menudidclose");
  _statusItem.menu = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMenuDidEndTrackingNotification object:notification.object];
  
}

-(NSMenu *)_updateStatusBarMenu{
  NSLog(@"_updateStatusBarMenu");
  NSMenu *menu = [[NSMenu alloc] init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidClose:) name:NSMenuDidEndTrackingNotification object:_statusItem.menu];
  NSMenuItem *quitMacPass = [[NSMenuItem alloc] initWithTitle:@"Quit MacPass" action:@selector(quitMacPass:) keyEquivalent:@"quitMacPass"];
  
  [quitMacPass setTarget:self];
  [menu addItem:quitMacPass];
  return menu;
}

- (void)quitMacPass:(id)sender {
  [[NSApplication sharedApplication] terminate:self];
  
  return;
}

- (void)itemClicked:(id)sender {
  //_statusItem.menu = nil;
  NSEvent *event = [NSApp currentEvent];
  
  
  if (([event modifierFlags] & NSEventModifierFlagOption)) {
    NSLog(@"option click detected");
    [self performSelector:@selector(quitMacPass:)];
  }
  else if (([event modifierFlags] & NSEventModifierFlagControl)) {
    NSLog(@"control click detected");
    _statusItem.menu = [self _updateStatusBarMenu];
  }
  else {
    NSLog(@"regularclick detected sending to actiavetMacPass");
    [self performSelector:@selector(activateMacPass)];
  }
  
  
  
}

@end

