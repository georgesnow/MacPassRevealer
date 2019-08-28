//
//  MPRHotKeyHandler.m
//  MacPassRevealer
//
//  Created by George Snow on 7/16/19.
//  Copyright © 2019 George Snow. All rights reserved.
//


#import "MPRHotKeyHandler.h"

#import "MPSettingsHelper.h"

#import "DDHotKeyCenter.h"
#import "DDHotKey+MacPassAdditions.h"
#import "MacPassRevealer.h"

#import "MPDocument.h"
#import "MPDocumentWindowController.h"


NSString *const kMPSettingsKeyHotKeyDataKey           = @"kMPSettingsKeyHotKeyDataKey";

@interface MPHotKeyHandler ()

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) NSData *hotKeyData;
@property (strong) DDHotKey *registredHotKey;

@property (assign) NSTimeInterval userActionRequested;



@end

@implementation MPHotKeyHandler

-(instancetype)init {
  self = [super init];
  if (self) {
    _enabled = NO;
    
    //    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
    //    _enabled = [defaultsController boolForKey:kMPRSettingsKeyHotKey];
    
    _userActionRequested = NSDate.distantPast.timeIntervalSinceReferenceDate;
    
    [self bind:NSStringFromSelector(@selector(enabled))
      toObject:NSUserDefaultsController.sharedUserDefaultsController
   withKeyPath:[MPSettingsHelper defaultControllerPathForKey:kMPRSettingsKeyHotKey]
       options:nil];
    [self bind:NSStringFromSelector(@selector(hotKeyData))
      toObject:NSUserDefaultsController.sharedUserDefaultsController
   withKeyPath:[MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyHotKeyDataKey]
       options:nil];
    
    //[self _registerHotKey];
    
    //    NSUserDefaults *defaultsController = [NSUserDefaults standardUserDefaults];
    //    BOOL hotkeyEnabled = [defaultsController boolForKey:kMPRSettingsKeyHotKey];
    //    if (hotkeyEnabled){
    //      NSLog(@"hot key enabled handler");
    //      [self _registerHotKey];
    //    }
    //    else {
    //      NSLog(@"hot key disable handler");
    //    }
    
  }
  return self;
}

- (void)dealloc {
  
  [self unbind:NSStringFromSelector(@selector(hotKeyData))];
}

- (void)setEnabled:(BOOL)enabled {
  if(_enabled != enabled) {
    _enabled = enabled;
    self.enabled ? [self _registerHotKey] : [self _unregisterHotKey];
  }
}

- (void)setHotKeyData:(NSData *)hotKeyData {
  if(![_hotKeyData isEqualToData:hotKeyData]) {
    [self _unregisterHotKey];
    _hotKeyData = [hotKeyData copy];
    if(self.enabled) {
      [self _registerHotKey];
    }
  }
}

- (void)_registerHotKey {
  if(!self.hotKeyData) {
    return;
  }
  __weak MPHotKeyHandler *welf = self;
  DDHotKeyTask aTask = ^(NSEvent *event) {
    [welf _didPressHotKey];
  };
  self.registredHotKey = [[DDHotKeyCenter sharedHotKeyCenter] registerHotKey:[DDHotKey hotKeyWithKeyData:self.hotKeyData task:aTask]];
  
}

