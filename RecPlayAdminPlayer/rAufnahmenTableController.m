//
//  rAufnahmenTableController.m
//  RecPlayII
//
//  Created by Sysadmin on 18.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rAdminPlayer.h"


@implementation rAdminPlayer(rAufnahmenTableController)

- (void)setNamenPop:(NSArray*)derNamenArray
{

}

- (IBAction)reportAuswahlOption:(id)sender;
{
//NSLog(@"reportAuswahlOption: row: %d",[sender selectedRow]);
[self setAufnahmenVonLeser:[LesernamenPop titleOfSelectedItem]];

}

- (void)setAdminMark:(BOOL)derStatus fuerZeile:(int)dieZeile
{
	NSNumber* StatusNumber=[NSNumber numberWithBool:derStatus];
	[[AufnahmenDicArray objectAtIndex:dieZeile]setObject:[StatusNumber stringValue] forKey:@"adminmark"];
	[AufnahmenTable reloadData];
}

- (IBAction)reportDelete:(id)sender
{
NSString* tempName=[LesernamenPop titleOfSelectedItem];
NSLog(@"tempName: %@",tempName);
[self AufnahmeLoeschen:sender];
[LesernamenPop selectItemWithTitle:tempName];
[self setAufnahmenVonLeser:tempName];

}

- (void)setUserMark:(BOOL)derStatus fuerZeile:(int)dieZeile
{
	NSNumber* StatusNumber=[NSNumber numberWithBool:derStatus];
	[[AufnahmenDicArray objectAtIndex:dieZeile]setObject:[StatusNumber stringValue] forKey:@"usermark"];
	[AufnahmenTable reloadData];
}






- (IBAction)setAufnahmenVonPopLeser:(id)sender
{
[self setAufnahmenVonLeser:[sender titleOfSelectedItem]];

}

- (void)setAufnahmenVonLeser:(NSString*)derLeser
{
	
	[AufnahmenDicArray removeAllObjects];
	AdminAktuellerLeser=[derLeser copy];
	NSString* tempLeserPfad=[AdminProjektPfad stringByAppendingPathComponent:derLeser];
	//NSLog(@"tempLeserPfad: %@",tempLeserPfad);
	
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempLeserPfad error:NULL]];
	if (tempAufnahmenArray)
	{
		[tempAufnahmenArray removeObject:@".DS_Store"];
		[tempAufnahmenArray removeObject:NSLocalizedString(@"Comments",@"Anmerkungen")];
	}
	
	//NSLog(@"tempAufnahmenArray: %@",[tempAufnahmenArray description]);
	
	
	NSString* tempLeserKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:NSLocalizedString(@"Comments",@"Anmerkungen")];
	//NSLog(@"tempLeserKommentarPfad: %@",tempLeserKommentarPfad);
	NSMutableArray* tempKommentarArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempLeserKommentarPfad error:NULL]];
	if (tempKommentarArray)
	{
		[tempKommentarArray removeObject:@".DS_Store"];
	}
	//NSLog(@"tempKommentarArray: %@",[tempKommentarArray description]);			

	NSMutableArray* tempAufnahmenDicArray=[[NSMutableArray alloc]initWithCapacity:0];

	NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
	id eineAufnahme;
	BOOL inPopOK=NO;
	while (eineAufnahme=[AufnahmenEnum nextObject])
	{
		if ([MarkAuswahlOption selectedRow]==0)
		{
			inPopOK=YES;
		}
		NSMutableDictionary* tempAufnahmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		
		[tempAufnahmenDic setObject:eineAufnahme forKey:@"aufnahme"];
		
		NSString* tempAufnahmePfad=[tempLeserPfad stringByAppendingPathComponent:eineAufnahme];
		BOOL AdminMarkOK=[self AufnahmeIstMarkiertAnPfad:tempAufnahmePfad];
//		[MarkCheckbox setEnabled:YES];
		[MarkCheckbox setState:AdminMarkOK];
		
		if (([MarkAuswahlOption selectedRow]==1)&&AdminMarkOK)
		{
			inPopOK=YES;
			
		}
		[tempAufnahmenDic setObject:[NSNumber numberWithBool:AdminMarkOK] forKey:@"adminmark"];
		
		NSString* tempKommentarString=[self KommentarZuAufnahme:eineAufnahme 
													   vonLeser:AdminAktuellerLeser 
												  anProjektPfad:AdminProjektPfad];
		BOOL UserMarkOK=[self UserMarkVon:tempKommentarString];
		
		if (([MarkAuswahlOption selectedRow]==2)&&UserMarkOK)
		{
			inPopOK=YES;
		}
			

		if (inPopOK)
		{
			[tempAufnahmenDic setObject:[NSNumber numberWithBool:UserMarkOK] forKey:@"usermark"];
			[tempAufnahmenDic setObject:[NSNumber numberWithInt:[self AufnahmeNummerVon:eineAufnahme]] forKey:@"sort"];
			AufnahmeDa=YES;
			[tempAufnahmenDicArray addObject:tempAufnahmenDic];
			inPopOK=NO;
		}
		
	}//while
	AufnahmeDa=[tempAufnahmenDicArray count];
	[self->PlayTaste setEnabled:AufnahmeDa];
	[DeleteTaste setEnabled:AufnahmeDa];
	if ([tempAufnahmenDicArray count])//es hat Aufnahmen
	{
//	[DeleteTaste setEnabled:YES];
//	[self.PlayTaste setEnabled:YES];
	}
	else
	{
	//[DeleteTaste setEnabled:NO];
	//[self.PlayTaste setEnabled:NO];
	NSLog(@"keine Aufnahmen für diese Einstellungen");
	NSMutableDictionary* tempAufnahmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		
	[tempAufnahmenDic setObject:NSLocalizedString(@"No Records",@"Keine Aufnahmen") forKey:@"aufnahme"];
	[tempAufnahmenDicArray addObject:tempAufnahmenDic];
	}

	NSSortDescriptor* sorter=[[NSSortDescriptor alloc]initWithKey:@"sort" ascending:NO];
	NSArray* sortDescArray=[NSArray arrayWithObjects:sorter,nil];
	AufnahmenDicArray =[[tempAufnahmenDicArray sortedArrayUsingDescriptors:sortDescArray]mutableCopy];
	//NSLog(@"AufnahmenDicArray: %@",[AufnahmenDicArray description]);
	AdminAktuelleAufnahme=[[AufnahmenDicArray objectAtIndex:0]objectForKey:@"aufnahme"];
	selektierteAufnahmenTableZeile=0;
	NSNumber* ZeilenNummer=[NSNumber numberWithInt:0];
	NSMutableDictionary* tempZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNummer forKey:@"AufnahmenZeilenNummer"];
	[tempZeilenDic setObject:@"AufnahmenTable" forKey:@"Quelle"];
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"AdminselektierteZeile" object:tempZeilenDic];
	
	
	[AufnahmenTable reloadData];
	[AufnahmenTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
	BOOL OK;
	OK=[self setPfadFuerLeser: derLeser FuerAufnahme:AdminAktuelleAufnahme];
	OK=[self setKommentarFuerLeser: derLeser FuerAufnahme:AdminAktuelleAufnahme];
}


