//
//  MPRMenu.m
//  MacPassRevealer
//
//  Created by George Snow on 7/10/19.
//  Copyright © 2019 George Snow All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPRSettingsViewController.h"
#import "MacPassRevealer.h"

//hotkey custimization
#import "DDHotKeyCenter.h"
#import "DDHotKeyTextField.h"
#import "DDHotKey+MacPassAdditions.h"
#import "MPSettingsHelper.h"

@interface MPRSettingsViewController ()
@property (weak) IBOutlet NSButton *showMenuItemCheckButton;
@property (weak) IBOutlet NSButton *hideDockIconCheckButton;



//hotkey custimization
@property (nonatomic, strong) DDHotKey *hotKey;

@end

@implementation MPRSettingsViewController

- (void)dealloc {
  NSLog(@"%@ dealloc", [self class]);
  [self.showMenuItemCheckButton unbind:NSValueBinding];
  [self.hideDockIconCheckButton unbind:NSValueBinding];
    
  //hotkey custimization
  [self.hotKeyTextField unbind:NSValueBinding];
}

- (NSBundle *)nibBundle {
  NSLog(@"nib bundle bundleforclass %@", self.className);
  return [NSBundle bundleForClass:[self class]];
}

- (NSString *)nibName {
  return @"MacPassRevealerSettings";
}

- (void)awakeFromNib {
  NSLog(@"awake from nib");
  static BOOL didAwake = NO;
  if(!didAwake) {
    NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    [self.showMenuItemCheckButton bind:NSValueBinding
                              toObject:defaultsController
                           withKeyPath:[NSString stringWithFormat:@"values.%@", kMPRSettingsKeyShowMenuItem]
                               options:nil];
    //hide dock custimization
    [self.hideDockIconCheckButton bind:NSValueBinding
                                toObject:defaultsController
                             withKeyPath:[NSString stringWithFormat:@"values.%@", kMPRSettingsKeyHideMPDockIcon]
                                 options:nil];

    //hotkey custimization
    [self performSelector:@selector(currentHotKey)];
        NSString *enableHotKeyPath = [MPSettingsHelper defaultControllerPathForKey:kMPRSettingsKeyHotKey];
    [self.hotkeyEnabledCheckBox bind:NSValueBinding toObject:defaultsController withKeyPath:enableHotKeyPath options:nil];
    [self.hotKeyTextField bind:NSEnabledBinding toObject:defaultsController withKeyPath:enableHotKeyPath options:nil];
    self.hotKeyTextField.delegate = self;
    [self _showKeyCodeMissingKeyWarning:NO];
    didAwake = YES;
  }
}


//hotkey custimzation

- (void)currentHotKey {
  _hotKey = [DDHotKey hotKeyWithKeyData:[NSUserDefaults.standardUserDefaults dataForKey:kMPSettingsKeyHotKeyDataKey]];
  /* Change any invalid hotkeys to valid ones? */
  self.hotKeyTextField.hotKey = self.hotKey;
}

- (void)setHotKey:(DDHotKey *)hotKey {
  if([self.hotKey isEqual:hotKey]) {
    NSLog(@"hotkey is equal to current hotkey - nothing of interest has changed");
    return; // Nothing of interest has changed;
  }
  NSLog(@"hotkey is getting set --- setting defaults sethotkey");
  _hotKey = hotKey;
  [NSUserDefaults.standardUserDefaults setObject:self.hotKey.keyData forKey:kMPSettingsKeyHotKeyDataKey];
}


- (void)controlTextDidChange:(NSNotification *)obj {
  BOOL validHotKey = self.hotKeyTextField.hotKey.valid;
  [self _showKeyCodeMissingKeyWarning:!validHotKey];
  if(validHotKey) {
    self.hotKey = self.hotKeyTextField.hotKey;
  }
}

- (void)_showKeyCodeMissingKeyWarning:(BOOL)show {
  self.hotkeyWarningTextField.hidden = !show;
}

@end


