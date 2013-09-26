//
//  FilterClass.h
//  CoreImage
//
//  Created by StandardUser on 23/08/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>

@interface FilterClass : NSObject
{
    
}
-(UIImage *)rotateImage:(UIImage *)image  Withdegree:(float)degree andContext:(CIContext *)context;
-(UIImage *)flipHorizontal:(UIImage *)image andContext:(CIContext *)context;
-(UIImage *)cropImage:(UIImage *)image withRect:(CGRect)rect andContext:(CIContext *)context;
-(UIImage *)maskWithInputImage:(UIImage *)inputImage backgroundImage:(UIImage *)backgroundImage andMaskImage:(UIImage *)maskImage withContext:(CIContext *)context;
-(UIImage *)CICircularScreenWithnputImage:(UIImage *)image withRadius:(float)inputRadius context:(CIContext*)context;
-(UIImage *)CIBlandModeOfImage:(UIImage *)inputImage andBackgroundImage:(UIImage *)backgroundImage withContext:(CIContext *)context;
-(UIImage *)FilterCISpotLight:(UIImage*)imputImge withContext:(CIContext *)context;
@property (nonatomic,retain) CIContext *context;


@end
