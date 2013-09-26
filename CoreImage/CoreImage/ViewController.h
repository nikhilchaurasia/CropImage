//
//  ViewController.h
//  CoreImage
//
//  Created by StandardUser on 23/08/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgMainView;
- (IBAction)chooseImageTapped:(id)sender;
- (IBAction)filterTapped:(id)sender;
- (IBAction)croptapped:(id)sender;
- (IBAction)extraTapped:(id)sender;
- (IBAction)resetColor:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *outputImage;
@end
