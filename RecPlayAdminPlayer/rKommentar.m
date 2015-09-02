#import "rKommentar.h"

enum
{lastKommentarOption= 0,
	heuteKommentarOption,
	lastVonTitelKommOption
};
enum
{alsTabelleFormatOption=0,
	alsAbsatzFormatOption
};

@implementation rKommentar
- (id) init
{
	self=[super initWithWindowNibName:@"RPKommentar"];
	OptionAString=[[NSString alloc]init];
	OptionBString=[[NSString alloc]init];
	return self;
}

- (void)awakeFromNib
{
	//NSLog(@"Kommentar awakeFromNib");
	TitelArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	NamenArray=[[NSMutableArray alloc]initWithCapacity:0];
	[ProjektMatrix setDelegate:self];
}

- (void)setAuswahlPop:(int)dieAuswahlOption
{
	[AuswahlPopMenu selectItemAtIndex:dieAuswahlOption];
	AuswahlOption=dieAuswahlOption;
}


- (void)setPopAMenu:(NSArray*)derArray erstesItem:(NSString*)dasItem aktuell:(NSString*)aktuellerString
{
	NSLog(@"setPopAMenu  derArray: %@ erstesItem: %@ aktuell: %@",[derArray description], dasItem, aktuellerString);
	NSString* alle=NSLocalizedString(@"All",@"alle");
	//NSString* namenwaehlen=@"Namen wählen";
	//[PopAMenu synchronizeTitleAndSelectedItem];
	[PopAMenu setEnabled:YES];
	[AnzahlPop setEnabled:YES];
	[PopAMenu removeAllItems];
	if (dasItem)
	{
		//NSLog(@"setPopAMenu: erstesItem nicht NULL");
		[PopAMenu addItemWithTitle:dasItem];
	}
	if (derArray)
	{
	[PopAMenu addItemsWithTitles:derArray];
	}
	if (aktuellerString&&[aktuellerString length])
	  {
		[PopAMenu selectItemWithTitle:aktuellerString];
	  }
	else
	  {
		//[PopAMenu selectItemWithTitle:alle];
	  }
	//[derNamenArray release];
	//return erfolg;
}

- (void)resetPopAMenu
{
	//NSString* auswaehlen=@"auswählen";
	[PopAMenu removeAllItems];
	//[PopAMenu addItemWithTitle:auswaehlen];
	[PopAMenu setEnabled:NO];
	//[AnzahlPop setEnabled:NO];

}


- (void)setPopBMenu:(NSArray*)derArray erstesItem:(NSString*)dasItem aktuell:(NSString*)aktuellerString mitPrompt:(NSString*)dasPrompt
{
		NSLog(@"setPopBMenu  derArray: %@ erstesItem: %@ aktuell: %@ Prompt: %@",[derArray description], dasItem, aktuellerString, dasPrompt);

	NSString* alle=NSLocalizedString(@"All",@"alle");
	//NSString* namenwaehlen=@"Namen wählen";
	[PopBMenu setEnabled:YES];
	[AnzahlPop setEnabled:YES];
	[PopBPrompt setStringValue:dasPrompt];
	[PopBMenu removeAllItems];
	if (dasItem)
	{
		//NSLog(@"setPopBMenu: erstesItem nicht NULL");
		[PopBMenu addItemWithTitle:dasItem];
	}
	[PopBMenu addItemsWithTitles:derArray];
	//NSLog(@"in setPopBMenu %@  aktuell: %@",[derArray description], aktuellerString);
	if (aktuellerString )//&&[aktuellerString length])
	  {
		[PopBMenu selectItemWithTitle:aktuellerString];
		//NSLog(@"setPopBMenu2");
	  }
	else
	  {
	  }
}

- (void)resetPopBMenu
{
	//NSString* auswaehlen=@"auswählen";
	[PopBMenu removeAllItems];
	[PopBMenu setEnabled:NO];
	[PopBPrompt setStringValue:@""];
	//[AnzahlPop setEnabled:NO];
	
}


- (void) setAnzahlPopMenu:(int)dieAnzahl
{
	NSString* alle=NSLocalizedString(@"All",@"alle");
	if (dieAnzahl==99)
	  {
		[AnzahlPop selectItemWithTitle:alle];
	  }
	else
	  {
	[AnzahlPop selectItemWithTitle:[[NSNumber numberWithInt:dieAnzahl]stringValue]];
	  }
}

- (void)setProjektMenu:(NSArray*)derProjektMenuArray mitItem:(NSString*)dasProjektItem
{
	//NSLog(@"setProjektMenu: derProjektMenuArray: %@",[derProjektMenuArray description]);

	[ProjektPopMenu setEnabled:YES];
	[ProjektPopPrompt setStringValue:NSLocalizedString(@"Project: ",@"Projekt: ")];
	[ProjektPopMenu removeAllItems];
	if ([derProjektMenuArray count])
	{
		[ProjektPopMenu addItemsWithTitles:derProjektMenuArray];
	}
	if ([ProjektPopMenu indexOfItemWithTitle:dasProjektItem]>=0)
	{
		[ProjektPopMenu selectItemWithTitle:dasProjektItem];
	}
}


- (void)setNurMarkierteOption:(int)nurMarkierte
{
	[nurMarkierteCheck setState:nurMarkierte];
}


