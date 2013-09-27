//
//  ViewController.h
//  BizerPathDemo
//
//  Created by StandardUser on 26/09/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *nBackImageView;


- (IBAction)nMaskImageTapped:(id)sender;
- (IBAction)freeMoveTapped:(id)sender;
- (IBAction)goTapped:(id)sender;

@end
