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
  //NSController *controller = (userData *);
  NSString *macPass = @"MacPass.app";
  //NSString *macPassBundle = @"com.hicknhacksoftware.MacPass";
  int l = hkCom.id;
  //NSWorkspace *workspaceApp = [NSWorkspace sharedWorkspace];
  
  //NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
  //NSPredicate *activePredicate = [NSPredicate predicateWithFormat:@"active == YES"];
  //NSLog(@"activePredicate: %@", activePredicate);
  //NSArray *currentAppArray = [runningApplications filteredArrayUsingPredicate:activePredicate];
  //NSString *currentApp = currentAppArray[0];
  //NSLog(@"currentApp: %@", currentApp);
  NSString *frontApp = NSWorkspace.sharedWorkspace.frontmostApplication.localizedName;
  NSLog(@"frontApp: %@", frontApp);
  
  
  switch (l) {
    case 1:
      
      //[NSApp unhideAllApplications:sender];
      //[NSApp unhide:macPass];
      
      NSLog(@"frontApp: %@", frontApp);
      //      [[NSWorkspace sharedWorkspace] launchApplication:macPass];
      //      if ([frontApp isEqual: @"Safari"]) {
      //        break;
      //      }
      
      if ([frontApp  isEqual: @"MacPass"]) {
        //NSLog(@"hey the current bundle is macpass");
        [NSApp hide:macPass];
        
        
        //break;
      }
      else {
        //[NSApp unhide:macPass];
        //[[NSWorkspace sharedWorkspace] launchApplication:macPass];
        [NSApp activateIgnoringOtherApps:YES];
        //break;
      }
      break;
    case 2:
      
      //[NSApp unhideAllApplications:sender];
      //[NSApp hide:macPass];
      //[[NSWorkspace sharedWorkspace] launchApplication:macPass];
      break;
      
  }
  return noErr;
}

- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  [self registerHotKeys];
  return self;
}

-(void)macPassActive {
  NSString *frontApp = NSWorkspace.sharedWorkspace.frontmostApplication.localizedName;
  NSString *macPass = @"MacPass.app";
  if ([frontApp  isEqual: @"MacPass"]) {
    //NSLog(@"hey the current bundle is macpass");
    self ? [NSApp hide:macPass] : [NSApp activateIgnoringOtherApps:YES];
    
  }
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
  RegisterEventHotKey(50, controlKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk2';
  gMyHotKeyID.id=2;
  RegisterEventHotKey(53, controlKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
}




@end







