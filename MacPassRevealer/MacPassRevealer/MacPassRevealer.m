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
    [self createStatusBarItem];
    //self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    //NSBundle *bundle = [NSBundle bundleForClass:self.class];
    // TODO: Use scalable graphic (e.g. PDF)
    //self.statusItem.button.image = [bundle imageForResource:@"Lock3"];
    //self.statusItem.button.toolTip = @"Option+Click Quits MacPass";
    //self.statusItem.button.action = @selector(itemClicked:);
    //self.statusItem.button.target = self;
    
    // TODO: Make hide dock icon user pref - needs refinement
    //[NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
  }
  return self;
}


- (void)createStatusBarItem {
  NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
  NSBundle *bundle = [NSBundle bundleForClass:self.class];
  _statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.button.image = [bundle imageForResource:@"Lock3"];
  _statusItem.button.action = @selector(itemClicked:);
  _statusItem.button.target = self;
  //_statusItem.menu = [self createStatusBarMenu];
  
}

- (void)activateMacPass:(id)sender {
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}

- (NSMenu *)createStatusBarMenu {

   NSMenu *menu = [[NSMenu alloc] init];
  
  NSMenuItem *quitMacPass = [[NSMenuItem alloc] initWithTitle:@"Quit MacPass" action:@selector(quitMacPass:) keyEquivalent:@""];
  [quitMacPass setTarget:self];
  [menu addItem:quitMacPass];
  
  return menu;
  
}

- (void)quitMacPass:(id)sender {
  [[NSApplication sharedApplication] terminate:self];
  
  return;
}

- (void)itemClicked:(id)sender {
  NSLog(@"item clicked triggered");
  //Look for option click display menu
  //[[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
  NSEvent *event = [NSApp currentEvent];
  if([event modifierFlags] & NSEventModifierFlagOption) {
    NSLog(@"first option+regular click");
    _statusItem.menu = [self createStatusBarMenu];
  }
  else {
    [self performSelector:(@selector(activateMacPass:))];
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