- (void)setKommentar:(NSString*)derKommentarString
{
	
if ([derKommentarString length]==0)
	return;
	NSString* ProjektTitel=@"Deutsch";
	KommentarString=[derKommentarString copy];
	//[KommentarString release];
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	//NSLog(@"*KommentarFenster  setKommentar* %@",derKommentarString);
	
	NSCalendarDate* heute=[NSCalendarDate date];
	[heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
	
	NSString* TitelString=@"Anmerkungen vom ";
	NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r\r"];
	
	//Font für Titelzeile
	NSFont* TitelFont;
	TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
	
	//Stil für Titelzeile
	NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
	[TitelStil setTabStops:[NSArray array]];//default weg
	NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
	
	[TitelStil addTabStop:TitelTab1];
	
	//Attr-String für Titelzeile zusammensetzen
	NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString]; 
	[attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
	[attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
	
	//titelzeile einsetzen
	[[KommentarView textStorage]setAttributedString:attrTitelString];
	


	//Font für Projektzeile
	NSFont* ProjektFont;
	ProjektFont=[NSFont fontWithName:@"Helvetica" size: 12];
	
	NSString* ProjektString=NSLocalizedString(@"Project: ",@"Projekt: ");
	NSString* ProjektKopfString=[NSString stringWithFormat:@"%@    %@%@",ProjektString,ProjektTitel,@"\r"];

	//Stil für Projektzeile
	NSMutableParagraphStyle* ProjektStil=[[NSMutableParagraphStyle alloc]init];
	[ProjektStil setTabStops:[NSArray array]];//default weg
	NSTextTab* ProjektTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:150];
	[ProjektStil addTabStop:ProjektTab1];
	
	//Attr-String für Projektzeile zusammensetzen
	NSMutableAttributedString* attrProjektString=[[NSMutableAttributedString alloc] initWithString:ProjektKopfString]; 
	[attrProjektString addAttribute:NSParagraphStyleAttributeName value:ProjektStil range:NSMakeRange(0,[ProjektKopfString length])];
	[attrProjektString addAttribute:NSFontAttributeName value:ProjektFont range:NSMakeRange(0,[ProjektKopfString length])];
	
	//Projektzeile einsetzen
	[[KommentarView textStorage]appendAttributedString:attrProjektString];
	
	//Stil für Abstand1
	NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
	NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 8];
	NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
	[attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
	[attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
	//Abstandzeile einsetzen
	[[KommentarView textStorage]appendAttributedString:attrAbstand1String];
	
	
	NSMutableString* TextString=[derKommentarString mutableCopy];
	int pos=[TextString length]-1;
	BOOL letzteZeileWeg=NO;
	if ([TextString characterAtIndex:pos]=='\r')
	{
		//NSLog(@"last Char ist r");
		//[TextString deleteCharactersInRange:NSMakeRange(pos-1,1)];
		letzteZeileWeg=YES;
		pos--;
	}
	
	if([TextString characterAtIndex:pos]=='\n')
	  {
		NSLog(@"last Char ist n");
	  }
	
	AuswahlOption=[[AuswahlPopMenu selectedCell]tag];

	//NSLog(@"*KommentarFenster  setKommentar textString: %@  AuswahlOption: %d",TextString, AuswahlOption);
	
	switch ([[AbsatzMatrix selectedCell]tag])
	
	{
		case alsTabelleFormatOption:
		{
			int Textschnitt=10;
			NSFont* TextFont;
			TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
			//NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
			
			NSMutableArray* KommentarArray=(NSMutableArray*)[TextString componentsSeparatedByString:@"\r"];
			if (letzteZeileWeg)
			  {
				//NSLog(@"letzteZeileWeg");
				[KommentarArray removeLastObject];
			  }
			[Anz setIntValue:[KommentarArray count]-1];
			NSString* titel=NSLocalizedString(@"Title:",@"Titel:");
			//char * tb=[titel lossyCString];
			const char * tb=[titel cStringUsingEncoding:NSMacOSRomanStringEncoding];
            int Titelbreite=strlen(tb);
			NSString* name=NSLocalizedString(@"Name",@"Name:");
			//char * nb=[name lossyCString];
            const char * nb=[name cStringUsingEncoding:NSMacOSRomanStringEncoding];
			int Namenbreite=strlen(nb);
			
			int i;
			
			//Länge von Name und Titel feststellen
			for (i=0;i<[KommentarArray count];i++)
			  {
				
				//if ([KommentarArray objectAtIndex:i])
				  {
					//NSLog(@"%@KommentarArray Zeile: %d %@",@"\r",i,[KommentarArray objectAtIndex:i]);
				NSArray* ZeilenArray=[[KommentarArray objectAtIndex:i]componentsSeparatedByString:@"\t"];
				if ([ZeilenArray count]>1)
				  {
					//char * nc=[[ZeilenArray objectAtIndex:0]lossyCString];
					const char * nc=[[ZeilenArray objectAtIndex:0] cStringUsingEncoding:NSMacOSRomanStringEncoding];
                      int nl=strlen(nc);
					if(nl>Namenbreite)
						Namenbreite=nl;
					//char * tc=[[ZeilenArray objectAtIndex:1]lossyCString];
                    const char * tc=[[ZeilenArray objectAtIndex:1] cStringUsingEncoding:NSMacOSRomanStringEncoding];
					int tl=strlen(tc);
					if(tl>Titelbreite)
						Titelbreite=tl;

					//NSLog(@"tempNamenbreite: %d  Titelbreite: %d",nl, tl);
				  }
				  }
			  }
			//NSLog(@"Namenbreite: %d  Titelbreite: %d",Namenbreite, Titelbreite);
			
			//Tabulatoren aufaddieren
			float titeltab=120;
			
			titeltab=Namenbreite*(3*Textschnitt/5);
			float datumtab=260;
			
			datumtab=titeltab+Titelbreite*(3*Textschnitt/5);
			float bewertungtab=325;
			bewertungtab=datumtab+12*(3*Textschnitt/5);
			float notetab=380;
			notetab=bewertungtab+12*(3*Textschnitt/5);
			float anmerkungentab=410;
			anmerkungentab=notetab+8*(3*Textschnitt/5);

			NSMutableParagraphStyle* TabellenKopfStil=[[NSMutableParagraphStyle alloc]init];
			[TabellenKopfStil setTabStops:[NSArray array]];
			NSTextTab* TabellenkopfTitelTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:titeltab];
			[TabellenKopfStil addTabStop:TabellenkopfTitelTab];
			NSTextTab* TabellenkopfDatumTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:datumtab];
			[TabellenKopfStil addTabStop:TabellenkopfDatumTab];
			NSTextTab* TabellenkopfBewertungTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:bewertungtab];
			[TabellenKopfStil addTabStop:TabellenkopfBewertungTab];
			NSTextTab* TabellenkopfNoteTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:notetab];
			[TabellenKopfStil addTabStop:TabellenkopfNoteTab];
			NSTextTab* TabellenkopfAnmerkungenTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:anmerkungentab];
			[TabellenKopfStil addTabStop:TabellenkopfAnmerkungenTab];
			[TabellenKopfStil setParagraphSpacing:4];

			
			NSMutableParagraphStyle* TabelleStil=[[NSMutableParagraphStyle alloc]init];
			[TabelleStil setTabStops:[NSArray array]];
			NSTextTab* TabelleTitelTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:titeltab];
			[TabelleStil addTabStop:TabelleTitelTab];
			NSTextTab* TabelleDatumTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:datumtab];
			[TabelleStil addTabStop:TabelleDatumTab];
			NSTextTab* TabelleBewertungTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:bewertungtab];
			[TabelleStil addTabStop:TabelleBewertungTab];
			NSTextTab* TabelleNoteTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:notetab];
			[TabelleStil addTabStop:TabelleNoteTab];
			NSTextTab* TabelleAnmerkungenTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:anmerkungentab];
			[TabelleStil addTabStop:TabelleAnmerkungenTab];
			[TabelleStil setHeadIndent:anmerkungentab];
			[TabelleStil setParagraphSpacing:2];

			//Kommentarstring in Komponenten aufteilen
			//NSString* TabellenkopfString=[[KommentarArray objectAtIndex:0]stringByAppendingString:@"\r"];
			NSMutableString* TabellenkopfString=[[KommentarArray objectAtIndex:0]mutableCopy];
			int lastBuchstabenPos=[TabellenkopfString length]-1;
			//NSLog(@"TabellenkopfString: %@   length: %d  last: %d",TabellenkopfString,lastBuchstabenPos,[TabellenkopfString characterAtIndex:lastBuchstabenPos] );
			
			
			if([TabellenkopfString characterAtIndex:lastBuchstabenPos]=='\n')
				{
					NSLog(@"TabellenkopfString: last Char ist n");
				}
			if([TabellenkopfString characterAtIndex:lastBuchstabenPos]=='\r')
				{
					NSLog(@"TabellenkopfString: last Char ist r");
				}
			[TabellenkopfString deleteCharactersInRange:NSMakeRange(lastBuchstabenPos,1)];
			NSMutableAttributedString* attrKopfString=[[NSMutableAttributedString alloc] initWithString:TabellenkopfString];
			[attrKopfString addAttribute:NSParagraphStyleAttributeName value:TabellenKopfStil range:NSMakeRange(0,[TabellenkopfString length])];
			[attrKopfString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TabellenkopfString length])];
			[[KommentarView textStorage]appendAttributedString:attrKopfString];
			
				//Stil für Abstand2
	NSMutableParagraphStyle* Abstand2Stil=[[NSMutableParagraphStyle alloc]init];
	NSFont* Abstand2Font=[NSFont fontWithName:@"Helvetica" size: 2];
	NSMutableAttributedString* attrAbstand2String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
	[attrAbstand2String addAttribute:NSParagraphStyleAttributeName value:Abstand2Stil range:NSMakeRange(0,1)];
	[attrAbstand2String addAttribute:NSFontAttributeName value:Abstand2Font range:NSMakeRange(0,1)];

	[[KommentarView textStorage]appendAttributedString:attrAbstand2String];
	
	
		
			
			NSString* cr=@"\r";
			//NSAttributedString*CR=[[[NSAttributedString alloc]initWithString:cr]autorelease];
			int index=1;
			if ([KommentarArray count]>1)
			  {
			for (index=1;index<[KommentarArray count];index++)
				{
				NSString* tempZeile=[KommentarArray objectAtIndex:index];
				 
				if ([tempZeile length]>1)
				  {	
					NSString* tempString=[tempZeile substringToIndex:[tempZeile length]-1];
					NSString* tempArrayString=[NSString stringWithFormat:@"%@%@",tempString, cr];
					
					NSMutableAttributedString* attrTextString=[[NSMutableAttributedString alloc] initWithString:tempArrayString]; 
					[attrTextString addAttribute:NSParagraphStyleAttributeName value:TabelleStil range:NSMakeRange(0,[tempArrayString length])];
					[attrTextString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[tempArrayString length])];
					[[KommentarView textStorage]appendAttributedString:attrTextString];
					//NSLog(@"Ende setKommentar: attrTextString retainCount: %d",[attrTextString retainCount]);
					
				  }
				}//for index
			  }//if count>1
		}break;//alsTabelleFormatOption
		
		case alsAbsatzFormatOption:
		{
			NSFont* TextFont;
			TextFont=[NSFont fontWithName:@"Helvetica" size: 12];
			NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
			
			NSMutableParagraphStyle* AbsatzStil=[[NSMutableParagraphStyle alloc]init];
			[AbsatzStil setTabStops:[NSArray array]];
			NSTextTab* AbsatzTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
			[AbsatzStil addTabStop:AbsatzTab1];
			[AbsatzStil setHeadIndent:90];
			//[AbsatzStil setParagraphSpacing:4];

			NSMutableAttributedString* attrTextString=[[NSMutableAttributedString alloc] initWithString:TextString]; 
			[attrTextString addAttribute:NSParagraphStyleAttributeName value:AbsatzStil range:NSMakeRange(0,[TextString length])];
			
			[attrTextString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TextString length])];
			
			[[KommentarView textStorage]appendAttributedString:attrTextString];
			//NSLog(@"Ende setKommentar: attrTextString retainCount: %d",[attrTextString retainCount]);

			
		}break;//alsAbsatzFormatOption
	}//Auswahloption
		
	//NSLog(@"Ende setKommentar: TitelStil retainCount: %d",[TitelStil retainCount]);
	//NSLog(@"Ende setKommentar: attrTitelString retainCount: %d",[attrTitelString retainCount]);
	//NSLog(@"Ende setKommentar: TitelTab1 retainCount: %d",[TitelTab1 retainCount]);
	//[TitelTab1 release];
	//NSLog(@"Ende setKommentar%@",@"\r***\r\r\r");//: attrTitelString retainCount: %d",[attrTitelString retainCount]);

}

