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
#import "MPRViewController.h"
//#import "MPRView.h"
#import "MPRMenu.h"

@interface MPRStatusItem ()


@property (strong) NSStatusItem *statusItem;
@property (strong) MPRViewController *viewController;

@end

@implementation MPRStatusItem
//@synthesize clickMask;

- (instancetype)init {
  self = [super init];
  if(self)
  {
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    // TODO: Use scalable graphic (e.g. PDF)
    self.statusItem.button.image = [bundle imageForResource:@"Lock3"];
    
    
    self.viewController = [[MPRViewController alloc] init];
    [self viewController];

    self.statusItem.button.action = @selector(itemClicked:);
//    [self.statusItem.button sendActionOn:(NSEventMaskFromType(NSEventTypeRightMouseDown | NSEventTypeLeftMouseDown | NSEventTypeKeyDown))];
    self.statusItem.button.target = self;
    [self statusItem];
    
    
  }
  return self;
}
- (void)keyDown:(NSEvent *)theEvent {
  // Arrow keys are associated with the numeric keypad
  if ([theEvent modifierFlags] & NSEventModifierFlagControl) {
    NSLog(@"control click");

    
  } else {
    NSLog(@"no mask detected");

  }
}



- (void)activateMacPass {
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;

  if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    NSWindow *window = [[[NSApplication sharedApplication] currentEvent] window];
    NSRect rect = [window frame];
    
    NSLog(@"%f",rect.origin.y);
  }
}
-(void)menuDidClose:(NSNotification *)notification{
  NSLog(@"menudidclose");
  self.statusItem.menu = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMenuDidEndTrackingNotification object:notification.object];
  
}

-(NSMenu *)menuForEvent:(id)sender {
  NSLog(@"_updateStatusBarMenu");
  NSMenu *menu = [[NSMenu alloc] init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidClose:) name:NSMenuDidEndTrackingNotification object:self.statusItem.menu];
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
//  NSLog(@"theEvent tag %@", theEvent);
 
  NSEvent *event = [NSApp currentEvent];
//  clickMask = [theEvent modifierFlags] & NSEventModifierFlagOption;
//  [self.statusItem.button menuForEvent:theEvent];
//  NSLog(@"theEvent %id",theEvent);
//  NSEventMask eventType = [event associatedEventsMask];
//  NSLog(@"eventType %lu", (unsigned long)eventType);
//  NSLog(@"eventype other %llu", eventType);
  
//  if (eventType = (NSEventTypeRightMouseUp | NSEventTypeRightMouseDown) {
//    NSLog(@"right click");
//
//  }

//  clickMask = [event modifierFlags] & NSEventModifierFlagOption;
//  NSLog(@"controlclick value %hhd", clickMask);
  if (([event modifierFlags] & NSEventModifierFlagOption)) {
    NSLog(@"option click detected");
    [self performSelector:@selector(quitMacPass:)];
  }
  else if ((([event modifierFlags] & NSEventModifierFlagControl))) {
    NSLog(@"control click detected");

//    
    
    NSPopover *thePopover = [[NSPopover alloc] init];
//    thePopover.contentViewController = viewController;
    thePopover.contentViewController = self.viewController;
//    [thePopover setContentViewController:viewController];
    [thePopover setContentSize:CGSizeMake(300, 300)]; //150,100
    [thePopover setBehavior:NSPopoverBehaviorTransient];
    [thePopover setAnimates:YES];
    [thePopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSRectEdgeMinY];//NSMaxYEdge
//    [thePopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    
//    [self.statusItem.button performSelector:@selector(menuForEvent:) withObject:(event)];
//    self.statusItem.button.menu = [self updateStatusBarMenu];
    //self.statusItem.menu = [self updateStatusBarMenu];

    
    
//    [self.statusItem.button menuForEvent:(event)];
   
    
    
    
//    NSRect entryRect = [sender convertRect:
//                                    toView:[[self contentView]];
//    [thePopover showRelativeToRect:_statusItem
//                              ofView:_statusItem
//                       preferredEdge:NSMinYEdge];
    
  
  
  }
  else {
    NSLog(@"regularclick detected");
    [self performSelector:@selector(activateMacPass)];
  }
}

@end
