//
//  MPRHotKey.m
//  MacPassRevealer
//
//  Created by georgesnow on 6/3/19.
//  Copyright © 2019 George Snow. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "MPRHotKeys.h"

static NSString *const MPRMacPassBundleIdentifier = @"com.hicknhacksoftware.MacPass";
static int const MPRHotKeyId1 = 1;
static int const MPRHotKeyId2 = 2;

@interface MPRHotKeys ()

@end

@implementation MPRHotKeys
#pragma mark - MPRHotKeys
//hotkey
OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
    EventHotKeyID hkCom;
    
    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkCom), NULL, &hkCom);
    
    int hotKeyId = hkCom.id;
    
    NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
    NSRunningApplication *macPass = NSRunningApplication.currentApplication;
    
    NSLog(@"frontApp: %@", frontMostApplication);
    
    switch (hotKeyId) {
        case MPRHotKeyId1:
            //NSLog(@"frontApp and other hotkey: %@", frontMostApplication);
            break;
        case MPRHotKeyId2: {
            if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
                [NSApplication.sharedApplication hide:nil];
            }
            else {
                [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
            }
            break;
        }
    }
    return noErr;
}

- (instancetype)init {
    self = [super init];
    if(self)
    {
        [self registerHotKeys];
        
    }
    return self;
}



- (void)registerHotKeys {
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    InstallApplicationEventHandler(&OnHotKeyEvent, 1, &eventType, NULL, NULL);
    gMyHotKeyID.signature='htk1';
    gMyHotKeyID.id=MPRHotKeyId1;
    //Test shortcut - uncomment when testing the other switch case
    //RegisterEventHotKey(50, controlKey+cmdKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    
    gMyHotKeyID.signature='htk2';
    gMyHotKeyID.id=MPRHotKeyId2;
    RegisterEventHotKey(50, controlKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}


@end