- (void)setKommentarMitKommentarDicArray:(NSArray*)derKommentarDicArray
{
	
	if ([derKommentarDicArray count]==0)
		return;
	
	
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	//NSLog(@"*KommentarFenster  setKommentar* %@",derKommentarString);
	
	NSCalendarDate* heute=[NSCalendarDate calendarDate];
	[heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
	
	NSString* TitelString=NSLocalizedString(@"Comments from ",@"Anmerkungen vom ");
	NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r\r"];
	
	//Font für Titelzeile
	NSFont* TitelFont;
	TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
	
	//Stil für Titelzeile
	NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
	[TitelStil setTabStops:[NSArray array]];//default weg
	NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
	
		//Stil für Abstand12
	NSMutableParagraphStyle* Abstand12Stil=[[NSMutableParagraphStyle alloc]init];
	NSFont* Abstand12Font=[NSFont fontWithName:@"Helvetica" size: 12];
	NSMutableAttributedString* attrAbstand12String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
	[attrAbstand12String addAttribute:NSParagraphStyleAttributeName value:Abstand12Stil range:NSMakeRange(0,1)];
	[attrAbstand12String addAttribute:NSFontAttributeName value:Abstand12Font range:NSMakeRange(0,1)];
	//Abstandzeile einsetzen

	
	[TitelStil addTabStop:TitelTab1];
	
	//Attr-String für Titelzeile zusammensetzen
	NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString]; 
	[attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
	[attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
	
	//titelzeile einsetzen
	[[KommentarView textStorage]setAttributedString:attrTitelString];
	
	
	//Breite von variablen Feldern
	int maxNamenbreite=12;
	int maxTitelbreite=12;
	int Textschnitt=10;
	int AnzahlAnmerkungen=0;
	
	NSEnumerator* TabEnum=[derKommentarDicArray objectEnumerator];
	id einTabDic;
	//NSLog(@"setKommentarMit Komm.DicArray: vor while   Anz. Dics: %d",[derKommentarDicArray count]);
	
	while (einTabDic=[TabEnum nextObject])//erster Durchgang: Länge von Namen und Titel bestimmen
	{
		//NSLog(@"einTabDic: %@",[einTabDic description]);
		NSString* ProjektTitel;
		NSString* KommentarString;
		if ([einTabDic objectForKey:@"projekt"])
		{
			ProjektTitel=[einTabDic objectForKey:@"projekt"];
			//NSLog(@"ProjektTitel: %@",ProjektTitel);
			
			if ([einTabDic objectForKey:@"kommentarstring"])
			{
				NSMutableString* TextString=[[einTabDic objectForKey:@"kommentarstring"] mutableCopy];
				int pos=[TextString length]-1;
				BOOL letzteZeileWeg=NO;
				if ([TextString characterAtIndex:pos]=='\r')
				{
					letzteZeileWeg=YES;
					pos--;
				}
				
				if([TextString characterAtIndex:pos]=='\n')
				{
					NSLog(@"last Char ist n");
				}
				NSFont* TextFont;
				TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
				//NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
				
				NSMutableArray* KommentarArray=(NSMutableArray*)[TextString componentsSeparatedByString:@"\r"];
				if (letzteZeileWeg)
				{
					//NSLog(@"letzteZeileWeg");
					[KommentarArray removeLastObject];
				}
				//[Anz setIntValue:[KommentarArray count]-1];
				AnzahlAnmerkungen+=[KommentarArray count]-1;
				NSString* titel=NSLocalizedString(@"Title:",@"Titel:");
				//char * tb=[titel lossyCString];
                const char * tb=[titel cStringUsingEncoding:NSMacOSRomanStringEncoding];
				int Titelbreite=strlen(tb);//Minimalbreite für Tabellenkopf von Titel
					if (Titelbreite>maxTitelbreite)
					{
						maxTitelbreite=Titelbreite;
					}
					NSString* name=NSLocalizedString(@"Name",@"Name:");
					//char * nb=[name lossyCString];
                    const char * nb=[name cStringUsingEncoding:NSMacOSRomanStringEncoding];
					int Namenbreite=strlen(nb);//Minimalbreite für Tabellenkopf von Name
						if (Namenbreite>maxNamenbreite)
						{
							maxNamenbreite=Namenbreite;
						}
						//NSLog(@"Tabellenkopf: Namenbreite: %d  Titelbreite: %d",Namenbreite, Titelbreite);
						
						int i;
						
						//Länge von Name und Titel feststellen
						for (i=0;i<[KommentarArray count];i++)
						{
							
							//if ([KommentarArray objectAtIndex:i])
							
							//NSLog(@"%@KommentarArray Zeile: %d %@",@"\r",i,[KommentarArray objectAtIndex:i]);
							NSArray* ZeilenArray=[[KommentarArray objectAtIndex:i]componentsSeparatedByString:@"\t"];
							if ([ZeilenArray count]>1)
							{
								//char * nc=[lossyCString];
                                const char * nc=[[ZeilenArray objectAtIndex:0]cStringUsingEncoding:NSMacOSRomanStringEncoding];
								int nl=strlen(nc);
								if(nl>Namenbreite)
									Namenbreite=nl;
								
								//char * tc=[[ZeilenArray objectAtIndex:1]lossyCString];
                                const char * tc=[[ZeilenArray objectAtIndex:1] cStringUsingEncoding:NSMacOSRomanStringEncoding];
								int tl=strlen(tc);
								if(tl>Titelbreite)
									Titelbreite=tl;
								//NSLog(@"tempNamenbreite: %d  Titelbreite: %d",nl, tl);
							}
							
						}
						
						//NSLog(@"Namenbreite: %d  Titelbreite: %d",Namenbreite, Titelbreite);
						if (Namenbreite>maxNamenbreite)
						{
							maxNamenbreite=Namenbreite;
						}
						if (Titelbreite>maxTitelbreite)
						{
							maxTitelbreite=Titelbreite;
						}
						//NSLog(@"maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
			}//if Kommentarstring
		}//if einProjekt
	}//while Wortlängen bestimmen
	
	
	//Anmerkungen einsetzen
	
	NSEnumerator* KommentarArrayEnum=[derKommentarDicArray objectEnumerator];
	id einKommentarDic;
	while (einKommentarDic=[KommentarArrayEnum nextObject])//Tabulatoren setzen und Tabelle aufbauen
	{
		//NSLog(@"setKommentarMit Komm.DicArray: Beginn while");
		NSString* ProjektTitel;
		
		if ([einKommentarDic objectForKey:@"projekt"])
		{
			ProjektTitel=[einKommentarDic objectForKey:@"projekt"];
			//NSLog(@"ProjektTitel: %@",ProjektTitel);
		}
		else //Kein Projekt angegeben
		{
			ProjektTitel=@"Kein Projekt";
		}
		
		
		//Font für Projektzeile
		NSFont* ProjektFont;
		ProjektFont=[NSFont fontWithName:@"Helvetica" size: 12];
		
		NSString* ProjektString=NSLocalizedString(@"Project: ",@"Projekt: ");
		NSString* ProjektKopfString=[NSString stringWithFormat:@"%@    %@%@",ProjektString,ProjektTitel,@"\r"];
		
		//Stil für Projektzeile
		NSMutableParagraphStyle* ProjektStil=[[NSMutableParagraphStyle alloc]init];
		[ProjektStil setTabStops:[NSArray array]];//default weg
		NSTextTab* ProjektTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:150];
		[ProjektStil addTabStop:ProjektTab1];
		
		//Attr-String für Projektzeile zusammensetzen
		NSMutableAttributedString* attrProjektString=[[NSMutableAttributedString alloc] initWithString:ProjektKopfString]; 
		[attrProjektString addAttribute:NSParagraphStyleAttributeName value:ProjektStil range:NSMakeRange(0,[ProjektKopfString length])];
		[attrProjektString addAttribute:NSFontAttributeName value:ProjektFont range:NSMakeRange(0,[ProjektKopfString length])];
		
		//Projektzeile einsetzen
		[[KommentarView textStorage]appendAttributedString:attrProjektString];
		
		//Stil für Abstand1
		NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
		NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
		NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
		[attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
		[attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
		//Abstandzeile einsetzen
		[[KommentarView textStorage]appendAttributedString:attrAbstand1String];
		
		NSMutableString* TextString;
		if ([einKommentarDic objectForKey:@"kommentarstring"])
		{
			TextString=[[einKommentarDic objectForKey:@"kommentarstring"]mutableCopy];
		}
		else //Keine Kommentare in diesem Projekt
		{
			TextString=[NSLocalizedString(@"No comments for this Project",@"Keine Kommentare für dieses Projekt") mutableCopy];
		}

		
		int pos=[TextString length]-1;
		BOOL letzteZeileWeg=NO;
		if ([TextString characterAtIndex:pos]=='\r')
		{
			//NSLog(@"last Char ist r");
			//[TextString deleteCharactersInRange:NSMakeRange(pos-1,1)];
			letzteZeileWeg=YES;
			pos--;
		}
		
		if([TextString characterAtIndex:pos]=='\n')
		{
			NSLog(@"last Char ist n");
		}
		
		AuswahlOption=[[AuswahlPopMenu selectedCell]tag];
		
		//NSLog(@"*KommentarFenster  setKommentar textString: %@  AuswahlOption: %d",TextString, AuswahlOption);
		
		switch ([[AbsatzMatrix selectedCell]tag])
			
		{
			case alsTabelleFormatOption:
			{
				//int Textschnitt=10;

				NSFont* TextFont;
				TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
				//NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
				
				NSMutableArray* KommentarArray=(NSMutableArray*)[TextString componentsSeparatedByString:@"\r"];
				if (letzteZeileWeg)
				{
					//NSLog(@"letzteZeileWeg");
					[KommentarArray removeLastObject];
				}
				//[Anz setIntValue:[KommentarArray count]-1];
//
				
				//NSLog(@"2. Runde: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
//				
				//Tabulatoren aufaddieren
				float titeltab=120;
				
				titeltab=maxNamenbreite*(3*Textschnitt/5);
				float datumtab=260;
				
				datumtab=titeltab+maxTitelbreite*(3*Textschnitt/5);
				float bewertungtab=325;
				bewertungtab=datumtab+12*(3*Textschnitt/5);
				float notetab=380;
				notetab=bewertungtab+12*(3*Textschnitt/5);
				float anmerkungentab=410;
				anmerkungentab=notetab+6*(3*Textschnitt/5);
				
				NSMutableParagraphStyle* TabellenKopfStil=[[NSMutableParagraphStyle alloc]init];
				[TabellenKopfStil setTabStops:[NSArray array]];
				NSTextTab* TabellenkopfTitelTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:titeltab];
				[TabellenKopfStil addTabStop:TabellenkopfTitelTab];
				NSTextTab* TabellenkopfDatumTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:datumtab];
				[TabellenKopfStil addTabStop:TabellenkopfDatumTab];
				NSTextTab* TabellenkopfBewertungTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:bewertungtab];
				[TabellenKopfStil addTabStop:TabellenkopfBewertungTab];
				NSTextTab* TabellenkopfNoteTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:notetab];
				[TabellenKopfStil addTabStop:TabellenkopfNoteTab];
				NSTextTab* TabellenkopfAnmerkungenTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:anmerkungentab];
				[TabellenKopfStil addTabStop:TabellenkopfAnmerkungenTab];
				[TabellenKopfStil setParagraphSpacing:4];
				
				
				NSMutableParagraphStyle* TabelleStil=[[NSMutableParagraphStyle alloc]init];
				[TabelleStil setTabStops:[NSArray array]];
				NSTextTab* TabelleTitelTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:titeltab];
				[TabelleStil addTabStop:TabelleTitelTab];
				NSTextTab* TabelleDatumTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:datumtab];
				[TabelleStil addTabStop:TabelleDatumTab];
				NSTextTab* TabelleBewertungTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:bewertungtab];
				[TabelleStil addTabStop:TabelleBewertungTab];
				NSTextTab* TabelleNoteTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:notetab];
				[TabelleStil addTabStop:TabelleNoteTab];
				NSTextTab* TabelleAnmerkungenTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:anmerkungentab];
				[TabelleStil addTabStop:TabelleAnmerkungenTab];
				[TabelleStil setHeadIndent:anmerkungentab];
				[TabelleStil setParagraphSpacing:2];
				
				//Kommentarstring in Komponenten aufteilen
				NSMutableString* TabellenkopfString=[[KommentarArray objectAtIndex:0]mutableCopy];
				int lastBuchstabenPos=[TabellenkopfString length]-1;
				//NSLog(@"TabellenkopfString: %@   length: %d  last: %d",TabellenkopfString,lastBuchstabenPos,[TabellenkopfString characterAtIndex:lastBuchstabenPos] );
				
				
				if([TabellenkopfString characterAtIndex:lastBuchstabenPos]=='\n')
				{
					NSLog(@"TabellenkopfString: last Char ist n");
				}
				if([TabellenkopfString characterAtIndex:lastBuchstabenPos]=='\r')
				{
					NSLog(@"TabellenkopfString: last Char ist r");
				}
				[TabellenkopfString deleteCharactersInRange:NSMakeRange(lastBuchstabenPos,1)];
				NSMutableAttributedString* attrKopfString=[[NSMutableAttributedString alloc] initWithString:TabellenkopfString];
				[attrKopfString addAttribute:NSParagraphStyleAttributeName value:TabellenKopfStil range:NSMakeRange(0,[TabellenkopfString length])];
				[attrKopfString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TabellenkopfString length])];
				[[KommentarView textStorage]appendAttributedString:attrKopfString];
				
				//Stil für Abstand2
				NSMutableParagraphStyle* Abstand2Stil=[[NSMutableParagraphStyle alloc]init];
				NSFont* Abstand2Font=[NSFont fontWithName:@"Helvetica" size: 2];
				NSMutableAttributedString* attrAbstand2String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
				[attrAbstand2String addAttribute:NSParagraphStyleAttributeName value:Abstand2Stil range:NSMakeRange(0,1)];
				[attrAbstand2String addAttribute:NSFontAttributeName value:Abstand2Font range:NSMakeRange(0,1)];
				
				[[KommentarView textStorage]appendAttributedString:attrAbstand2String];
				
				
				
				
				NSString* cr=@"\r";
				//NSAttributedString*CR=[[[NSAttributedString alloc]initWithString:cr]autorelease];
				int index=1;
				if ([KommentarArray count]>1)
				{
					for (index=1;index<[KommentarArray count];index++)
					{
						NSString* tempZeile=[KommentarArray objectAtIndex:index];
						
						if ([tempZeile length]>1)
						{	
							NSString* tempString=[tempZeile substringToIndex:[tempZeile length]-1];
							NSString* tempArrayString=[NSString stringWithFormat:@"%@%@",tempString, cr];
							
							NSMutableAttributedString* attrTextString=[[NSMutableAttributedString alloc] initWithString:tempArrayString]; 
							[attrTextString addAttribute:NSParagraphStyleAttributeName value:TabelleStil range:NSMakeRange(0,[tempArrayString length])];
							[attrTextString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[tempArrayString length])];
							[[KommentarView textStorage]appendAttributedString:attrTextString];
							
						}
					}//for index
				}//if count>1
			}break;//alsTabelleFormatOption
				
			case alsAbsatzFormatOption:
			{
				NSFont* TextFont;
				TextFont=[NSFont fontWithName:@"Helvetica" size: 10];
				NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
				
				NSMutableParagraphStyle* AbsatzStil=[[NSMutableParagraphStyle alloc]init];
				[AbsatzStil setTabStops:[NSArray array]];
				NSTextTab* AbsatzTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
				[AbsatzStil addTabStop:AbsatzTab1];
				[AbsatzStil setHeadIndent:90];
				//[AbsatzStil setParagraphSpacing:4];
				
				NSMutableAttributedString* attrTextString=[[NSMutableAttributedString alloc] initWithString:TextString]; 
				[attrTextString addAttribute:NSParagraphStyleAttributeName value:AbsatzStil range:NSMakeRange(0,[TextString length])];
				
				[attrTextString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TextString length])];
				
				[[KommentarView textStorage]appendAttributedString:attrTextString];
				
				
			}break;//alsAbsatzFormatOption
		}//Auswahloption
			
			//NSLog(@"Ende setKommentar: TitelStil retainCount: %d",[TitelStil retainCount]);
			//NSLog(@"Ende setKommentar: attrTitelString retainCount: %d",[attrTitelString retainCount]);
			//[attrTitelString release];
		//NSLog(@"Ende setKommentar: TitelTab1 retainCount: %d",[TitelTab1 retainCount]);
		//[TitelTab1 release];
		//NSLog(@"Ende setKommentar%@",@"\r***\r\r\r");//: attrTitelString retainCount: %d",[attrTitelString retainCount]);
		//NSLog(@"setKommentarMit Komm.DicArray: Ende while");
	[[KommentarView textStorage]appendAttributedString:attrAbstand12String];//Abstand zu nächstem Projekt 
	[[KommentarView textStorage]appendAttributedString:attrAbstand12String];

}//while Enum
//NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
[Anz setIntValue:AnzahlAnmerkungen];
//NSLog(@"setKommentarMit Komm.DicArray: nach while");
}

