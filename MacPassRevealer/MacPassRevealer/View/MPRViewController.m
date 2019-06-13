//
//  MPRViewController.m
//  MacPassRevealer
//
//  Created by georgesnow on 6/7/19.
//  Copyright © 2019 HicknHack Software GmbH. All rights reserved.
//

#import "MPRViewController.h"


@interface MPRViewController ()


@property (weak) IBOutlet NSTextField *bundleID;



@end

@implementation MPRViewController
- (instancetype)init
{
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"MPRStoryboard" bundle:classBundle];
  MPRViewController *viewController = [storyBoard instantiateControllerWithIdentifier:@"MPRViewController"];
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  [_bundleID setStringValue:frontMostApplication.localizedName];
  return viewController;
    
   //MPRViewController
  //MPRViewController
  //  MPRViewController *viewController = [[MPRViewController init] instantiateInitialController];
  
}

//- (instancetype)init
//{
//  self = [[NSViewController init] instantiateInitialController];
//  return self;
//}
//
//- (void)windowDidLoad
//{
//  [super windowDidLoad];
//  self.windowFrameAutosaveName = @"MPRView";
//}



@end
