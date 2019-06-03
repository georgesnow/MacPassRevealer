//
//  MacPassRevealer.m
//  MacPassRevealer
//

//


#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"
#import "MPRHotKeys.h"





@interface MPRMacPassRevealer () 

@property (strong) MPRHotKeys *registerHotKeys;

@end


@implementation MPRMacPassRevealer



- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {
    //[self registerHotKeys];
    self.registerHotKeys = [[MPRHotKeys alloc] init];
    [self registerHotKeys];
    
  }
  return self;
  }
  



//

- (IBAction)activateMacPass:(id)sender {
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    
  }
}

- (IBAction)quitMacPass:(id)sender {
  [[NSApplication sharedApplication] terminate:self];
  
  return;
}




@end







