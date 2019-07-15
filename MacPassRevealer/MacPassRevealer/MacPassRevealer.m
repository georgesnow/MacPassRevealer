//
//  MacPassRevealer.m
//  MacPassRevealer
//
//  Copyright © 2019 George Snow. All rights reserved.
//


#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"
#import "MPRHotKeys.h"
#import "MPRStatusItem.h"
//#import "MPRHotKeyCocoa.h"
#import "MPRSettingsViewController.h"

//id eventHandlerGlobal;
//id eventHandlerLocal;

NSString *const kMPRSettingsKeyShowMenuItem           = @"kMPSettingsKeyShowMenuItem";
NSString *const kMPRSettingsKeyHotKey                 = @"kMPRSettingsKeyHotKey";

@interface MPRMacPassRevealer () 

@property (strong) MPRSettingsViewController *settingsViewController;

@property (strong) MPRHotKeys *registerHotKeys;
@property (strong) MPRStatusItem *statusItem;
//@property (strong) MPRHotKeyCocoa *registerCocoaKeys;

@property (nonatomic) BOOL showStatusItem;
@property (nonatomic) BOOL hotkeyEnabled;

@end


@implementation MPRMacPassRevealer

@synthesize settingsViewController = _settingsViewController;

+(void)initialize{
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kMPRSettingsKeyShowMenuItem : @YES, kMPRSettingsKeyHotKey : @YES}];
}

- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {

    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
    
    BOOL showStatusItem = [defaultsController boolForKey:kMPRSettingsKeyShowMenuItem];
    BOOL hotkeyEnabled = [defaultsController boolForKey:kMPRSettingsKeyHotKey];
    
    NSLog(@"status icon enabled %hhd", showStatusItem);
    NSLog(@"hotkey enabled  %hhd", hotkeyEnabled);

    
    if (hotkeyEnabled == YES){
//      self.registerCocoaKeys = [[MPRHotKeyCocoa alloc] init];
//      [self registerCocoaKeys];
        self.registerHotKeys = [[MPRHotKeys alloc] init];
        [self registerHotKeys];
    }
    else {
      NSLog(@"hotkey disabled");
    }
    if (showStatusItem == YES) {
      self.statusItem = [[MPRStatusItem alloc] init];
//      Hide dock icon - requires relaunch
//      [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    }
    else {
      NSLog(@"status item off");
//      Show dock icon - requires relaunch
//      [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        
    }
  }
  return self;
}

- (void)setShowStatusItem:(BOOL)showStatusItem {
  if(_showStatusItem != showStatusItem) {
    _showStatusItem = showStatusItem;
  
    [self statusItem];
  }
}

- (NSViewController *)settingsViewController {
  if(!_settingsViewController) {
    self.settingsViewController = [[MPRSettingsViewController alloc] init];
    self.settingsViewController.plugin = self;
  }
  else {
    NSLog(@"settings view controller else -- failed");
    
  }
  return _settingsViewController;
}

- (void)setSettingsViewController:(MPRSettingsViewController *)settingsViewController {
  _settingsViewController = settingsViewController;
}

-(void)dealloc {
  
//  [MPRHotKeyCocoa dealloc];
  
  
}

@end







