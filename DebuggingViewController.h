//
//  DebuggingViewController.h
//  as3Debugger
//
//  Created by Lucas Dupin on 26/07/09.
//  Copyright 2009 28.room. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskWrapper.h"


@interface DebuggingViewController : NSObject <TaskWrapperController> {
	IBOutlet NSWindow *debugWindow;
	
	//Toolbar buttons
	IBOutlet NSToolbarItem *connectButton;
	IBOutlet NSToolbarItem *dettachButton;
	IBOutlet NSToolbarItem *continueTilNextBreakPointButton;
	IBOutlet NSToolbarItem *stepButton;
	IBOutlet NSToolbarItem *stepIntoButton;
	IBOutlet NSToolbarItem *stepOutButton;
	
	NSString * projectPath;
	NSString * fdbPath;
	NSString * flexPath;
	TaskWrapper * fdbTask;
}

- (IBAction) connect: (id)sender;

- (IBAction) step: (id)sender;
- (IBAction) stepOut: (id)sender;
- (IBAction) continueTilNextBreakPoint: (id)sender;
- (IBAction) dettach: (id)sender;

//TaskWrapperController
- (void)appendOutput:(NSString *)output;
- (void)processStarted;
- (void)processFinished;

@end
