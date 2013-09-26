//
//  FilterClass.m
//  CoreImage
//
//  Created by StandardUser on 23/08/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import "FilterClass.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface FilterClass() {
//    CIFilter *filter;
}

@end


@implementation FilterClass

-(UIImage *)rotateImage:(UIImage *)image  Withdegree:(float)degree andContext:(CIContext *)context
{
       
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];;
     CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    NSValue *value = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree))];
    [filter setValue:value forKey:@"inputTransform"];
    CIImage *outoputCIImage = [filter outputImage];
    
    CGImageRef  outputRef = [context createCGImage:outoputCIImage fromRect:[outoputCIImage extent]];
    UIImage *filteredImage = [UIImage imageWithCGImage:outputRef];
    CGImageRelease(outputRef);
    return filteredImage;
    
}

-(UIImage *)flipHorizontal:(UIImage *)image andContext:(CIContext *)context
{

    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
     CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    NSValue *value = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(-1, 1)];
    [filter setValue:value forKey:@"inputTransform"];
    ciImage = [filter outputImage];
    CGImageRef  outputRef = [context createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *outputImage = [UIImage imageWithCGImage:outputRef];
    CGImageRelease(outputRef);
    ciImage = nil;
    filter = nil;
    return outputImage;
}

-(UIImage *)cropImage:(UIImage *)image withRect:(CGRect)rect andContext:(CIContext *)context
{
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
    [cropFilter setValue:ciImage forKey:kCIInputImageKey];
    
    CIVector *vector = [CIVector vectorWithX:rect.origin.x Y:image.size.height - (rect.origin.y+rect.size.height) Z:rect.size.width W:rect.size.height];
    [cropFilter setValue:vector forKey:@"inputRectangle"];
    CGImageRef  outputRef = [context createCGImage:[cropFilter outputImage] fromRect:[[cropFilter outputImage] extent]];
    UIImage *filteredOutput = [UIImage imageWithCGImage:outputRef];
    CGImageRelease(outputRef);
    cropFilter = nil;
    vector = nil;
    return filteredOutput;
}

-(float)convertUIKitCoToCoreImageCo:(float)y inRect:(CGRect )rect
{
    return rect.size.height-y;
}

-(UIImage *)maskWithInputImage:(UIImage *)inputImage backgroundImage:(UIImage *)backgroundImage andMaskImage:(UIImage *)maskImage withContext:(CIContext *)context
{
    CIImage *ciInputImage = [CIImage imageWithCGImage:[inputImage CGImage] options:nil];
    CIImage *cibackImage = [CIImage imageWithCGImage:[backgroundImage CGImage] options:nil];
    CIImage *ciInputMaskImage = [CIImage imageWithCGImage:[maskImage CGImage] options:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [filter setValue:ciInputImage forKey:@"inputImage"];
    [filter setValue:cibackImage forKey:@"inputBackgroundImage"];
    [filter setValue:ciInputMaskImage forKey:@"inputMaskImage"];
    
    
    CGImageRef outPutRef = [context createCGImage:[filter outputImage] fromRect:[ciInputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:outPutRef];
    CGImageRelease(outPutRef);
    return outputUIImage;
}

-(UIImage *)CICircularScreenWithnputImage:(UIImage *)image withRadius:(float)inputRadius context:(CIContext*)context
{
    CIImage *ciInputImage = [CIImage imageWithCGImage:[image CGImage] options:nil];
    CIFilter *ciCircularWrapFilter = [CIFilter filterWithName:@"CICircularScreen"];
    [ciCircularWrapFilter setValue:ciInputImage forKey:kCIInputImageKey];
    [ciCircularWrapFilter setValue:[NSNumber numberWithFloat:inputRadius] forKey:@"inputWidth"] ;
    CGImageRef outPutRef = [context createCGImage:[ciCircularWrapFilter outputImage] fromRect:[ciInputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:outPutRef];
    CGImageRelease(outPutRef);
    return outputUIImage;
}

-(UIImage *)CIBlandModeOfImage:(UIImage *)inputImage andBackgroundImage:(UIImage *)backgroundImage withContext:(CIContext *)context{
    CIImage *ciInputImage = [CIImage imageWithCGImage:[inputImage CGImage] options:nil];
    
//    CIFilter *blendModeFilter = [CIFilter filterWithName:@"CIColorBlendMode"];
//    CIFilter *blendModeFilter = [CIFilter filterWithName:@"CIColorBurnBlendMode"];
    CIFilter *blendModeFilter = [CIFilter filterWithName:@"CIColorBurnBlendMode"];
    [blendModeFilter setValue:ciInputImage forKey:kCIInputImageKey];
    [blendModeFilter setValue:[CIImage imageWithCGImage:[backgroundImage CGImage] options:nil] forKey:@"inputBackgroundImage"] ;
    CGImageRef outPutRef = [context createCGImage:[blendModeFilter outputImage] fromRect:[ciInputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:outPutRef];
    CGImageRelease(outPutRef);
    return outputUIImage;
}

-(UIImage *)FilterCISpotLight:(UIImage*)imputImge withContext:(CIContext *)context
{
    CIImage *ciInputImage = [CIImage imageWithCGImage:[imputImge CGImage] options:nil];
//    CIFilter *spotLightFilter = [CIFilter filterWithName:@"CIVignette"];
    
    CIFilter *spotLightFilter = [CIFilter filterWithName:@"CIGlideReflectedTile"];
    [spotLightFilter setValue:ciInputImage forKey:@"inputImage"];
 //  [spotLightFilter setValue:[NSNumber numberWithFloat:20.3] forKey:@"inputRadius"];
  //  [spotLightFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
    
     
    CGImageRef outPutRef = [context createCGImage:[spotLightFilter outputImage] fromRect:[ciInputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:outPutRef];
    CGImageRelease(outPutRef);
    return outputUIImage;
    
}





@end
