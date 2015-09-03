//
//  Testfenster.m
//  Lesestudio_20
//
//  Created by Ruedi Heimlicher on 03.09.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "rTestfenster.h"

@interface rTestfenster ()

@end

@implementation rTestfenster

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


-(IBAction)reportSchliessenTaste:(id)sender
{
   
   NSLog(@"reportSchliessenTaste Text: %@",[_AnzeigeFeld stringValue]);
}
@end
