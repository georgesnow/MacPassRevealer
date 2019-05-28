//
//  MacPassRevealer.m
//  MacPassRevealer
//

//

#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"


@interface MPPlugin ()

@property(readonly, strong) NSRunningApplication *frontmostApplication;

@end




@implementation theHotKey

//hotkey
OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
  EventHotKeyID hkCom;
  
  GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkCom), NULL, &hkCom);

  NSString *macPass = @"MacPass.app";

  int l = hkCom.id;

  NSString *frontApp = NSWorkspace.sharedWorkspace.frontmostApplication.localizedName;
  NSLog(@"frontApp: %@", frontApp);
  
  
  switch (l) {
    case 1:
      NSLog(@"frontApp: %@", frontApp);

      break;
    case 2:
      if (2) {
        //NSLog(@"hey the current bundle is macpass");
        [frontApp  isEqual: @"MacPass"] ? [NSApp hide:macPass] : [NSApp activateIgnoringOtherApps:YES];
      }
      break;
      
  }
  return noErr;
}

- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  [self registerHotKeys];
  return self;
}



-(void)registerHotKeys {
  EventHotKeyRef gMyHotKeyRef;
  EventHotKeyID gMyHotKeyID;
  EventTypeSpec eventType;
  eventType.eventClass=kEventClassKeyboard;
  eventType.eventKind=kEventHotKeyPressed;
  
  
  
  InstallApplicationEventHandler(&OnHotKeyEvent, 1, &eventType, NULL, NULL);
  gMyHotKeyID.signature='htk1';
  gMyHotKeyID.id=1;
  //RegisterEventHotKey(53, controlKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk2';
  gMyHotKeyID.id=2;
  RegisterEventHotKey(50, controlKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
}




@end







