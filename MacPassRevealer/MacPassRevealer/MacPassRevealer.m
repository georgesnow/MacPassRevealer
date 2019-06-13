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


@interface MPRMacPassRevealer () 


@property (strong) MPRHotKeys *registerHotKeys;
@property (strong) MPRStatusItem *statusItem;



@end


@implementation MPRMacPassRevealer


- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {
    self.registerHotKeys = [[MPRHotKeys alloc] init];
    [self registerHotKeys];
    self.statusItem = [[MPRStatusItem alloc] init];
    [self statusItem];
//    self.viewController = [[MPRViewController alloc] init];
//    [self viewController];
  }
  return self;
  }

@end
