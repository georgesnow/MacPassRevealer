//
//  MacPassRevealer.m
//  MacPassRevealer
//
////  Copyright © 2019 George Snow. All rights reserved.

#import <Cocoa/Cocoa.h>
#import "MPPlugin.h"

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const kMPRSettingsKeyShowMenuItem;
FOUNDATION_EXPORT NSString *const kMPRSettingsKeyHotKey;


@interface MPRMacPassRevealer : MPPlugin <MPPluginSettings>;


@end


NS_ASSUME_NONNULL_END
