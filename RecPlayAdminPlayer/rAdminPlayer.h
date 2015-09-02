//
//  AdminPlayer.h
//  RecPlayC
//
//  Created by Ruedi Heimlicher on 14.10.04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rAdminDS.h"
//#include "Quicktime/Quicktime.h"
#import "rAdminListe.h"
//#import "rMovieView.h"
#import "rEntfernen.h"
#import "rClean.h"
#import "rKommentar.h"
#import "rMarkierung.h"
#import "rNamenListe.h"
#import "rAVPlayer.h"

#import "rAbspielanzeige.h"
//#import "rUtils.h"
//#import <fcntl.h>
//#import <pthread.h>
//#import "rThreadData.h"
//#import "rWorkerThread.h"

#define kMoviePaneOffset            20
#define kMovieBottomOffset          58
#define kMovieControllerBarHeight	16

// menu item tags
#define USE_POSIX_THREAD    2000
#define USE_MAIN_THREAD     2001


@class rProgressDialog;


@interface rAdminPlayer:NSWindowController <NSWindowDelegate, NSTabViewDelegate,NSMenuDelegate>
	{
	IBOutlet NSWindow*			AdminFenster;
	IBOutlet NSTextField*		TitelString;
	IBOutlet NSTextField*		ModusString;
	IBOutlet rAdminListe*		NamenListe;
	
	IBOutlet NSTextField*		AbspieldauerFeld;
   IBOutlet NSTextField*		AufnahmedauerFeld;
	rEntfernen*                EntfernenFenster;
	rKommentar*                KommentarFenster;
	rClean*                    CleanFenster;
	rMarkierung*               MarkierungFenster;
//   IBOutlet rAbspielanzeige*			Abspielanzeige;
//      rAVPlayer*  AVAbspielplayer;

//	IBOutlet NSMovieView*			AdminQTPlayer;
//	IBOutlet QTMovieView*			AdminQTKitPlayer;
	IBOutlet NSButton*			PlayTaste;
	IBOutlet NSButton*			zurListeTaste;
	IBOutlet NSButton*			ExportierenTaste;
	IBOutlet NSButton*			LoeschenTaste;
	IBOutlet NSButton*			MarkCheckbox;
	IBOutlet NSButton*			UserMarkCheckbox;
   IBOutlet NSButton*			SchliessenTaste;
      
	IBOutlet NSTextField*		ProjektFeld;
	IBOutlet NSTextView*       AdminKommentarView;
	IBOutlet NSTextField*		AdminTitelfeld;
	IBOutlet NSTextField*		AdminDatumfeld;
	IBOutlet NSTextField*		AdminNamenfeld;
   IBOutlet NSTextField*		AdminNummerfeld;
	IBOutlet NSPopUpButton*		AdminBewertungfeld;
	IBOutlet NSTextField*		AdminNotenfeld;
	IBOutlet NSTextField*		AdminProjektFeld;
      
   IBOutlet NSPopUpButton*		   AdminProjektPop;
      
	IBOutlet NSTabView*			AufnahmenTab;
	IBOutlet NSTableView*		AufnahmenTable;
	IBOutlet NSMatrix*			MarkAuswahlOption;
	NSMutableArray*				AufnahmenDicArray;
	IBOutlet NSPopUpButton*		LesernamenPop;
	IBOutlet NSButton*			DeleteTaste;
	BOOL                       AufnahmeDa;
	int                        selektierteAufnahmenTableZeile;
	
      rAVPlayer*						   AVAbspielplayer;
      IBOutlet rAbspielanzeige*			Abspielanzeige;
      

//	Movie							AdminPlayerMovie;
	UInt32						AdminAbspielzeit;
	NSString*					AdminLeseboxPfad;
	NSString*					AdminArchivPfad;
	NSString*					AdminProjektPfad;
	NSPopUpButton*				ProjektPop;

	NSString*					AdminAktuellesProjekt;

	NSString*					AdminAktuellerLeser;
	NSString*					AdminAktuelleAufnahme;

	
	NSString*					AdminPlayPfad;
	NSMutableArray *			AdminProjektNamenArray;
	NSMutableArray *			AdminProjektArray;
	BOOL                    AdminProjektAktiviert;
	
	int							AnzLeser;
	int							selektierteZeile;
	NSComboBoxCell *			comboBox;
	NSPopUpButtonCell*		AufnahmenPop;
	rAdminDS*					AdminDaten;
	BOOL                    Moviegeladen;
	BOOL                    Textchanged;
   BOOL                    Kommentarsaved;
	int							Umgebung;
	
	int							AuswahlOption;
	int							AbsatzOption;
	int							ZusatzOption;
	int							AnzahlOption;
	int							ProjektNamenOption;
	int							ProjektAuswahlOption;
	int							nurMarkierteOption;
	NSString*					OptionAString;
	NSString*					OptionBString;
	NSString*					ProjektPfadOptionString;
	NSString*					TitelOptionString;
	
	//Clean
	BOOL						nurTitelZuNamenOption;;
	BOOL						ClearBehaltenOption;
	BOOL						ExportOption;

	NSTimer*					CleanDelayTimer;
	
	NSString*					ExportOrdnerPfad;
	NSMutableData*				RPExportdaten;
	OSType						exportFormatFlag;
	NSMutableString*			ExportFormatString;
	FSSpec						UserExportSpec;
	long                    UserExportParID;
   NSMutableArray*			ProjektArray;
	
// Player
      
	
	}

