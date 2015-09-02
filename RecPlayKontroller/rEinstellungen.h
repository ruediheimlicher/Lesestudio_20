/* rEinstellungen */

#import <Cocoa/Cocoa.h>

@interface rEinstellungen : NSWindowController
{
    IBOutlet id BewertungZeigen;
    IBOutlet id NoteZeigen;
	IBOutlet id mitUserPasswort;
	IBOutlet id TimeoutCombo;

}
- (IBAction)reportClose:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (void)setMitPasswort:(BOOL)mitPW;

- (void)setBewertung:(BOOL)mitBewertung;
- (void)setNote:(BOOL)mitNote;
- (void)setTimeoutDelay:(NSTimeInterval)derDelay;

@end
