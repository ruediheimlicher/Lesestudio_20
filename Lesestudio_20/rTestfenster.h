//
//  rTestfenster.h
//  Lesestudio_20
//
//  Created by Ruedi Heimlicher on 03.09.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rTestfenster : NSViewController


@property (weak) IBOutlet NSButton*					SchliessenTaste;
@property (weak) IBOutlet NSTextField*				AnzeigeFeld;


-(IBAction)reportSchliessenTaste:(id)sender;
@end
