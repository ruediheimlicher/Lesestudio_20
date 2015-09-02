//
//  ViewController.h
//  Lesestudio_20
//
//  Created by Ruedi Heimlicher on 01.09.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <objc/runtime.h>

#import "rAbspielanzeige.h"
#import "rLevelmeter.h"
#import "rEinstellungen.h"
#import "rProjektListe.h"

#import "rUtils.h"

#import "rArchivDS.h"
#import "rArchivView.h"
#import "rAVRecorder.h"
#import "rAVPlayer.h"

#import "rAdminPlayer.h"
#import "rVertikalanzeige.h"



@protocol ExportProgressWindowControllerDelegate;
@class AVAssetExportSession;



@interface ViewController : NSViewController
{
   // Panels
   rUtils*  Utils;
   rVolumes*                        VolumesPanel;
   rProjektStart*                   ProjektStartPanel;
   rProjektListe*                   ProjektPanel;
   rProjektNamen*                   ProjektNamenPanel;
   rEinstellungen*						EinstellungenFenster;
   rPasswortListe*						PasswortListePanel;
   rTitelListe*                     TitelListePanel;
   rAVRecorder*                     AVRecorder;
   
   rAdminPlayer*						   AdminPlayer;
   
   IBOutlet NSWindow*              RecorderFenster;
   IBOutlet rAbspielanzeige*			Abspielanzeige;
   IBOutlet   rVertikalanzeige*       Vertikalanzeige;
   rAVPlayer*  AVAbspielplayer;
   NSString*	RPAufnahmenDirIDKey;;
   NSString *	Wert1Key;
   NSString *	Wert2Key;
   NSString *	RPModusKey;
   NSString *	RPBewertungKey;
   NSString *	RPNoteKey;
   NSString *	RPStartStatusKey;
   
   
   //   NSTimer* AufnahmeTimer;
   NSTimer* WiedergabeTimer;
   int      AufnahmeZeit;
   int      WiedergabeZeit;
   NSTimer *AufnahmeTimer;
   int aufnahmetimerstatus;
   double startzeit;
   
}


@end

