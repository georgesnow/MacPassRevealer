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
 

@end







