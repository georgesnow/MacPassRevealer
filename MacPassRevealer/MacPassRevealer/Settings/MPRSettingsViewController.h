//
//  MPRMenu.h
//  MacPassRevealer
//
//  Created by George Snow on 7/10/19.
//  Copyright © 2019 George Snow All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class MPRMacPassRevealer;

//hotkey custimization
@class DDHotKeyTextField;

@interface MPRSettingsViewController : NSViewController <NSTextFieldDelegate>

@property (weak) MPRMacPassRevealer *plugin;

//hotkey custimization
@property (strong) IBOutlet DDHotKeyTextField *hotKeyTextField;
@property (weak) IBOutlet NSTextField *hotkeyWarningTextField;
@property (weak) IBOutlet NSButton *hotkeyEnabledCheckBox;

@end
