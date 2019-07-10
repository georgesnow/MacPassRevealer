//
//  MPRStatusItem.m
//  MacPassRevealer
//
//  Created by George Snow on 6/3/19.
//  Copyright © 2019 George Snow. All rights reserved.
//
#import "Cocoa/Cocoa.h"
#import <Foundation/Foundation.h>
#import "MPRStatusItem.h"
#import "MPDocument.h"

@interface MPRStatusItem ()

@property (strong) NSStatusItem *statusItem;
@property (weak) MPDocument *currentDoc;
@property (readonly) BOOL queryDocumentOpen;

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
    [self.statusItem.button sendActionOn:(NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown|NSEventMaskLeftMouseUp|NSEventMaskRightMouseUp)];
    self.statusItem.button.action = @selector(itemClicked:);
    self.statusItem.button.target = self;
    [self statusItem];
    
  }
  return self;
}


- (void)activateMacPass {
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  
  if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}
-(void)menuDidClose:(NSNotification *)notification{
  NSLog(@"menudidclose");
  self.statusItem.menu = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMenuDidEndTrackingNotification object:notification.object];
  
}

-(NSMenu *)updateStatusBarMenu{
  NSLog(@"_updateStatusBarMenu");
  NSMenu *menu = [[NSMenu alloc] init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidClose:) name:NSMenuDidEndTrackingNotification object:self.statusItem.menu];
  NSMenuItem *quitMacPass = [[NSMenuItem alloc] initWithTitle:@"Quit MacPass" action:@selector(quitMacPass:) keyEquivalent:@"quitMacPass"];
  NSMenuItem *lockDB = [[NSMenuItem alloc]initWithTitle:@"Lock" action:@selector(lockOpenDatabase:) keyEquivalent:@"lockOpenDatabase"];
  [quitMacPass setTarget:self];
  [lockDB setTarget:self];
  [menu addItem:lockDB];
  [menu addItem:quitMacPass];
  
  return menu;
  
}

- (void)quitMacPass:(id)sender {
  [[NSApplication sharedApplication] terminate:self];
  return;
}

- (BOOL)queryDocumentOpen {
  return self.currentDoc && !self.currentDoc.encrypted;
}

-(void)lockOpenDatabase:(id)sender{
  NSArray *documents = [NSDocumentController sharedDocumentController].documents;
  MPDocument __weak *lastDocument;
  for(MPDocument *document in documents) {
    if(document.encrypted) {
      NSLog(@"Database is Locked: %@", document.displayName);
      
      continue;
    }
    lastDocument = document;
  [lastDocument lockDatabase:nil];
  
//  [_currentDoc lockDatabase:nil];
  NSLog(@"lock db %@", _currentDoc);

  NSLog(@"attempted lock");
  }
}

- (void)itemClicked:(id)sender {
  //_statusItem.menu = nil;
  NSEvent *event = [NSApp currentEvent];
  NSLog(@"mouse event type %lu", (unsigned long)event.type);
  unsigned long mouseEventType = event.type;
  
  
  if (([event modifierFlags] & NSEventModifierFlagOption) && mouseEventType == 2) {
    NSLog(@"option click detected");
    [self performSelector:@selector(quitMacPass:)];
  }
  else if (((([event modifierFlags] & NSEventModifierFlagControl)) && mouseEventType == 2) | (mouseEventType == 3)){
    NSLog(@"control click detected");
    self.statusItem.menu = [self updateStatusBarMenu];
    [self.statusItem menu];
    
  }
  else if (mouseEventType == 2) {
    NSLog(@"regularclick detected");
    [self performSelector:@selector(activateMacPass)];
  }
}

@end
