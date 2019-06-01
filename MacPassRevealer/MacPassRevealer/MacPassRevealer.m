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
    _statusItem.menu.delegate = _statusItem.menu.delegate;
    [self _updateStatusBarMenu];
    
    _statusItem.button.action = _statusItem.menu.itemArray > 0 ? @selector(activateMacPass:) : @selector(itemClicked:);
    // TODO: Use scalable graphic (e.g. PDF)
    // TODO: Make hide dock icon user pref - needs refinement
    //[NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
  }
  return self;
}


- (void)createStatusBarItem{
  NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
  NSBundle *bundle = [NSBundle bundleForClass:self.class];
  _statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.button.image = [bundle imageForResource:@"Lock3"];
  _statusItem.button.target = self;
  
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

- (NSMenu *)createStatusBarMenu:(NSMenu *)menu {
  NSLog(@"made it to createStatusBarMenu");
  NSMenuItem *quitMacPass = [[NSMenuItem alloc] initWithTitle:@"Quit MacPass" action:@selector(quitMacPass:) keyEquivalent:@"quitMacPass"];
  [quitMacPass setTarget:self];
  [_statusItem.menu addItem:quitMacPass];
  [menu addItem:quitMacPass];

  return menu;
  
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

- (void)clearStatusMenu {
  NSLog(@"clearStatusMenu");
  _statusItem.menu = nil;
  [self performSelector:@selector(itemClicked:)];
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
    [self performSelector:@selector(activateMacPass:)];
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







