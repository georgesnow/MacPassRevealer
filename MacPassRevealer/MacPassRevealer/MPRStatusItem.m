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
static NSString *const MPRMacPassBundleIdentifier = @"com.hicknhacksoftware.MacPass";

@interface MPRStatusItem ()


@property (strong) NSStatusItem *statusItem;
@property (strong) MPRViewController *viewController;

@end

@implementation MPRStatusItem
//@synthesize clickMask;
BOOL popoverOpen = NO;

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
    
//    [self.statusItem.button sendActionOn:(NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown|NSEventMaskLeftMouseUp|NSEventMaskRightMouseUp)];
//    [self.statusItem.button sendActionOn:(NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown)];
//    [self.statusItem.button sendActionOn:(NSEventMaskFromType(NSEventTypeRightMouseDown | NSEventTypeLeftMouseDown | NSEventTypeKeyDown))];
    self.statusItem.button.target = self;
    [self statusItem];
    
    
  }
  return self;
}
//-(void)dealloc {
//
//
//}

- (void)keyDown:(NSEvent *)theEvent {
  // Arrow keys are associated with the numeric keypad
  if ([theEvent modifierFlags] & NSEventModifierFlagControl) {
    NSLog(@"control click");

    
  } else {
    NSLog(@"no mask detected");

  }
}



- (void)activateMacPass {
    NSLog(@"activateMaPass");
    NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
    NSRunningApplication *macPass = NSRunningApplication.currentApplication;
    NSLog(@"frontMost %@", frontMostApplication);
    NSLog(@"currentApp %@", macPass);
    if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
        NSLog(@"Hide MacPass");
        
//        [NSApplication.sharedApplication hide:nil];
        [NSWorkspace.sharedWorkspace.menuBarOwningApplication hide];
    }
    else {
      NSLog(@"Show and Activate MacPass");
      [NSApplication.sharedApplication unhide:nil];
      [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
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
  //need to tweak right and left click behavoir and refine if statements
  
  //_statusItem.menu = nil;
//  NSLog(@"theEvent tag %@", theEvent);
 
  NSEvent *event = [NSApp currentEvent];
  
  NSLog(@"mouse event type %lu", (unsigned long)event.type);
  const NSUInteger buttonMask = [NSEvent pressedMouseButtons];
  
  NSLog(@"buttonMask %lu", (unsigned long)buttonMask);
  BOOL primaryDown = ((buttonMask & (1 << 0)) != 0);
  BOOL secondaryDown = ((buttonMask & (1 << 1)) != 0);
  NSLog(@"secondaryDown %hhd", secondaryDown);
  NSLog(@"primaryDown %hhd", primaryDown);
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
//    NSRect *theRect = NSInsetRect(sender, 4.0f, 3.0f);
    
    thePopover.contentViewController = self.viewController;
//    [thePopover setContentViewController:viewController];
    [thePopover setContentSize:CGSizeMake(310, 124)]; //150,100
    
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
  else  {
    NSLog(@"regularclick detected");
    [self performSelector:@selector(activateMacPass)];
  }
}

@end

//
//- (void)itemClicked:(id)sender {
//    //need to tweak right and left click behavoir and refine if statements
//
//    //_statusItem.menu = nil;
//    //  NSLog(@"theEvent tag %@", theEvent);
//
//    NSEvent *event = [NSApp currentEvent];
//
//    NSLog(@"mouse event type %lu", (unsigned long)event.type);
//    const NSUInteger buttonMask = [NSEvent pressedMouseButtons];
//
//    NSLog(@"buttonMask %lu", (unsigned long)buttonMask);
//    BOOL primaryDown = ((buttonMask & (1 << 0)) != 0);
//    BOOL secondaryDown = ((buttonMask & (1 << 1)) != 0);
//    NSLog(@"secondaryDown %hhd", secondaryDown);
//    NSLog(@"primaryDown %hhd", primaryDown);
//    //  clickMask = [theEvent modifierFlags] & NSEventModifierFlagOption;
//    //  [self.statusItem.button menuForEvent:theEvent];
//    //  NSLog(@"theEvent %id",theEvent);
//    //  NSEventMask eventType = [event associatedEventsMask];
//    //  NSLog(@"eventType %lu", (unsigned long)eventType);
//    //  NSLog(@"eventype other %llu", eventType);
//
//    //  if (eventType = (NSEventTypeRightMouseUp | NSEventTypeRightMouseDown) {
//    //    NSLog(@"right click");
//    //
//    //  }
//
//    //  clickMask = [event modifierFlags] & NSEventModifierFlagOption;
//    //  NSLog(@"controlclick value %hhd", clickMask);
//    if (([event modifierFlags] & NSEventModifierFlagOption) && primaryDown) {
//        NSLog(@"option click detected");
//        [self performSelector:@selector(quitMacPass:)];
//    }
//    else if ((([event modifierFlags] & NSEventModifierFlagControl)) && primaryDown) {
//        NSLog(@"control click detected");
//
//        //
//
//        NSPopover *thePopover = [[NSPopover alloc] init];
//        //    thePopover.contentViewController = viewController;
//        //    NSRect *theRect = NSInsetRect(sender, 4.0f, 3.0f);
//
//        thePopover.contentViewController = self.viewController;
//        //    [thePopover setContentViewController:viewController];
//        [thePopover setContentSize:CGSizeMake(310, 124)]; //150,100
//
//        [thePopover setBehavior:NSPopoverBehaviorTransient];
//
//        [thePopover setAnimates:YES];
//        [thePopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSRectEdgeMinY];//NSMaxYEdge
//
//        //    [thePopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
//
//        //    [self.statusItem.button performSelector:@selector(menuForEvent:) withObject:(event)];
//        //    self.statusItem.button.menu = [self updateStatusBarMenu];
//        //self.statusItem.menu = [self updateStatusBarMenu];
//
//
//
//        //    [self.statusItem.button menuForEvent:(event)];
//
//
//
//
//        //    NSRect entryRect = [sender convertRect:
//        //                                    toView:[[self contentView]];
//        //    [thePopover showRelativeToRect:_statusItem
//        //                              ofView:_statusItem
//        //                       preferredEdge:NSMinYEdge];
//
//
//
//    }
//    else if (secondaryDown && !primaryDown && !(([event modifierFlags] & NSEventModifierFlagControl))){
//        NSLog(@"right mouse detected");
//        NSPopover *thePopover = [[NSPopover alloc] init];
//        //    thePopover.contentViewController = viewController;
//        //    NSRect *theRect = NSInsetRect(sender, 4.0f, 3.0f);
//
//        thePopover.contentViewController = self.viewController;
//        //    [thePopover setContentViewController:viewController];
//        [thePopover setContentSize:CGSizeMake(310, 124)]; //150,100
//
//        [thePopover setBehavior:NSPopoverBehaviorTransient];
//        [thePopover setAnimates:YES];
//        [thePopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSRectEdgeMinY];
//    }
//    else  {
//        NSLog(@"regularclick detected");
//        [self performSelector:@selector(activateMacPass)];
//        }