- (IBAction)toggleDrawer:(id)sender
{
	//NSLog(@"Drawer:%@",[OptionDrawer description]);
	[OptionDrawer toggle:sender];
}

- (IBAction)reportKommentarOption:(id)sender
{
	NSMutableDictionary* KommentarOptionDic=[[NSMutableDictionary alloc]initWithCapacity:0];

	[AuswahlPopMenu synchronizeTitleAndSelectedItem];
	NSNumber* AuswahlOptionTag;
	AuswahlOptionTag=[NSNumber numberWithInt:[[AuswahlPopMenu selectedCell]tag]];
	//NSMutableDictionary* KommentarOptionDic=[NSMutableDictionary dictionaryWithObject:AuswahlOptionTag forKey:@"Auswahl"];
	
	NSNumber* AbsatzOptionTag;
	AbsatzOption=[[AbsatzMatrix selectedCell]tag];
	AbsatzOptionTag=[NSNumber numberWithInt:[AbsatzMatrix selectedColumn]];
//	NSLog(@"reportKommentarOption:AbsatzOptionTag: %d ",[AbsatzOptionTag intValue]);
	[KommentarOptionDic setObject:AbsatzOptionTag forKey:@"Absatz"];

//	NamenOptionString=[[PopAMenu selectedItem]description];
	NamenOptionString=[PopAMenu titleOfSelectedItem];
	[KommentarOptionDic setObject:NamenOptionString forKey:@"PopA"];
//NSLog(@"reportKommentarOption:A");
	NSNumber* AnzahlOptionTag;
	AnzahlOption=[[AnzahlPop selectedCell]tag];
//NSLog(@"reportKommentarOption:B");
	AnzahlOptionTag=[NSNumber numberWithInt:[[AnzahlPop selectedCell]tag]];
	NSLog(@"reportKommentarOption:C");
	[KommentarOptionDic setObject:AnzahlOptionTag forKey:@"Anzahl"];

	NSLog(@"reportKommentarOption:%@ ",[KommentarOptionDic description]);
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:KommentarOptionDic];
	

}

