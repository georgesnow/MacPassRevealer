//
//  MacPassRevealer.m
//  MacPassRevealer
//
//  Copyright © 2019 George Snow. All rights reserved.
//


#import "MacPassRevealer.h"
#import "Carbon/Carbon.h"
#import "MPRStatusItem.h"
#import "MPRSettingsViewController.h"

//hotkey - custimization
#import "DDHotKey+MacPassAdditions.h"
#import "MPRHotKeyHandler.h"


NSString *const kMPRSettingsKeyShowMenuItem           = @"kMPSettingsKeyShowMenuItem";
NSString *const kMPRSettingsKeyHotKey                 = @"kMPRSettingsKeyHotKey";


@interface MPRMacPassRevealer () 

@property (strong) MPRSettingsViewController *settingsViewController;
@property (strong) MPRStatusItem *statusItem;
@property (nonatomic) BOOL showStatusItem;



//hotkey custimization
@property (strong) MPHotKeyHandler *registerUserHotKeyHandler;

@end


@implementation MPRMacPassRevealer

@synthesize settingsViewController = _settingsViewController;


//hotkey - custimization
+(void)initialize{
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kMPRSettingsKeyShowMenuItem : @YES, kMPRSettingsKeyHotKey : @NO}];
  
}

- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {

    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
    
    BOOL showStatusItem = [defaultsController boolForKey:kMPRSettingsKeyShowMenuItem];

    
    NSLog(@"status icon enabled %hhd", showStatusItem);
//    NSLog(@"hotkey enabled  %hhd", hotkeyEnabled);

    self.registerUserHotKeyHandler = [[MPHotKeyHandler alloc] init];
    [self registerUserHotKeyHandler];
    
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
  

  
  
}

@end







