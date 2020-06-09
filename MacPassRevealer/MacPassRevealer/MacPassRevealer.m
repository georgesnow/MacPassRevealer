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

//hide dock - open  recent file or new file
#import "MPAppDelegate.h"
#import "MPDocumentWindowController.h"

//hotkey - custimization
#import "DDHotKey+MacPassAdditions.h"
#import "MPRHotKeyHandler.h"


NSString *const kMPRSettingsKeyShowMenuItem           = @"kMPSettingsKeyShowMenuItem";
NSString *const kMPRSettingsKeyHotKey                 = @"kMPRSettingsKeyHotKey";
NSString *const kMPRSettingsKeyHideMPDockIcon         = @"kMPRSettingsKeyHideMPDockIcon";
NSString *const kMPRSettingsKeyLoginItem              = @"kMPRSettingsKeyLoginItem";

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
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kMPRSettingsKeyShowMenuItem : @YES, kMPRSettingsKeyHotKey : @NO, kMPRSettingsKeyHideMPDockIcon : @NO, kMPRSettingsKeyLoginItem: @NO}];
  
  NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
  //  NSArray *pathComponents = [[[NSBundle bundleWithIdentifier:@"com.hicknhacksoftware.MacPass"] bundlePath] pathComponents];
//  pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
  NSString *path = [NSString pathWithComponents:pathComponents];
//  NSLog(@"pathComp: %@", pathComponents);
  NSLog(@"path: %@", path);
 
}


- (instancetype)initWithPluginHost:(MPPluginHost *)host {
  self = [super initWithPluginHost:host];
  if(self) {

    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
    
    BOOL showStatusItem = [defaultsController boolForKey:kMPRSettingsKeyShowMenuItem];
    BOOL hideDockIcon = [defaultsController boolForKey:kMPRSettingsKeyHideMPDockIcon];
      
    NSLog(@"status icon enabled %hhd", showStatusItem);
    NSLog(@"hide dock icon %hhd", hideDockIcon);
//    NSLog(@"hotkey enabled  %hhd", hotkeyEnabled);

    self.registerUserHotKeyHandler = [[MPHotKeyHandler alloc] init];
    [self registerUserHotKeyHandler];
    
    if (showStatusItem == YES) {
      self.statusItem = [[MPRStatusItem alloc] init];
        if (hideDockIcon == YES) {
            [NSApplication.sharedApplication setActivationPolicy:NSApplicationActivationPolicyAccessory];
            SEL theSelector = @selector(hideWindow);
            NSNotificationCenter* theCenter = [NSNotificationCenter defaultCenter];
            NSWindow* theWindow = NSApp.mainWindow;
            [theCenter addObserver:self selector:theSelector name:NSWindowDidResignKeyNotification object:theWindow];
            [theCenter addObserver:self selector:theSelector name:NSWindowDidResignMainNotification object:theWindow];
//            [NSApp.mainWindow orderFrontRegardless];
        
        }
        else {
            [NSApplication.sharedApplication setActivationPolicy:NSApplicationActivationPolicyRegular];
        }
    }
    else {
      NSLog(@"status item off");

//      Show dock icon
        [NSApplication.sharedApplication setActivationPolicy:NSApplicationActivationPolicyRegular];
    }
    

    
  }

  return self;
}

-(void)hideWindow
{
    [NSApplication.sharedApplication hide:nil];
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