- (int)AuswahlOption
{
	return [ProjektMatrix selectedRow];
}

- (int)AbsatzOption
{
	return [AbsatzMatrix selectedRow];
}

- (BOOL)nurMarkierte
{
//NSLog(@"nurMarkierte: %d",[nurMarkierteCheck state]);
return [nurMarkierteCheck state];
}



- (IBAction)nurMarkierteOption:(id)sender
{
//NSLog(@"setAuswahl: %d",[[sender selectedCell]tag]);
	int nurMarkierteOK=[sender state];
	NSNumber* nurMarkierteNumber =[NSNumber numberWithInt:nurMarkierteOK];
	
	NSMutableDictionary* KommentarOptionDic=[NSMutableDictionary dictionaryWithObject:nurMarkierteNumber forKey:@"nurMarkierte"];
	if (NamenOptionString)
	{
	}
	

	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:KommentarOptionDic];

}

- (NSString*)PopAOption
{
	return [PopAMenu  titleOfSelectedItem];
}


- (NSString*)PopBOption
{
	return [PopBMenu  titleOfSelectedItem];
}


- (IBAction)reportAuswahl:(id)sender
{
	NSLog(@"setAuswahl: %d",[[sender selectedCell]tag]);
	AuswahlOption=[[sender selectedCell]tag];
	[AnzahlPop setEnabled:AuswahlOption>0];
	NSNumber* AuswahlOptionNumber =[NSNumber numberWithInt:AuswahlOption];
	
	NSMutableDictionary* KommentarOptionDic=[NSMutableDictionary dictionaryWithObject:AuswahlOptionNumber forKey:@"Auswahl"];
	if (NamenOptionString)
	{
	}

	[KommentarOptionDic setObject:[ProjektPopMenu titleOfSelectedItem]forKey:@"projektname"];
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:KommentarOptionDic];
	//NSLog(@"Ende setAuswahl");
}

- (IBAction)reportAnzahl:(id)sender
{
	NSLog(@"reportAnzahl: %d",[[sender selectedCell]tag]);
	AnzahlOption=[[sender selectedCell]tag];
	NSNumber* AnzahlOptionNumber =[NSNumber numberWithInt:AnzahlOption];
	
	NSMutableDictionary* KommentarOptionDic=[NSMutableDictionary dictionaryWithObject:AnzahlOptionNumber forKey:@"Anzahl"];
	[KommentarOptionDic setObject:[ProjektPopMenu titleOfSelectedItem]forKey:@"projektname"];
	NSLog(@"reportAnzahl: KommentarOptionDic: %@",[KommentarOptionDic description]);
	if (NamenOptionString)
	{
	}

	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:KommentarOptionDic];
	
}
- (IBAction)reportPopA:(id)sender
{
	NSLog(@"reportPopA: %@",[sender titleOfSelectedItem]);
	NamenOptionString=[sender titleOfSelectedItem];
	
	NSMutableDictionary* KommentarOptionDic=[NSMutableDictionary dictionaryWithObject:NamenOptionString forKey:@"PopA"];
	
	[KommentarOptionDic setObject:[NSNumber numberWithInt:[ProjektPopMenu tag]]forKey:@"tag"];
	[KommentarOptionDic setObject:[ProjektPopMenu titleOfSelectedItem]forKey:@"projektname"];
	
	
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:KommentarOptionDic];
	
}
- (IBAction)reportPopB:(id)sender
{
	//NSLog(@"reportPopB: %@",[sender titleOfSelectedItem]);
	TitelOptionString=[sender titleOfSelectedItem];
	
	NSMutableDictionary* KommentarOptionDic=[NSMutableDictionary dictionaryWithObject:TitelOptionString forKey:@"PopB"];
	[KommentarOptionDic setObject:[ProjektPopMenu titleOfSelectedItem]forKey:@"projektname"];
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:KommentarOptionDic];
	
}

- (IBAction)reportProjektNamenOption:(id)sender
{
	NSLog(@"setProjektNamenOption: %@ Index: %d",[sender titleOfSelectedItem],[sender indexOfSelectedItem]);
	ProjektOption=[sender indexOfSelectedItem];
	NSMutableDictionary* ProjektOptionDic=[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:ProjektOption] forKey:@"projektnamenoption"];
	[ProjektOptionDic setObject:[sender titleOfSelectedItem] forKey:@"projektname"];
	
	
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:ProjektOptionDic];
	
	//[self setPopAMenu:NULL erstesItem:@"alle" aktuell:NULL];
	
	//[self setAuswahlPop:lastKommentarOption];
	//[self resetPopBMenu];
}


