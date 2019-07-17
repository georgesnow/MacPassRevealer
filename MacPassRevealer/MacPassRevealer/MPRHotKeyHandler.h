//
//  MPRHotKeyHandler.h
//  MacPassRevealer
//
//  Created by George Snow on 7/16/19.
//  Copyright © 2019 George Snow. All rights reserved.
//
#import <Foundation/Foundation.h>



@class DDHotKey;

@interface MPHotKeyHandler : NSObject

@property (readonly, strong) DDHotKey *registredHotKey;

@end
