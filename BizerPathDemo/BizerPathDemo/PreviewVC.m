//
//  PreviewVC.m
//  BizerPathDemo
//
//  Created by StandardUser on 26/09/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import "PreviewVC.h"

@interface PreviewVC ()

@end

@implementation PreviewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mImgView.image = self.imageP;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
