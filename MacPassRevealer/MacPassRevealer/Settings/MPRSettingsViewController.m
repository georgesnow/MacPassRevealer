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

@interface MPRSettingsViewController ()
@property (weak) IBOutlet NSButton *showMenuItemCheckButton;
@property (weak) IBOutlet NSButton *hotkeyEnabled;

@end

@implementation MPRSettingsViewController

- (void)dealloc {
  NSLog(@"%@ dealloc", [self class]);
  [self.showMenuItemCheckButton unbind:NSValueBinding];
  [self.hotkeyEnabled unbind:NSValueBinding];
}

- (NSBundle *)nibBundle {
  return [NSBundle bundleForClass:[self class]];
}

- (NSString *)nibName {
  return @"MacPassRevealerSettings";
}

- (void)awakeFromNib {
  static BOOL didAwake = NO;
  if(!didAwake) {
    NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    [self.showMenuItemCheckButton bind:NSValueBinding
                              toObject:defaultsController
                           withKeyPath:[NSString stringWithFormat:@"values.%@", kMPRSettingsKeyShowMenuItem]
                               options:nil];
    [self.hotkeyEnabled bind:NSValueBinding
                              toObject:defaultsController
                           withKeyPath:[NSString stringWithFormat:@"values.%@", kMPRSettingsKeyHotKey]
                               options:nil];
    didAwake = YES;
  }
}

@end


