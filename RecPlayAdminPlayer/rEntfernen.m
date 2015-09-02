#import "rEntfernen.h"

@implementation rEntfernen
- (id) init
{
	self=[super initWithWindowNibName:@"RPEntfernen"];
	return self;
}

- (void)awakeFromNib
{
	NSColor * TitelFarbe=[NSColor blueColor];
	NSFont* TitelFont;
	TitelFont=[NSFont fontWithName:@"Helvetica" size: 24];
	[TitelString setFont:TitelFont];
	[TitelString setTextColor:TitelFarbe];
	NSFont* TextFont;
	TextFont=[NSFont fontWithName:@"Helvetica" size: 14];
	[TextString setFont:TextFont];
	[EntfernenVariante setFont:TextFont];

}

- (IBAction)OKSheet:(id)sender
{
    [NSApp stopModalWithCode:1];
	int var=[[EntfernenVariante selectedCell]tag];
	//NSLog(@"OKSheet:  stopModalWithCode tag: %d",var);
	NSNumber* VariantenNummer=[NSNumber numberWithInt:var];
	NSMutableDictionary* VariantenDic=[NSMutableDictionary dictionaryWithObject:VariantenNummer forKey:@"EntfernenVariante"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"EntfernenOption" object:self userInfo:VariantenDic];
}

- (IBAction)cancelSheet:(id)sender
{
	//NSLog(@"cancelSheet: stopModalWithCode");

    [NSApp stopModalWithCode:0];
}

- (void)sheetDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	//NSLog(@"sheetDidEnd returnTag: %d  %d   %d  %d",[[EntfernenVariante selectedCell]tag], returnCode, NSAlertFirstButtonReturn,NSAlertSecondButtonReturn);
	
	 if (returnCode == NSAlertFirstButtonReturn)
	   {
		//NSLog(@"alertDidEnd NSAlertFirstButtonReturn: %d",1 );
	  }
	 if (returnCode == NSAlertSecondButtonReturn)
	   {
		 //NSLog(@"alertDidEnd NSAlertSecondButtonReturn: %d",2 );
	   }
	 
	// [[self window] orderOut:NULL];  
}
@end