- (IBAction)reportProjektAuswahlOption:(id)sender
{
	NSLog(@"setProjektAuswahlOption: %d Index: %d",[sender selectedRow],[sender selectedRow]);
	ProjektOption=[[ProjektMatrix selectedCell]tag];
	switch (ProjektOption)
	{
		case 0: //nur ein Projekt
		{
			[ProjektPopMenu setEnabled:YES];
		}break;
		case 1://nur aktive Projekte
		{
			[ProjektPopMenu setEnabled:NO];
		}break;
		case 2://alle Projekte
		{
			[ProjektPopMenu setEnabled:NO];
		}break;
	}//switch
	NSMutableDictionary* ProjektOptionDic=[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:ProjektOption] forKey:@"projektauswahloption"];
	[ProjektOptionDic setObject:[ProjektPopMenu titleOfSelectedItem]forKey:@"projektname"];

	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"KommentarOption" object: self userInfo:ProjektOptionDic];
	
}

- (NSTextView*)setDruckKommentarMitKommentarDicArray:(NSArray*)derKommentarDicArray
											 mitFeld:(NSRect)dasFeld
{
	//NSLog(@"setDruckKommentarMitKommentarDicArray: KommentarDicArray: %@",[derKommentarDicArray description]);
	NSTextView* DruckKommentarView=[[NSTextView alloc]initWithFrame:dasFeld];
	//[DruckKommentarView retain];
	if ([derKommentarDicArray count]==0)
	{
	NSLog(@"setDruckKommentarMitKommentarDicArray: kein KommentarDicArray");
		return 0;
	}
	
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	//NSLog(@"*KommentarFenster  setDruckKommentarMitKommentarDicArray* %@",[[derKommentarDicArray valueForKey:@"kommentarstring"]description]);
	
	NSCalendarDate* heute=[NSCalendarDate date];
	[heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
	
	NSString* TitelString=NSLocalizedString(@"Comments from ",@"Anmerkungen vom ");
	NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r\r"];
	
	//Font für Titelzeile
	NSFont* TitelFont;
	TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
	
	//Stil für Titelzeile
	NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
	[TitelStil setTabStops:[NSArray array]];//default weg
	NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
	
		//Stil für Abstand12
	NSMutableParagraphStyle* Abstand12Stil=[[NSMutableParagraphStyle alloc]init];
	NSFont* Abstand12Font=[NSFont fontWithName:@"Helvetica" size: 12];
	NSMutableAttributedString* attrAbstand12String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
	[attrAbstand12String addAttribute:NSParagraphStyleAttributeName value:Abstand12Stil range:NSMakeRange(0,1)];
	[attrAbstand12String addAttribute:NSFontAttributeName value:Abstand12Font range:NSMakeRange(0,1)];
	//Abstandzeile einsetzen

	
	[TitelStil addTabStop:TitelTab1];
	
	//Attr-String für Titelzeile zusammensetzen
	NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString]; 
	[attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
	[attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
	
	//titelzeile einsetzen
	[[DruckKommentarView textStorage]setAttributedString:attrTitelString];
	
	
	//Breite von variablen Feldern
	int maxNamenbreite=12;
	int maxTitelbreite=12;
	int Textschnitt=10;
	
	NSEnumerator* TabEnum=[derKommentarDicArray objectEnumerator];
	id einTabDic;
	NSLog(@"setDruckKommentarMit Komm.DicArray: vor while   Anz. Dics: %d",[derKommentarDicArray count]);
	
	while (einTabDic=[TabEnum nextObject])//erster Durchgang: Länge von Namen und Titel bestimmen
	{
		NSString* ProjektTitel;
		NSString* KommentarString;
		if ([einTabDic objectForKey:@"projekt"])
		{
			ProjektTitel=[einTabDic objectForKey:@"projekt"];
			//NSLog(@"ProjektTitel: %@",ProjektTitel);
			
			if ([einTabDic objectForKey:@"kommentarstring"])
			{
				NSMutableString* TextString=[[einTabDic objectForKey:@"kommentarstring"] mutableCopy];
				int pos=[TextString length]-1;
				BOOL letzteZeileWeg=NO;
				if ([TextString characterAtIndex:pos]=='\r')
				{
					letzteZeileWeg=YES;
					pos--;
				}
				
				if([TextString characterAtIndex:pos]=='\n')
				{
					NSLog(@"last Char ist n");
				}
				NSFont* TextFont;
				TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
				//NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
				
				NSMutableArray* KommentarArray=(NSMutableArray*)[TextString componentsSeparatedByString:@"\r"];
				if (letzteZeileWeg)
				{
					//NSLog(@"letzteZeileWeg");
					[KommentarArray removeLastObject];
				}
				[Anz setIntValue:[KommentarArray count]-1];
				NSString* titel=NSLocalizedString(@"Title:",@"Titel:");
				//char * tb=[titel lossyCString];
                const char * tb=[titel cStringUsingEncoding:NSMacOSRomanStringEncoding];
				int Titelbreite=strlen(tb);//Minimalbreite für Tabellenkopf von Titel
					if (Titelbreite>maxTitelbreite)
					{
						maxTitelbreite=Titelbreite;
					}
					NSString* name=NSLocalizedString(@"Name",@"Name:");
					//char * nb=[name lossyCString];
                    const char * nb=[name cStringUsingEncoding:NSMacOSRomanStringEncoding];
					int Namenbreite=strlen(nb);//Minimalbreite für Tabellenkopf von Name
						if (Namenbreite>maxNamenbreite)
						{
							maxNamenbreite=Namenbreite;
						}
						//NSLog(@"Tabellenkopf: Namenbreite: %d  Titelbreite: %d",Namenbreite, Titelbreite);
						
						int i;
						
						//Länge von Name und Titel feststellen
						for (i=0;i<[KommentarArray count];i++)
						{
							
							//if ([KommentarArray objectAtIndex:i])
							
							//NSLog(@"%@KommentarArray Zeile: %d %@",@"\r",i,[KommentarArray objectAtIndex:i]);
							NSArray* ZeilenArray=[[KommentarArray objectAtIndex:i]componentsSeparatedByString:@"\t"];
							if ([ZeilenArray count]>1)
							{
								//char * nc=[[ZeilenArray objectAtIndex:0]lossyCString];
                                const char * nc=[[ZeilenArray objectAtIndex:0] cStringUsingEncoding:NSMacOSRomanStringEncoding];
								int nl=strlen(nc);
								if(nl>Namenbreite)
									Namenbreite=nl;
								
								//char * tc=[[ZeilenArray objectAtIndex:1]lossyCString];
								const char * tc=[[ZeilenArray objectAtIndex:1] cStringUsingEncoding:NSMacOSRomanStringEncoding];
                                int tl=strlen(tc);
								if(tl>Titelbreite)
									Titelbreite=tl;
								//NSLog(@"tempNamenbreite: %d  Titelbreite: %d",nl, tl);
							}
							
						}
						
						//NSLog(@"Namenbreite: %d  Titelbreite: %d",Namenbreite, Titelbreite);
						if (Namenbreite>maxNamenbreite)
						{
							maxNamenbreite=Namenbreite;
						}
						if (Titelbreite>maxTitelbreite)
						{
							maxTitelbreite=Titelbreite;
						}
						//NSLog(@"maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
			}//if Kommentarstring
		}//if einProjekt
	}//while Wortlängen bestimmen
	
	
	
	NSEnumerator* KommentarArrayEnum=[derKommentarDicArray objectEnumerator];
	id einKommentarDic;
	while (einKommentarDic=[KommentarArrayEnum nextObject])//Tabulatoren setzen und Tabelle aufbauen
	{
		//NSLog(@"											setKommentarMit Komm.DicArray: Beginn while 2. Runde");
		NSString* ProjektTitel;
		
		if ([einKommentarDic objectForKey:@"projekt"])
		{
			ProjektTitel=[einKommentarDic objectForKey:@"projekt"];
			//NSLog(@"ProjektTitel: %@",ProjektTitel);
		}
		else //Kein Projekt angegeben
		{
			ProjektTitel=@"Kein Projekt";
		}
		
		
		//Font für Projektzeile
		NSFont* ProjektFont;
		ProjektFont=[NSFont fontWithName:@"Helvetica" size: 12];
		
		NSString* ProjektString=NSLocalizedString(@"Project: ",@"Projekt: ");
		NSString* ProjektKopfString=[NSString stringWithFormat:@"%@    %@%@",ProjektString,ProjektTitel,@"\r"];
		
		//Stil für Projektzeile
		NSMutableParagraphStyle* ProjektStil=[[NSMutableParagraphStyle alloc]init];
		[ProjektStil setTabStops:[NSArray array]];//default weg
		NSTextTab* ProjektTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:150];
		[ProjektStil addTabStop:ProjektTab1];
		
		//Attr-String für Projektzeile zusammensetzen
		NSMutableAttributedString* attrProjektString=[[NSMutableAttributedString alloc] initWithString:ProjektKopfString]; 
		[attrProjektString addAttribute:NSParagraphStyleAttributeName value:ProjektStil range:NSMakeRange(0,[ProjektKopfString length])];
		[attrProjektString addAttribute:NSFontAttributeName value:ProjektFont range:NSMakeRange(0,[ProjektKopfString length])];
		
		//Projektzeile einsetzen
		[[DruckKommentarView textStorage]appendAttributedString:attrProjektString];
		
		//Stil für Abstand1
		NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
		NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
		NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
		[attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
		[attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
		//Abstandzeile einsetzen
		[[DruckKommentarView textStorage]appendAttributedString:attrAbstand1String];
		
		NSMutableString* TextString;
		if ([einKommentarDic objectForKey:@"kommentarstring"])
		{
			TextString=[[einKommentarDic objectForKey:@"kommentarstring"]mutableCopy];
		}
		else //Keine Kommentare in diesem Projekt
		{
			TextString=[NSLocalizedString(@"No comments for this Project",@"Keine Kommentare für dieses Projekt") mutableCopy];
		}

		
		int pos=[TextString length]-1;
		BOOL letzteZeileWeg=NO;
		if ([TextString characterAtIndex:pos]=='\r')
		{
			//NSLog(@"last Char ist r");
			//[TextString deleteCharactersInRange:NSMakeRange(pos-1,1)];
			letzteZeileWeg=YES;
			pos--;
		}
		
		if([TextString characterAtIndex:pos]=='\n')
		{
			NSLog(@"last Char ist n");
		}
		
		AuswahlOption=[[AuswahlPopMenu selectedCell]tag];
		
		//NSLog(@"*KommentarFenster  setKommentar textString: %@  AuswahlOption: %d",TextString, AuswahlOption);
		
		switch ([[AbsatzMatrix selectedCell]tag])
			
		{
			case alsTabelleFormatOption:
			{
				//int Textschnitt=10;

				NSFont* TextFont;
				TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
				//NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
				
				NSMutableArray* KommentarArray=(NSMutableArray*)[TextString componentsSeparatedByString:@"\r"];
				if (letzteZeileWeg)
				{
					//NSLog(@"letzteZeileWeg");
					[KommentarArray removeLastObject];
				}

				[Anz setIntValue:[KommentarArray count]-1];
				
				//NSLog(@"2. Runde: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
//				
				//Tabulatoren aufaddieren
				float titeltab=120;
				
				titeltab=maxNamenbreite*(3*Textschnitt/5);
				float datumtab=260;
				
				datumtab=titeltab+maxTitelbreite*(3*Textschnitt/5);
				float bewertungtab=325;
				bewertungtab=datumtab+12*(3*Textschnitt/5);
				
				//bewertungtab=datumtab;
				
				float notetab=380;
				notetab=bewertungtab+12*(3*Textschnitt/5);
				float anmerkungentab=410;
				anmerkungentab=notetab+8*(3*Textschnitt/5);
				
				NSMutableParagraphStyle* TabellenKopfStil=[[NSMutableParagraphStyle alloc]init];
				[TabellenKopfStil setTabStops:[NSArray array]];
				NSTextTab* TabellenkopfTitelTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:titeltab];
				[TabellenKopfStil addTabStop:TabellenkopfTitelTab];
				NSTextTab* TabellenkopfDatumTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:datumtab];
				[TabellenKopfStil addTabStop:TabellenkopfDatumTab];
//				NSTextTab* TabellenkopfBewertungTab=[[[NSTextTab alloc]initWithType:NSLeftTabStopType location:bewertungtab]autorelease];
//				[TabellenKopfStil addTabStop:TabellenkopfBewertungTab];
				NSTextTab* TabellenkopfNoteTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:notetab];
				[TabellenKopfStil addTabStop:TabellenkopfNoteTab];
				NSTextTab* TabellenkopfAnmerkungenTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:anmerkungentab];
				[TabellenKopfStil addTabStop:TabellenkopfAnmerkungenTab];
				[TabellenKopfStil setParagraphSpacing:4];
				
				
				NSMutableParagraphStyle* TabelleStil=[[NSMutableParagraphStyle alloc]init];
				[TabelleStil setTabStops:[NSArray array]];
				NSTextTab* TabelleTitelTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:titeltab];
				[TabelleStil addTabStop:TabelleTitelTab];
				NSTextTab* TabelleDatumTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:datumtab];
				[TabelleStil addTabStop:TabelleDatumTab];
//				NSTextTab* TabelleBewertungTab=[[[NSTextTab alloc]initWithType:NSLeftTabStopType location:bewertungtab]autorelease];
//				[TabelleStil addTabStop:TabelleBewertungTab];
				NSTextTab* TabelleNoteTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:notetab];
				[TabelleStil addTabStop:TabelleNoteTab];
				NSTextTab* TabelleAnmerkungenTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:anmerkungentab];
				[TabelleStil addTabStop:TabelleAnmerkungenTab];
				[TabelleStil setHeadIndent:anmerkungentab];
				[TabelleStil setParagraphSpacing:2];
				
				//Kommentarstring in Komponenten aufteilen
				//NSString* TabellenkopfString=[[KommentarArray objectAtIndex:0]stringByAppendingString:@"\r"];
				NSMutableString* TabellenkopfString=[[KommentarArray objectAtIndex:0]mutableCopy];
				int lastBuchstabenPos=[TabellenkopfString length]-1;
				//NSLog(@"TabellenkopfString: %@   length: %d  last: %d",TabellenkopfString,lastBuchstabenPos,[TabellenkopfString characterAtIndex:lastBuchstabenPos] );
				
				
				if([TabellenkopfString characterAtIndex:lastBuchstabenPos]=='\n')
				{
					NSLog(@"TabellenkopfString: last Char ist n");
				}
				if([TabellenkopfString characterAtIndex:lastBuchstabenPos]=='\r')
				{
					NSLog(@"TabellenkopfString: last Char ist r");
				}
				[TabellenkopfString deleteCharactersInRange:NSMakeRange(lastBuchstabenPos,1)];
				NSMutableAttributedString* attrKopfString=[[NSMutableAttributedString alloc] initWithString:TabellenkopfString];
				[attrKopfString addAttribute:NSParagraphStyleAttributeName value:TabellenKopfStil range:NSMakeRange(0,[TabellenkopfString length])];
				[attrKopfString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TabellenkopfString length])];
				[[DruckKommentarView textStorage]appendAttributedString:attrKopfString];
				
				//Stil für Abstand2
				NSMutableParagraphStyle* Abstand2Stil=[[NSMutableParagraphStyle alloc]init];
				NSFont* Abstand2Font=[NSFont fontWithName:@"Helvetica" size: 2];
				NSMutableAttributedString* attrAbstand2String=[[NSMutableAttributedString alloc] initWithString:@" \r"]; 
				[attrAbstand2String addAttribute:NSParagraphStyleAttributeName value:Abstand2Stil range:NSMakeRange(0,1)];
				[attrAbstand2String addAttribute:NSFontAttributeName value:Abstand2Font range:NSMakeRange(0,1)];
				
				[[DruckKommentarView textStorage]appendAttributedString:attrAbstand2String];
				
				
				
				
				NSString* cr=@"\r";
				//NSAttributedString*CR=[[[NSAttributedString alloc]initWithString:cr]autorelease];
				int index=1;
				if ([KommentarArray count]>1)
				{
					for (index=1;index<[KommentarArray count];index++)
					{
						NSString* tempZeile=[KommentarArray objectAtIndex:index];
						
						if ([tempZeile length]>1)
						{	
							NSString* tempString=[tempZeile substringToIndex:[tempZeile length]-1];
							NSString* tempArrayString=[NSString stringWithFormat:@"%@%@",tempString, cr];
							
							NSMutableAttributedString* attrTextString=[[NSMutableAttributedString alloc] initWithString:tempArrayString]; 
							[attrTextString addAttribute:NSParagraphStyleAttributeName value:TabelleStil range:NSMakeRange(0,[tempArrayString length])];
							[attrTextString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[tempArrayString length])];
							[[DruckKommentarView textStorage]appendAttributedString:attrTextString];
							//NSLog(@"Ende setKommentar: attrTextString retainCount: %d",[attrTextString retainCount]);
							
						}
					}//for index
				}//if count>1
			}break;//alsTabelleFormatOption
				
			case alsAbsatzFormatOption:
			{
				NSFont* TextFont;
				TextFont=[NSFont fontWithName:@"Helvetica" size: 12];
				NSFontTraitMask TextFontMask=[fontManager traitsOfFont:TextFont];
				
				NSMutableParagraphStyle* AbsatzStil=[[NSMutableParagraphStyle alloc]init];
				[AbsatzStil setTabStops:[NSArray array]];
				NSTextTab* AbsatzTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
				[AbsatzStil addTabStop:AbsatzTab1];
				[AbsatzStil setHeadIndent:90];
				//[AbsatzStil setParagraphSpacing:4];
				
				NSMutableAttributedString* attrTextString=[[NSMutableAttributedString alloc] initWithString:TextString]; 
				[attrTextString addAttribute:NSParagraphStyleAttributeName value:AbsatzStil range:NSMakeRange(0,[TextString length])];
				
				[attrTextString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TextString length])];
				
				[[DruckKommentarView textStorage]appendAttributedString:attrTextString];
				//NSLog(@"Ende setKommentar: attrTextString retainCount: %d",[attrTextString retainCount]);
				
				
			}break;//alsAbsatzFormatOption
		}//Auswahloption
			
			//NSLog(@"Ende setKommentar: TitelStil retainCount: %d",[TitelStil retainCount]);
			//NSLog(@"Ende setKommentar: attrTitelString retainCount: %d",[attrTitelString retainCount]);
			//[attrTitelString release];
		//NSLog(@"Ende setKommentar: TitelTab1 retainCount: %d",[TitelTab1 retainCount]);
		//[TitelTab1 release];
		//NSLog(@"Ende setKommentar%@",@"\r***\r\r\r");//: attrTitelString retainCount: %d",[attrTitelString retainCount]);
		//NSLog(@"setKommentarMit Komm.DicArray: Ende while");
	[[DruckKommentarView textStorage]appendAttributedString:attrAbstand12String];//Abstand zu nächstem Projekt 
	[[DruckKommentarView textStorage]appendAttributedString:attrAbstand12String];

}//while Enum
//NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);