@property  (weak) IBOutlet NSButton*					StartPlayKnopf;
@property  (weak) IBOutlet NSButton*					StopPlayKnopf;
@property  (weak) IBOutlet NSButton*					StartStopKnopf;
@property  (weak) IBOutlet NSTextField*				StartStopString;
@property (weak)  IBOutlet NSButton*					BackKnopf;
@property (weak)  IBOutlet NSButton*					RewindKnopf;
@property (weak)  IBOutlet NSButton*					ForewardKnopf;

- (void)setLeseboxPfad:(NSString*)derPfad inProjekt: (NSString*)dasProjekt;
- (NSString*)AdminLeseboxPfad;
- (BOOL)setNetworkAdminLeseboxPfad:(id)sender;
- (BOOL)setHomeAdminLeseboxPfad:(id)sender;

- (void)setAdminPlayer:(NSString*)derLeseboxPfad inProjekt:(NSString*)dasProjekt;
- (void)setAdminProjektArray:(NSArray*)derProjektArray;
- (void)resetAdminPlayer;
- (void)setProjektPopMenu:(NSArray*)derProjektArray;
- (IBAction)setNeuesAdminProjekt:(id)sender;

- (IBAction)setLeser:(id)sender;
- (void)setLeserFuerZeile:(int)dieZeile;
- (BOOL)setPfadFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme;
- (BOOL)setKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme;
- (BOOL)saveKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme;
- (BOOL)saveAdminMarkFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme 
			  mitAdminMark:(int)dieAdminMark;
- (BOOL)saveMarksFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme 
			  mitAdminMark:(int)dieAdminMark
			   mitUserMark:(int)dieUserMark;


- (IBAction)startAdminPlayer:(id)sender;
- (int)selektierteZeile;

- (void)backZurListe:(id)sender;
- (void)Aufnahmezuruecklegen;

- (void)setBackTaste:(BOOL)istDefault;
- (IBAction) AufnahmeLoeschen:(id)sender;
- (void)EntfernenNotificationAktion:(NSNotification*)note;
- (void)ex:(NSString*)dieAufnahme;
- (void)exMitPfad:(NSString*)derAufnahmePfad;
- (void)inPapierkorb:(NSString*)dieAufnahme;
- (void)inPapierkorbMitPfad:(NSString*)derAufnahmePfad;

- (void)insMagazin:(NSString*)dieAufnahme;
- (void)insMagazinMitPfad:(NSString*)derAufnahmePfad;
- (void)AufnahmeMarkieren:(id)sender;
- (BOOL)AufnahmeIstMarkiertAnPfad:(NSString*)derAufnahmePfad;
- (BOOL)AufnahmeIstMarkiertAnAnmerkungPfad:(NSString*)derAnmerkungPfad;
- (void)setMark:(BOOL)derStatus;
- (void)MarkierungEntfernenFuerZeile:(int)dieZeile;
- (void)MarkierungenEntfernen;
- (void)AlleMarkierungenEntfernen;
- (IBAction)reportAktualisieren:(id)sender;
- (void)reportUserMark:(id)sender;
- (void)reportAdminMark:(id)sender;
- (IBAction)reportFensterschliessen:(id)sender;
- (NSString*)neuerNameVonAufnahme:(NSString*)dieAufnahme mitNummer:(int)dieNummer;
- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;

- (void)AdminKeyNotifikationAktion:(NSNotification*)note;
- (void)AdminZeilenNotifikationAktion:(NSNotification*)note;
- (void)AdminEnterKeyNotifikationAktion:(NSNotification*)note;


//- (QTMovieView*)AdminQTKitPlayer;
- (NSString*)Zeitformatieren:(long) dieSekunden;
- (void)neuNummerierenVon:(NSString*) derLeser;
- (void)clearKommentarfelder;
- (OSErr)ExportMovieVonPfad:(NSString*) derAufnahmePfad;