- (void)setAufnahmenTable:(NSArray*)derAufnahmenArray  fuerLeser:(NSString*)derLeser
{


}

#pragma mark -
#pragma mark TestTable delegate:


#pragma mark -
#pragma mark TestTable Data Source:

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [AufnahmenDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex
{
//NSLog(@"objectValueForTableColumn");
    NSMutableDictionary *einAufnahmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	if (rowIndex<[AufnahmenDicArray count])
	{
			einAufnahmenDic = [[AufnahmenDicArray objectAtIndex: rowIndex]mutableCopy];
			if ([[einAufnahmenDic objectForKey:@"adminmark"]intValue]==1)
			{
			[einAufnahmenDic setObject:[NSImage imageNamed:@"MarkOnImg.tif"] forKey:@"adminmark"];
			}
			else
			{
			[einAufnahmenDic setObject:[NSImage imageNamed:@"MarkOffImg.tif"] forKey:@"adminmark"];
			}

	}
	//NSLog(@"einAufnahmenDic: aktiv: %d   Testname: %@",[[einAufnahmenDic objectForKey:@"aktiv"]intValue],[einAufnahmenDic objectForKey:@"name"]);

	return [einAufnahmenDic objectForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex
{
   //NSLog(@"setObjectValueForTableColumn");

    NSMutableDictionary* einAufnahmenDic;
    if (rowIndex<[AufnahmenDicArray count])
	{
		//NSLog(@"setObjectValueForTableColumn: anObject: %@ column: %@",[anObject description],[aTableColumn identifier]);
		einAufnahmenDic=[AufnahmenDicArray objectAtIndex:rowIndex];
		NSLog(@"einAufnahmenDic vor: %@",[einAufnahmenDic description]);
		[einAufnahmenDic setObject:anObject forKey:[aTableColumn identifier]];
		NSLog(@"einAufnahmenDic nach: %@",[einAufnahmenDic description]);
		NSString* tempAufnahme=[einAufnahmenDic objectForKey:@"aufnahme"];
		[self saveMarksFuerLeser:AdminAktuellerLeser FuerAufnahme:tempAufnahme 
			  mitAdminMark:[[einAufnahmenDic objectForKey:@"adminmark"]intValue]
			   mitUserMark:[[einAufnahmenDic objectForKey:@"usermark"]intValue]];
		
		[AufnahmenTable reloadData];
		//NSLog(@"einAufnahmenDic: %@",[einAufnahmenDic description]);
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
	//NSLog(@"AufnahmenTable  shouldSelectRow: %d  selektierteAufnahmenTableZeile: %d" ,row,selektierteAufnahmenTableZeile);
	int bisherSelektierteZeile=selektierteAufnahmenTableZeile;//bisher selektierte Zeile
	selektierteAufnahmenTableZeile=row;//neu selektierte Zeile
	if (bisherSelektierteZeile>=0)
	{
	
	NSNumber* ZeilenNumber=[NSNumber numberWithInt:bisherSelektierteZeile];
	
	
	NSMutableDictionary* NamenZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNumber forKey:@"zeilennummer"];
	[NamenZeilenDic setObject:@"AufnahmenTable" forKey:@"Quelle"];
	[NamenZeilenDic setObject:[LesernamenPop titleOfSelectedItem]forKey:@"leser"];//Leser der Aufnahmen im TableView
	NSString* tempAufnahme=[[AufnahmenDicArray objectAtIndex:bisherSelektierteZeile]objectForKey:@"aufnahme"];//bisher selektierte Aufnahme
	NSLog(@"AdminAktuelleAufnahme: %@ tempAufnahme: %@", AdminAktuelleAufnahme,tempAufnahme);
	[NamenZeilenDic setObject:tempAufnahme forKey:@"aufnahme"];

	//NSLog(@"[AuswahlArray: %@",[[AuswahlArray objectAtIndex:row]description]);
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"AdminselektierteZeile" object:NamenZeilenDic];
	}//es war eine Zeile selektiert
	
	//if (!row==selektierteAufnahmenTableZeile)//aufräumen
	
	AdminAktuelleAufnahme=[[AufnahmenDicArray objectAtIndex:row]objectForKey:@"aufnahme"];//neu selektierte Aufnahme
	
	//[self clearKommentarfelder];
	[self->PlayTaste setEnabled:YES];
	[zurListeTaste setEnabled:NO];
	
	
	//aktuelleZeile=row;
	
	return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	//NSLog(@"ProjektListe willDisplayCell Zeile: %d, numberOfSelectedRows:%d", row ,[tableView numberOfSelectedRows]);
	NSString* tempTestNamenString=[[AufnahmenDicArray objectAtIndex:row]objectForKey:@"aufnahme"];
	if([[[AufnahmenDicArray objectAtIndex:row]objectForKey:@"usermark"]intValue])//user hat markiert
	{
	//[cell setTextColor:[NSColor redColor]];
	}
	else//alter Name
	{
	//[cell setTextColor:[NSColor blackColor]];
	}
	  if ([[tableColumn identifier] isEqualToString:@"adminmark"])
	  {
		  //[cell setImagePosition:NSImageRight];
		  //NSImage* MarkOnImg=[NSImage imageNamed:@"MarkOnImg.tif"];
		  if ([[[AufnahmenDicArray objectAtIndex:row]objectForKey:@"adminmark"]intValue])
		  {
			  //[cell setImage:[NSImage imageNamed:@"MarkOnImg.tif"]];
		  }
		  else
		  {
			  //[cell setImage:[NSImage imageNamed:@"MarkOffImg.tif"]];
		  }
	  }
}//willDisplayCell
  
  
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
//[self resetAdminPlayer]; 
	//if ([TestTable numberOfSelectedRows]==0)
	{
		//[OKKnopf setEnabled:NO];
		//[OKKnopf setKeyEquivalent:@""];
		//[HomeKnopf setKeyEquivalent:@"\r"];
	}
}

- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn
{
	if ([[tableColumn identifier]isEqualToString:@"usermark"])//Klick in erate Kolonne
	{
		
		BOOL status=[[tableColumn dataCellForRow:[tableView selectedRow]]isEnabled];
		NSLog(@"UserMark: status: %d",status);
		if (status)
		{
		[[tableColumn headerCell]setTextColor:[NSColor greenColor]];
		[[tableColumn headerCell]setTitle:@"X"];
		}
		else
		{
		[[tableColumn headerCell]setTextColor:[NSColor redColor]];
		[[tableColumn headerCell]setTitle:@"OK"];
		}
		[[tableColumn dataCellForRow:[tableView selectedRow]]setEnabled:!status];
		[tableView reloadData];
	}
	
}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	//NSLog(@"tabView shouldSelectTabViewItem: %@",[[tabViewItem identifier]description]);
	//NSLog(@"shouldSelectTabViewItem: rowData: %@",[[AdminDaten rowData] description]);	
	
		//[self.PlayTaste setEnabled:YES];
		[zurListeTaste setEnabled:NO];
		
	if ([[tabViewItem identifier]intValue]==1)//zurück zu 'alle Aufnahmen'
	{
		
		NSLog(@"zu 'alle Aufnahmen'");
		
		NSLog(@"nach Namen vor : AdminAktuelleAufnahme: %@",AdminAktuelleAufnahme);

		int Zeile=[AufnahmenTable selectedRow];
		AdminAktuelleAufnahme=[[AufnahmenDicArray objectAtIndex:Zeile]objectForKey:@"aufnahme"];
		NSLog(@"Tab nach Namen: Zeile: %d AdminAktuelleAufnahme: %@",Zeile,AdminAktuelleAufnahme);

		NSNumber* ZeilenNummer=[NSNumber numberWithInt:Zeile];
		NSMutableDictionary* tempZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNummer forKey:@"AufnahmenZeilenNummer"];
		[tempZeilenDic setObject:@"AufnahmenTable" forKey:@"Quelle"];
		NSNotificationCenter * nc;
		nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"AdminChangeTab" object:tempZeilenDic];

		[self clearKommentarfelder];

		if ([LesernamenPop indexOfSelectedItem])
		{
			NSString* Lesername=[LesernamenPop titleOfSelectedItem];
			int LesernamenIndex=[AdminDaten ZeileVonLeser:Lesername];
			//NSLog(@"Alle Namen: Lesername: %@, LesernamenIndex: %d",Lesername,LesernamenIndex);
			[self->NamenListe selectRowIndexes:[NSIndexSet indexSetWithIndex:LesernamenIndex]byExtendingSelection:NO];
			[self setLeserFuerZeile:LesernamenIndex];
			if ([NamenListe numberOfSelectedRows])
			{
			[PlayTaste setEnabled:YES];
			}
		}
		else
		{
		[NamenListe deselectAll:NULL];
		[PlayTaste setEnabled:NO];
		}
	}
	
	if ([[tabViewItem identifier]intValue]==2)//zu 'Nach Namen'
	{
		//NSLog(@"Tab zu 'nach Namen'");
		if ([NamenListe numberOfSelectedRows])//es ist eine zeile in der self.NamenListe selektiert
		{
			
			int  Zeile;
			Zeile=[NamenListe selectedRow];//selektierte Zeile in der self.NamenListe
			//NSLog(@"nach Namen: Zeile: %d AdminAktuelleAufnahme: %@",Zeile,AdminAktuelleAufnahme);
			
			
			NSNumber* ZeilenNumber=[NSNumber numberWithInt:Zeile];
			
			NSMutableDictionary* AdminZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNumber forKey:@"zeilennummer"];
			[AdminZeilenDic setObject:@"AdminView" forKey:@"Quelle"];
			
			NSString* Lesername=[[AdminDaten dataForRow:Zeile] objectForKey:@"namen"];
			//NSLog(@"Nach Namen: Lesername: %@",Lesername);
			[AdminZeilenDic setObject:[Lesername copy] forKey:@"leser"];
			
						
			NSNotificationCenter * nc;
			nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"AdminChangeTab" object:AdminZeilenDic];
			
			[PlayTaste setEnabled:AufnahmeDa];
			
			
			[LesernamenPop selectItemWithTitle:Lesername];
			[self setAufnahmenVonLeser:Lesername];
			
			[[self window]makeFirstResponder:AufnahmenTable];
			NSString* KeineAufnahmenString=NSLocalizedString(@"No Records",@"Keine Aufnahmen");
			
			//NSNotificationCenter * nc;
			//nc=[NSNotificationCenter defaultCenter];
			//[nc postNotificationName:@"AdminselektierteZeile" object:AdminZeilenDic];
			
			
		}
		else
		{
			[LesernamenPop selectItemAtIndex:0];
			[PlayTaste setEnabled:NO];
			[self clearKommentarfelder];
			return 0; // nicht umschalten
		}
	}
	

	return YES;
}


@end