- (void)_unregisterHotKey {
  if(self.registredHotKey) {
    [[DDHotKeyCenter sharedHotKeyCenter] unregisterHotKey:self.registredHotKey];
    self.registredHotKey = nil;
  }
}
- (void)_didPressHotKey {
  NSLog(@"holy smokes hotkey worked!");
  
  //land focus
  NSArray *documents = [NSDocumentController sharedDocumentController].documents;
  NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
    MPDocument *document = evaluatedObject;
    return !document.encrypted;}];
  NSArray *unlockedDocuments = [documents filteredArrayUsingPredicate:filterPredicate];
  
  
  
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSRunningApplication *macPass = NSRunningApplication.currentApplication;
  
  NSLog(@"frontApp: %@", frontMostApplication);
  NSString *searchContext = frontMostApplication.localizedName;
  NSString *frontAppBundleId = frontMostApplication.bundleIdentifier;
  NSLog(@"searchContext %@", searchContext);
  if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
    [NSApplication.sharedApplication hide:nil];
  }
  else {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    [NSApp.mainWindow makeKeyAndOrderFront:self];
    MPDocument *currentDocument = [NSDocumentController sharedDocumentController].currentDocument;
    MPDocument *document = documents.firstObject;
    NSString *currentContext = document.searchContext.searchString;
    NSLog(@"current search context: %@", currentContext);
    if(unlockedDocuments.count == 0){
      //        [currentDocument showWindows];
      //        MPDocumentWindowController *wc = document.windowControllers.firstObject;
      MPDocumentWindowController *wc = currentDocument.windowControllers.firstObject;
      [wc showPasswordInputWithMessage:NSLocalizedString(@"LOCKED_DATABASE", "Locked Database!")];
      self.userActionRequested = NSDate.date.timeIntervalSinceReferenceDate;
      [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didUnlockDatabase:) name:MPDocumentDidUnlockDatabaseNotification object:nil];
    }
    else {
      //show windows invokes strange window hiding issue
      //          [document showWindows];
      //update search works
      //          [document updateSearch:nil];
      //        lands focus in search bar everytime
      if([frontMostApplication.bundleIdentifier isEqualToString:@"com.apple.Safari"]) {
        NSAppleScript *script = [[NSAppleScript alloc] initWithSource:@"tell application \"Safari\" to get URL of front document"];
        NSAppleEventDescriptor *aed = [script executeAndReturnError:NULL];
        NSURL *url = [[NSURL alloc] initWithString:aed.stringValue];
        [document perfromCustomSearch:nil];
        document.searchContext.searchString = url.host;
      }
      
      else {
        MPDocumentWindowController *wc = currentDocument.windowControllers.firstObject;
        [wc focusEntries:nil];
        //need to test for com.xxx.bundleid in some way to discern if the currentContext is the frontApp or entered text
        if ([currentContext  isNotEqualTo:NULL]){
          NSLog(@"currentcontext isnorequalto NULL");
          [document perfromCustomSearch:nil];
          if (![currentContext doesContain:frontMostApplication.localizedName]  || currentContext.length > 0){
            document.searchContext.searchString = searchContext;
          }
          else if ([currentContext doesContain:frontMostApplication.localizedName]){
            document.searchContext.searchString = searchContext;
          }
          else {
            document.searchContext.searchString = currentContext;
          }
        }
//        else if ((![currentContext length]) == 0){
//          NSLog(@"currentContext length is NOT 0");
//          //[currentContext isEqualToString:@""] || ![currentContext  isNotEqualTo:NULL]
//          if ([currentContext isNotEqualTo:searchContext]){
//            NSLog(@"current context isnotequalto searchContext");
//            [document perfromCustomSearch:nil];
//            document.searchContext.searchString = searchContext;
//          }
//          else {
//          NSLog(@"else");
//          [document perfromCustomSearch:nil];
//          document.searchContext.searchString = currentContext;
//        }
//      }
      else if ([currentContext isEqual:nil] || [currentContext length] == 0) {
        NSLog(@"current context isEqual to nil OR currentContext length is 0");
        [document perfromCustomSearch:nil];
        document.searchContext.searchString = searchContext;
      }
    }
      //          set the context of the search to the last app before activating
      //          document.searchContext.searchString = @"test";
      
    }
    
    
    
    
    
  }
  
}

- (void)_didUnlockDatabase:(NSNotification *)notification {
  /* Remove ourselves and call again to search matches */
  [NSNotificationCenter.defaultCenter removeObserver:self name:MPDocumentDidUnlockDatabaseNotification object:nil];
  //    NSTimeInterval now = NSDate.date.timeIntervalSinceReferenceDate;
  MPDocument *currentDocument = [NSDocumentController sharedDocumentController].currentDocument;
  
  //    while (currentDocument.encrypted) {
  //        NSUserNotification *notification = [[NSUserNotification alloc] init];
  //
  //        notification.informativeText = NSLocalizedString(@"Locked Database", "Locked Database");
  //
  //        [NSUserNotificationCenter.defaultUserNotificationCenter deliverNotification:notification];
  //        break;
  //    }
  
  double delayInSeconds = 1;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    [currentDocument perfromCustomSearch:nil];
    
  });
  
  
  //        NSArray *documents = [NSDocumentController sharedDocumentController].documents;
  //        MPDocument *document = documents.firstObject;
  
  
}

@end
