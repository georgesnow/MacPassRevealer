//
//  MPRViewController.m
//  MacPassRevealer
//
//  Created by georgesnow on 6/7/19.
//  Copyright © 2019 HicknHack Software GmbH. All rights reserved.
//

#import "MPRViewController.h"
#import "MPDocument.h"

@interface MPRViewController ()


@property (weak) MPDocument *currentDoc;
@property (readonly) BOOL queryDocumentOpen;



@end

@implementation MPRViewController
@synthesize bundleID;


- (instancetype)init
{
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"MPRStoryboard" bundle:classBundle];
  MPRViewController *viewController = [storyBoard instantiateControllerWithIdentifier:@"MPRViewController"];

  return viewController;
    

  
}


-(void)viewWillAppear {
  NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
  NSString *bundleIDString = (NSString *)frontMostApplication.localizedName;
  NSLog(@"bundleID %@", bundleID.stringValue);
  [bundleID setStringValue:bundleIDString];
  
  NSLog(@"bundleIDString %@", bundleIDString);
}
- (BOOL)queryDocumentOpen {
  return self.currentDoc && !self.currentDoc.encrypted;
}

- (IBAction)activateMacPass:(id)sender {
    NSRunningApplication *frontMostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;
    NSRunningApplication *macPass = NSRunningApplication.currentApplication;
    if(frontMostApplication.processIdentifier == macPass.processIdentifier) {
      [NSApplication.sharedApplication hide:nil];
    }
    else {
      [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    }
}

- (IBAction)lockMacPass:(id)sender {
  NSArray *documents = [NSDocumentController sharedDocumentController].documents;
  MPDocument __weak *lastDocument;
  for(MPDocument *document in documents) {
    if(document.encrypted) {
      NSLog(@"Database is Locked: %@", document.displayName);
      
      continue;
    }
    lastDocument = document;
    [lastDocument lockDatabase:nil];
    
    //  [_currentDoc lockDatabase:nil];
    NSLog(@"lock db %@", _currentDoc);
    
    NSLog(@"attempted lock");
  }
}

- (IBAction)quitMacPass:(id)sender {
  [[NSApplication sharedApplication] terminate:self];
}


@end
