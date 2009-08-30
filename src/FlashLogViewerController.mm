#import "FlashLogViewerController.h"


@implementation FlashLogViewerController

@synthesize field;

- (id)init {
    return [super initWithWindowNibName:@"FlashLogViewer"];
}

- (void)awakeFromNib
{
	NSLog(@"Tracer awaken");
	
	//Did we receive a flashlog variable in de commandline?
	NSString * flashlog = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey: @"flashLogPath"];
	if(![[NSFileManager defaultManager] fileExistsAtPath: flashlog]) {
		flashlog = [NSString stringWithUTF8String: strcat(getenv("HOME"), "/Library/Preferences/Macromedia/Flash Player/Logs/flashlog.txt")];
		[[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:flashlog forKey: @"flashLogPath"];
	}
	NSLog(@"%@", [@"Flashlog is : " stringByAppendingString: flashlog]);
	
	//Telling wich file we're reading
	[field setTextColor: [NSColor blackColor]];
	[field setString: [@"Reading: " stringByAppendingString: flashlog]];
	[field setString:[[field string] stringByAppendingString: @"\n"]];
	[field setUsesFontPanel:YES];
	[field setEditable:NO];
	
	[self startTask];
	
	//Setting auto-aulpha
	[alphaPanel setAutoAlpha: [autoAlphaButton state] == NSOnState];
	
	NSLog(@"done starting");
}

//Clear the text field
- (IBAction) clear: (id)sender
{
	[field setString: @" "];
}

//Make the text black
- (IBAction) separate: (id)sender
{
	if([field string] != NULL){
		[field setString:[[field string] stringByAppendingString: @"\n\n"]];
		[field scrollPageDown:self];
	}
}

//Set auto alpha on Mouse Events
- (IBAction) setAutoAlpha: (id)sender
{
	[alphaPanel setAutoAlpha: [autoAlphaButton state] == NSOnState];
}

- (void) startTask
{
	NSString * flashlog = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey: @"flashLogPath"];
	
	//Start reading
	tailTask = [[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:@"/usr/bin/tail", @"-f", flashlog, nil]];
	[tailTask startProcess];
	
	[flashlog autorelease];
}


- (void)processStarted{}
- (void)processFinished{}
- (void)appendOutput:(NSString *)output
{
	
/*	NSString * toAdd = [[[NSMutableAttributedString alloc]
								 initWithString: output] autorelease];
	[toAdd addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, [toAdd length])];
    [[field textStorage] appendAttributedString: toAdd];
*/	
	[field setString: [NSString stringWithFormat:@"%@\n%@", [field string], output]];
	[field scrollPageDown:self];
}

- (NSPanel *)getWindow
{
	return window;
}

- (void) stopTask
{
	[tailTask stopProcess];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end