//- (IBAction)OKSheet:(id)sender;

- (void)Leseboxordnen;
- (BOOL)FensterschliessenOK;
- (void)AdminBeenden;
- (BOOL)windowShouldClose:(id)sender;
- (IBAction)showCleanFenster:(int)tab;
- (void)setCleanTask:(int)dieTask;



- (IBAction)setAufnahmenVonPopLeser:(id)sender;
- (IBAction)AufnahmeExportieren:(id)sender;
- (IBAction)reportAuswahlOption:(id)sender;
- (IBAction)reportDelete:(id)sender;


// Player
- (IBAction)startAVPlay:(id)sender;
- (IBAction)stopAVPlay:(id)sender;
- (IBAction)backAVPlay:(id)sender;
- (IBAction)saveRecord:(id)sender;
- (IBAction)rewindAVPlay:(id)sender;
- (IBAction)forewardAVPlay:(id)sender;

@end






@interface rAdminPlayer(rKommentarKontroller)
- (NSString*)OptionA;
- (NSString*)OptionB;
- (BOOL)nurMarkierte;
- (BOOL)mitMarkierungAufnehmenOptionAnPfad:(NSString*)derAufnahmePfad;
- (NSArray*)KommentareVonLeser:(NSString*)derLeser 
					  mitTitel:(NSString*)derTitel 
					   maximal:(int)dieAnzahl 
				 anProjektPfad:(NSString*)derProjektPfad;
//- (NSArray*)KommentareMitTitel:(NSString*)derTitel vonLeser:(NSString*)derLeser maximal:(int)dieAnzahl;
- (NSArray*)KommentareMitTitel:(NSString*)derTitel 
					  vonLeser:(NSString*)derLeser 
				 anProjektPfad:(NSString*)derProjektPfad
					   maximal:(int)dieAnzahl;

//- (NSArray*)alleKommentareZuTitel:(NSString*)derTitel maximal:(int)dieAnzahl;
- (NSArray*)alleKommentareZuTitel:(NSString*)derTitel 
					anProjektPfad:(NSString*)derProjektPfad
						  maximal:(int)dieAnzahl;
- (NSString*)KommentarZuAufnahme:(NSString*)dieAufnahme 
					  vonLeser:(NSString*)derLeser 
				 anProjektPfad:(NSString*)derProjektPfad;
- (NSView*)KommentarView;
- (NSArray*)ProjektPfadArrayMitKommentarOptionen;
- (void)KommentarDruckenVonProjekt:(NSString*)dasProjekt;
- (void)KommentarDrucken;
- (void)SaveKommentarVonProjekt:(NSString*)dasProjekt;
- (void)KommentarSichern;
//- (NSArray*)alleKommentareNachTitel:(int)dieAnzahl;
- (NSArray*)alleKommentareNachTitelAnProjektPfad:(NSString*)derProjektPfad bisAnzahl:(int)dieAnzahl;
- (IBAction)showKommentar:(id)sender;
//- (NSString*)createKommentarStringInProjekt:(NSString*)derProjektPfad;
- (NSArray*)createKommentarStringArrayWithProjektPfadArray:(NSArray*)derProjektPfadArray;
- (NSArray*)createDruckKommentarStringDicArrayWithProjektPfadArray:(NSArray*)derProjektPfadArray;

- (void)KommentarNotificationAktion:(NSNotification*)note;


//- (NSString*)lastKommentarVonLeser:(NSString*)derLeser;
- (NSString*)lastKommentarVonLeser:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad;
//- (NSArray*)lastKommentarVonAllen;
- (NSArray*)lastKommentarVonAllenAnProjektPfad:(NSString*)derProjektPfad;

- (NSString*)lastKommentarVonLeser:(NSString*)derLeser mitTitel:(NSString*)derTitel;
- (NSString*)heutigeKommentareVon:(NSString*)derLeser;
//- (NSArray*)alleKommentareVonLeser:(NSString*)derLeser  maximal:(int)dieAnzahl;
- (NSArray*)alleKommentareVonLeser:(NSString*)derLeser 
					  anProjektPfad:(NSString*)derProjektPfad 
						  bisAnzahl:(int)dieAnzahl;

//- (NSArray*)alleKommentareNachNamen:(int)dieAnzahl;
- (NSArray*)alleKommentareNachNamenAnProjektPfad:(NSString*)derProjektPfad bisAnzahl:(int)dieAnzahl;
//- (NSArray*)TitelArrayVon:(NSString*)derLeser;
- (NSArray*)TitelArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad;
- (NSArray*)TitelMitKommentarArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad;
//- (NSArray*)TitelArrayVonAllenBisAnzahlProLeser:(int)dieAnzahl;
- (NSArray*)TitelArrayVonAllenAnProjektPfad:(NSString*)derProjektPfad 
						  bisAnzahlProLeser:(int)dieAnzahl;
