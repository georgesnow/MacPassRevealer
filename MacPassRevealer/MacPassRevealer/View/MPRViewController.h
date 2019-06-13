//
//  MPRViewController.h
//  MacPassRevealer
//
//  Created by georgesnow on 6/7/19.
//  Copyright © 2019 HicknHack Software GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol MPRStatusItemControllerDelegate;

@interface MPRViewController : NSViewController

@property (weak) IBOutlet NSTextField *bundleID;

//-(instancetype)init;

- (IBAction)activateMacPass:(id)sender;
- (IBAction)lockMacPass:(id)sender;

- (IBAction)quitMacPass:(id)sender;


@end

NS_ASSUME_NONNULL_END
