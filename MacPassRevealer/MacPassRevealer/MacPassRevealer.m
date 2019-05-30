//
//  MacPassRevealer.m
//  MacPassRevealer
//

//

#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"

static NSString *const MPRMacPassBundleIdentifier = @"com.hicknhacksoftware.MacPass";
static int const MPRHotKeyId1 = 1;
static int const MPRHotKeyId2 = 2;

@interface MPRMacPassRevealer ()

@property (strong) NSStatusItem *statusItem;

@end

@implementation MPRMacPassRevealer

//hotkey
OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
  EventHotKeyID hkCom;
  
  GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkCom), NULL, &hkCom);
  
  int hotKeyId = hkCom.id;
  
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  
  NSLog(@"frontApp: %@", frontMostApplication);

  switch (hotKeyId) {
    case MPRHotKeyId1:
      //NSLog(@"frontApp and other hotkey: %@", frontMostApplication);
      break;
    case MPRHotKeyId2: {
      if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
        [NSApplication.sharedApplication hide:nil];
      }
      else {
        [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
      }
      break;
    }
  }
  return noErr;
}

- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {
    [self registerHotKeys];
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    // TODO: Use scalable graphic (e.g. PDF)
    self.statusItem.button.image = [bundle imageForResource:@"Lock3"];
    self.statusItem.button.action = @selector(activateMacPass);
    self.statusItem.button.target = self;
    // TODO: Make hide dock icon user pref - needs refinement
    //[NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
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

- (void)registerHotKeys {
  EventHotKeyRef gMyHotKeyRef;
  EventHotKeyID gMyHotKeyID;
  EventTypeSpec eventType;
  eventType.eventClass=kEventClassKeyboard;
  eventType.eventKind=kEventHotKeyPressed;

  InstallApplicationEventHandler(&OnHotKeyEvent, 1, &eventType, NULL, NULL);
  gMyHotKeyID.signature='htk1';
  gMyHotKeyID.id=MPRHotKeyId1;
  //Test shortcut - uncomment when testing the other switch case
  //RegisterEventHotKey(50, controlKey+cmdKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk2';
  gMyHotKeyID.id=MPRHotKeyId2;
  RegisterEventHotKey(50, controlKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}


@end