- (NSArray*)LeserArrayAnProjektPfad:(NSString*)derProjektPfad;
//- (NSArray*)LeserArrayVonTitel:(NSString*)derTitel;
- (NSArray*)LeserArrayVonTitel:(NSString*)derTitel anProjektPfad:(NSString*)derProjektPfad;
- (NSArray*)TitelMitAnzahlArrayVon:(NSString*)derLeser;
- (NSArray*)TitelMitAnzahlArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad;

- (NSArray*)sortNachNummer:(NSArray*)derArray;
- (NSArray*)sortNachABC:(NSArray*)derArray;

- (NSString*)AufnahmeTitelVon:(NSString*) dieAufnahme;
- (NSString*)KommentarVon:(NSString*) derKommentarString;
- (NSString*)DatumVon:(NSString*) derKommentarString;
- (NSString*)BewertungVon:(NSString*) derKommentarString;
- (BOOL)AdminMarkVon:(NSString*) derKommentarString;
- (NSString*)NoteVon:(NSString*) derKommentarString;
- (int)UserMarkVon:(NSString*)derKommentarString;
- (int)AufnahmeNummerVon:(NSString*) dieAufnahme;
- (NSString*)InitialenVon:(NSString*)derName;
//- (void)MarkierungEntfernenFuerLeser:(NSString*)derName;
- (void)Markierungenreset;
@end

@interface rAdminPlayer(rAufnahmenTableController)
- (void)setNamenPop:(NSArray*)derNamenArray;
- (IBAction)reportAuswahlOption:(id)sender;
- (IBAction)reportDelete:(id)sender;
- (void)setAdminMark:(BOOL)derStatus fuerZeile:(int)dieZeile;
- (void)setUserMark:(BOOL)derStatus fuerZeile:(int)dieZeile;
- (IBAction)setAufnahmenVonPoLeser:(id)sender;
- (void)setAufnahmenVonLeser:(NSString*)derLeser;
- (void)setAufnahmenTable:(NSArray*)derAufnahmenArray fuerLeser:(NSString*)derLeser;

@end

 @interface rAdminPlayer(rCleanKontroller)
 
- (void)CleanOptionNotificationAktion:(NSNotification*)note;
- (void)CleanViewNotificationAktion:(NSNotification*)note;
- (void)ClearNotificationAktion:(NSNotification*)note;
- (void)Clean:(NSDictionary*)derCleanDic;
//- (void)insMagazinMitPfad:(NSString*)derAufnahmePfad;

- (void)setCleanTitelVonLeser:(NSString*)derLeser;
- (void)setAlleTitel;

 @end
#pragma mark -
 @interface rAdminPlayer(rExportKontroller)
- (int)ExportPrefsLesen;
- (int)ExportPrefsSchreiben;
- (OSErr)getExportEinstellungenvonAufnahme:(NSString*)derAufnahmePfad;
- (OSErr)getExportEinstellungen;
- (IBAction) AufnahmeExportieren:(id)sender;
- (int) AufnahmeExportierenMitPfad:(NSString*)derAufnahmePfad 
					 mitUserDialog:(BOOL)userDialogOK
				 mitSettingsDialog:(BOOL)settingsDialogOK;
- (void) AufnahmenArrayExportieren:(NSArray*)derAufnahmenArray mitUserDialog:(BOOL)userDialogOK;
- (void)ExportNotificationAktion:(NSNotification*)note;
- (void)Export:(NSDictionary*)derExportDic;
@end

#pragma mark -
@interface rAdminPlayer(rThreadKontroller)
- (void)setThreadKontroller;
- (NSData *)dataRepresentationOfType:(NSString *)aType;
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType;
	// methods
- (IBAction)usePOSIXThreads:(id)sender;
- (IBAction)useMainThread:(id)sender;
- (IBAction)toggleThreadGuard:(id)sender;
- (IBAction)ignoreUnsafeTypes:(id)sender;

- (IBAction)doButton:(id)sender;
- (IBAction)selectMovie:(id)sender;
- (IBAction)doExport:(id)sender;

//- (NSSize)windowContentSizeForMovie:(Movie)qtMovie;
//- (void)releaseThreadData:(ThreadData *)threadData;
//- (int)AufnahmeInThreadExportierenMitPfad:(NSString*)derAufnahmePfad 
//					 mitUserDialog:(BOOL)userDialogOK
//				 mitSettingsDialog:(BOOL)settingsDialogOK;

 @end