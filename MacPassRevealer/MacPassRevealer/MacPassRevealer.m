//
//  MacPassRevealer.m
//  MacPassRevealer
//

//


#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"
#import "MPRHotKeys.h"
#import "MPRStatusItem.h"
#import "MPRViewController.h"
#import "MPRView.h"
#import "MPRHotKeyCocoa.h"

@interface MPRMacPassRevealer () 


@property (strong) MPRHotKeys *registerHotKeys;
@property (strong) MPRStatusItem *statusItem;
@property (strong) MPRHotKeyCocoa *registerCocoaKeys;


@end


@implementation MPRMacPassRevealer


- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {
//    self.registerHotKeys = [[MPRHotKeys alloc] init];
//    [self registerHotKeys];
    self.statusItem = [[MPRStatusItem alloc] init];
    [self statusItem];
    self.registerCocoaKeys = [[MPRHotKeyCocoa alloc] init];
    [self registerCocoaKeys];
    // TODO: Make hide dock icon user pref - needs refinement
    //[NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
//    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
  }
  return self;
}
-(void)dealloc {

  [MPRHotKeyCocoa dealloc];
  
}

@end
