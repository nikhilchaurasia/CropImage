    //
//  ViewController.m
//  CoreImage
//
//  Created by StandardUser on 23/08/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import "ViewController.h"
#import "FilterClass.h"
#import "AppDelegate.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()
{
    NSURL *originalImageURL;
    UIImage *originalImage;
    FilterClass *filter;
    CIContext *context;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // UIImage *source = [UIImage imageNamed:@"source"];
    
    context = [CIContext contextWithEAGLContext:[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2] options:nil ];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseImageTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.mediaTypes =UIImagePickerControllerMediaType;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (IBAction)filterTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (!filter) {
        filter = [[FilterClass alloc]init];
    }
    if (btn.tag == 100) {
        originalImage = [filter rotateImage:originalImage Withdegree:270 andContext:context];
        [self.imgMainView setImage:originalImage];
        
    }else
    {
        originalImage = [filter flipHorizontal:originalImage andContext:context];
        [self.imgMainView setImage:originalImage];
    }
    
}

- (IBAction)croptapped:(id)sender {
    /*if (!filter) {
        filter = [[FilterClass alloc]init];
    }
    originalImage = [filter cropImage:originalImage withRect:CGRectMake(0, 0, 100, 100) andContext:context];
    
    [self.imgMainView setImage:originalImage];
     */
    [self maskImage:[UIImage imageNamed:@"source"] andMaskImage:nil];
}

- (IBAction)extraTapped:(id)sender {
    
    //Sopt Light Filter
    
    if (!filter) {
        filter = [[FilterClass alloc]init];
    }
    originalImage = [filter FilterCISpotLight:originalImage withContext:context];
    
    [self.imgMainView setImage:originalImage];
    
    /*
     
     //Bland mode filter
    if (!filter) {
        filter = [[FilterClass alloc]init];
    }
    originalImage = [filter CIBlandModeOfImage:originalImage andBackgroundImage:[self backgroundImageWithSize:originalImage.size] withContext:context];
    
    [self.imgMainView setImage:originalImage];
     */
    
    /*
     //CICircularScreen Filter
     originalImage = [filter CICircularScreenWithnputImage:originalImage withRadius:2.0 context:context];
    
    [self.imgMainView setImage:originalImage];
     */
}

- (IBAction)resetColor:(id)sender {
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    originalImage= [info valueForKey:UIImagePickerControllerOriginalImage];
    originalImage =[self fixOrientation:originalImage];
    NSLog(@"Orientation %d",[originalImage imageOrientation]);
    
    [self.imgMainView setImage:originalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    originalImageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
}




- (void)viewDidUnload {
    [self setOutputImage:nil];
    [super viewDidUnload];
}

- (UIImage *)fixOrientation:(UIImage *)source{
    
    // No-op if the orientation is already correct
    if (source.imageOrientation == UIImageOrientationUp) return source;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (source.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, source.size.width, source.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, source.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, source.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (source.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, source.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, source.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, source.size.width, source.size.height,
                                             CGImageGetBitsPerComponent(source.CGImage), 0,
                                             CGImageGetColorSpace(source.CGImage),
                                             CGImageGetBitmapInfo(source.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (source.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,source.size.height,source.size.width), source.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,source.size.width,source.size.height), source.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}







-(void)maskImage:(UIImage *)source andMaskImage:(UIImage *)mask{
    if (!filter) {
        filter = [[FilterClass alloc]init];
    }
    
    
    
    UIGraphicsBeginImageContextWithOptions(source.size, NO, 0.0f);
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectMake(0, 0, source.size.width, source.size.height));
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *maskImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"red_2013_08_26_10_11_43" ofType:@"png"]] scale:1.0];
    
    UIGraphicsBeginImageContextWithOptions(maskImage.size, YES, 0.0);
    [[UIColor blackColor]setFill];
    [[ViewController imageByTransformingImageBlue:maskImage] drawInRect:CGRectMake(0, 0, maskImage.size.width, maskImage.size.height)];
    maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(source.size, YES, 1.0);
    [[UIColor clearColor]setFill];
    [maskImage drawInRect:CGRectMake(0, 0, source.size.width, source.size.height)];
    maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIImage *filterImage = [filter maskWithInputImage:source backgroundImage:backgroundImage andMaskImage:maskImage withContext:context] ;
    [self.imgMainView setImage:filterImage];
    

    //[self.imgMainView setImage:maskImage];
    
    
     NSData *imagedata = UIImagePNGRepresentation(filterImage);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"maskedFile.png"];
    [filemgr createFileAtPath:filePath contents:imagedata attributes:nil];
        
}

+(UIImage *)imageByTransformingImageBlue:(UIImage *)image{
    
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    //UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation: UIImageOrientationDownMirrored];
    img = nil;
   
    
    
    return flippedImage;
}

-(UIImage *)backgroundImageWithSize:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
   
    [[UIColor colorWithRed:225.0/255.0 green:2.0/255.0 blue:5.0/255.0 alpha:1.0] setFill];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *grayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return grayImage;
}





@end