//NSLog(@"setKommentarMit Komm.DicArray: nach while");
//[KommentarView retain];
return DruckKommentarView;
}



- (NSTextView*)setDruckViewMitFeld:(NSRect)dasDruckFeld
			  mitKommentarDicArray:(NSArray*)derKommentarDicArray
{
	NSTextView* tempView;
	tempView=[self setDruckKommentarMitKommentarDicArray:derKommentarDicArray mitFeld:dasDruckFeld];

return tempView;
}




- (void)KommentarDruckenMitProjektDicArray:(NSArray*)derProjektDicArray
{

	NSTextView* DruckView=[[NSTextView alloc]init];
	//NSLog (@"Kommentar: KommentarDruckenMitProjektDicArray ProjektDicArray: %@",[derProjektDicArray description]);
	NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
	switch (AbsatzOption)
	  {
		case alsTabelleFormatOption:
		  {
			  [PrintInfo setOrientation:NSLandscapeOrientation];
		  };break;
			
		case alsAbsatzFormatOption:
		  {
			  [PrintInfo setOrientation:NSPortraitOrientation];
		  };break;
	  }//switch AbsatzOption
	
	
	 //[PrintInfo setOrientation:NSPortraitOrientation];
	//[PrintInfo setHorizontalPagination: NSAutoPagination];
	[PrintInfo setVerticalPagination: NSAutoPagination];

	[PrintInfo setHorizontallyCentered:NO];
	[PrintInfo setVerticallyCentered:NO];
	NSRect bounds=[PrintInfo imageablePageBounds];
	
	int x=bounds.origin.x;int y=bounds.origin.y;int h=bounds.size.height;int w=bounds.size.width;
	//NSLog(@"Bounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
	NSSize Papiergroesse=[PrintInfo paperSize];
	int leftRand=(Papiergroesse.width-bounds.size.width)/2;
	int topRand=(Papiergroesse.height-bounds.size.height)/2;
	int platzH=(Papiergroesse.width-bounds.size.width);
		
	int freiLinks=60;
	int freiOben=30;
	//int DruckbereichH=bounds.size.width-freiLinks+platzH*0.5;
	int DruckbereichH=Papiergroesse.width-freiLinks-leftRand;
	
	int DruckbereichV=bounds.size.height-freiOben;

	int platzV=(Papiergroesse.height-bounds.size.height);
	
	//NSLog(@"platzH: %d  platzV %d",platzH,platzV);

	int botRand=(Papiergroesse.height-topRand-bounds.size.height-1);
	
	[PrintInfo setLeftMargin:freiLinks];
	[PrintInfo setRightMargin:leftRand];
	[PrintInfo setTopMargin:freiOben];
	[PrintInfo setBottomMargin:botRand];
	
	
	int Papierbreite=(int)Papiergroesse.width;
	int Papierhoehe=(int)Papiergroesse.height;
	int obererRand=[PrintInfo topMargin];
	int linkerRand=(int)[PrintInfo leftMargin];
	int rechterRand=[PrintInfo rightMargin];
	
	NSLog(@"linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
	NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
	
		
	
	DruckView=[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];





	//[DruckView setBackgroundColor:[NSColor grayColor]];
	//[DruckView setDrawsBackground:YES];
	NSPrintOperation* DruckOperation;
	DruckOperation=[NSPrintOperation printOperationWithView: DruckView
												  printInfo:PrintInfo];
	[DruckOperation setShowsPrintPanel:YES];
	[DruckOperation runOperation];
	
}


- (void)KommentarSichernMitProjektDicArray:(NSArray*)derProjektDicArray
{

	NSTextView* DruckView=[[NSTextView alloc]init];
	//NSLog (@"Kommentar: KommentarDruckenMitProjektDicArray ProjektDicArray: %@",[derProjektDicArray description]);
	NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
	switch (AbsatzOption)
	  {
		case alsTabelleFormatOption:
		  {
			  [PrintInfo setOrientation:NSLandscapeOrientation];
		  };break;
			
		case alsAbsatzFormatOption:
		  {
			  [PrintInfo setOrientation:NSPortraitOrientation];
		  };break;
	  }//switch AbsatzOption
	
	
	 //[PrintInfo setOrientation:NSPortraitOrientation];
	//[PrintInfo setHorizontalPagination: NSAutoPagination];
	[PrintInfo setVerticalPagination: NSAutoPagination];

	[PrintInfo setHorizontallyCentered:NO];
	[PrintInfo setVerticallyCentered:NO];
	NSRect bounds=[PrintInfo imageablePageBounds];
	
	int x=bounds.origin.x;int y=bounds.origin.y;int h=bounds.size.height;int w=bounds.size.width;
	//NSLog(@"Bounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
	NSSize Papiergroesse=[PrintInfo paperSize];
	int leftRand=(Papiergroesse.width-bounds.size.width)/2;
	int topRand=(Papiergroesse.height-bounds.size.height)/2;
	int platzH=(Papiergroesse.width-bounds.size.width);
		
	int freiLinks=60;
	int freiOben=30;
	//int DruckbereichH=bounds.size.width-freiLinks+platzH*0.5;
	int DruckbereichH=Papiergroesse.width-freiLinks-leftRand;
	
	int DruckbereichV=bounds.size.height-freiOben;

	int platzV=(Papiergroesse.height-bounds.size.height);
	
	//NSLog(@"platzH: %d  platzV %d",platzH,platzV);

	int botRand=(Papiergroesse.height-topRand-bounds.size.height-1);
	
	[PrintInfo setLeftMargin:freiLinks];
	[PrintInfo setRightMargin:leftRand];
	[PrintInfo setTopMargin:freiOben];
	[PrintInfo setBottomMargin:botRand];
	
	
	int Papierbreite=(int)Papiergroesse.width;
	int Papierhoehe=(int)Papiergroesse.height;
	int obererRand=[PrintInfo topMargin];
	int linkerRand=(int)[PrintInfo leftMargin];
	int rechterRand=[PrintInfo rightMargin];
	
	NSLog(@"linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
	NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
	
	DruckView=[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];

	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:DruckView forKey:@"druckview"];
	NSLog(@"NotificationDic: %@",[NotificationDic description]);
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SaveKommentar" object:self userInfo:NotificationDic];
	
}




- (NSView*)KommentarView
{
	NSLog(@"Kommentar return KommentarView");
	return KommentarView;
}

- (void)dealloc
{
}
@end
