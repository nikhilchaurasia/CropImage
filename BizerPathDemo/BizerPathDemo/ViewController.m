//
//  ViewController.m
//  BizerPathDemo
//
//  Created by StandardUser on 26/09/13.
//  Copyright (c) 2013 NGA. All rights reserved.
//

#import "ViewController.h"
#import "PreviewVC.h"
@interface ViewController ()
{
    UIBezierPath *bezerPath;
    UIImageView *imageViewTopLeft,*imageViewButtomLeft,*imageViewRightTop,*imageViewButtomRight,*selectedImageView,*nMidMarker;
    CGPoint nCurrentPoint,nPreviousPoint;
    UIImage *backImage;
    UIImageView *mBackImageview;
    BOOL isImageViewSelected,isMoveAllPoints,isDrawFreely;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //nCurrentPoint = CGPointMake(100, 100);
    UIImage *image = [UIImage imageNamed:@"target" ];
    CGSize rect = [image size];
    

   
       
    imageViewTopLeft = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, rect.width, rect.height)];
    [imageViewTopLeft setImage:image];
    imageViewButtomLeft = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, rect.width, rect.height)];
    [imageViewButtomLeft setImage:image];
    imageViewRightTop = [[UIImageView alloc]initWithFrame:CGRectMake(200, 100, rect.width, rect.height)];
    [imageViewRightTop setImage:image];
    imageViewButtomRight = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200, rect.width, rect.height)];
    [imageViewButtomRight setImage:image];
    
    
    
    nMidMarker = [[UIImageView alloc]initWithFrame:CGRectMake(150, 100, rect.width, rect.height)];
    
    [nMidMarker setImage:image];
   
    
    [self.nBackImageView addSubview:imageViewTopLeft];
     [self.nBackImageView addSubview:imageViewButtomLeft];
     [self.nBackImageView addSubview:imageViewRightTop];
     [self.nBackImageView addSubview:imageViewButtomRight];
    [self.nBackImageView addSubview:nMidMarker];
    
   
     backImage = [UIImage imageNamed:@"Aishwarya"] ;
    mBackImageview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [mBackImageview setImage:backImage];
    [self.view insertSubview:mBackImageview belowSubview:self.nBackImageView];
    
    
    
    [self drawPath];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawPath
{
    if (!bezerPath) {
        bezerPath = [[UIBezierPath alloc]init];
    }
    [bezerPath removeAllPoints];
    [bezerPath setLineCapStyle:kCGLineCapRound];
    [bezerPath setLineWidth:5.0f];
    
    CGPoint centerPoint = CGPointMake((imageViewTopLeft.center.x+imageViewRightTop.center.x)*0.5, (imageViewTopLeft.center.x+imageViewRightTop.center.x)*0.5);
    CGFloat yDiff = nMidMarker.center.y - centerPoint.y;
    CGFloat xDiff = nMidMarker.center.x - centerPoint.x;
    
    CGPoint controlPoint = CGPointMake(nMidMarker.center.x+xDiff, nMidMarker.center.y+yDiff);
    
    CGPoint point =  CGPointMake(imageViewTopLeft.center.x, imageViewTopLeft.center.y);
    [bezerPath moveToPoint:point];
    point = CGPointMake(imageViewRightTop.center.x, imageViewRightTop.center.y);
    [bezerPath addQuadCurveToPoint:point controlPoint:controlPoint];
    point = CGPointMake(imageViewButtomRight.center.x  , imageViewButtomRight.center.y);
    [bezerPath addLineToPoint:point];
    point = CGPointMake(imageViewButtomLeft.center.x, imageViewButtomLeft.center.y);
    [bezerPath addLineToPoint:point];
    
    [bezerPath closePath];
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [[UIScreen mainScreen]scale]);
   
    [[UIColor clearColor]setFill];
    UIRectFill(self.view.frame);
    [[UIColor blackColor]setStroke];
    
    [bezerPath stroke];
    [[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5] setFill];
    
    [bezerPath fill];
    
    
    self.nBackImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    if (isDrawFreely) {
        
    }else{
        selectedImageView = [self getSelectedImageView:currentPoint];
        NSLog(@"%f,%f",currentPoint.x,currentPoint.y);
        
    }
    nPreviousPoint = currentPoint;
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    if (isDrawFreely) {
        [self drawFreely:currentPoint];
    }else{
        CGPoint translationPoint  = CGPointMake(currentPoint.x - nPreviousPoint.x  , currentPoint.y - nPreviousPoint.y);
        NSLog(@"%f,%f",translationPoint.x,translationPoint.y);
        if (isMoveAllPoints) {
            [self moveAllPoints:translationPoint];
            [self drawPath];
            
        }
        
        if(selectedImageView){
            selectedImageView = [self getSelectedImageView:currentPoint];
            [selectedImageView setCenter:currentPoint];
            [self drawPath];
        }
        
    }
    nPreviousPoint = currentPoint;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    selectedImageView = nil;
    isMoveAllPoints = NO;
}

-(UIImageView *)getSelectedImageView:(CGPoint)currentTouchPoint
{
    if (CGRectContainsPoint(imageViewTopLeft.frame, currentTouchPoint)) {
        return imageViewTopLeft;
    }
     else if(CGRectContainsPoint(imageViewButtomLeft.frame, currentTouchPoint)) {
        return imageViewButtomLeft;
    }
     else if(CGRectContainsPoint(imageViewRightTop.frame, currentTouchPoint)) {
        return imageViewRightTop;
    }
     else if(CGRectContainsPoint(imageViewButtomRight.frame, currentTouchPoint)) {
        return imageViewButtomRight;
    }else if(CGRectContainsPoint(nMidMarker.frame, currentTouchPoint)) {
        return nMidMarker;
    }else if ([bezerPath containsPoint:currentTouchPoint]){
        isMoveAllPoints = YES;
    }
   
    return nil;
}

-(UIImage *)image:(UIImage *)originalImage withImage:(UIImage *)maskImage
{
    CGImageRef imgRef = originalImage.CGImage;
    CGImageRef maskImageRef = maskImage.CGImage;
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
                                              CGImageGetHeight(maskImageRef),
                                              CGImageGetBitsPerComponent(maskImageRef),
                                              CGImageGetBitsPerPixel(maskImageRef),
                                              CGImageGetBytesPerRow(maskImageRef),
                                              CGImageGetDataProvider(maskImageRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    return [UIImage imageWithCGImage:masked];
   
    
}




- (IBAction)nMaskImageTapped:(id)sender {
    self.nBackImageView.alpha = 1.0;
    [imageViewButtomLeft setHidden:NO];
    [imageViewButtomRight setHidden:NO];
    [imageViewRightTop setHidden:NO];
    [imageViewTopLeft setHidden:NO];
    [nMidMarker setHidden:NO];
    [self drawPath];
    isDrawFreely = NO;
}

- (IBAction)freeMoveTapped:(id)sender {
    [bezerPath removeAllPoints];
    [self.nBackImageView setImage:nil];
    [imageViewButtomLeft setHidden:YES];
    [imageViewButtomRight setHidden:YES];
    [imageViewRightTop setHidden:YES];
    [imageViewTopLeft setHidden:YES];
    [nMidMarker setHidden:YES];
    isDrawFreely = YES;
    
    
}

- (IBAction)goTapped:(id)sender {
    [self performSegueWithIdentifier:@"PREVIEW_SEGUE" sender:nil];
}

-(void)drawFreely:(CGPoint)currentPoint
{
    if (self.nBackImageView.alpha == 1.0) {
        self.nBackImageView.alpha = 0.5;
    }
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    //[[UIColor clearColor] set];
  //  UIRectFill(self.view.frame);
    [self.nBackImageView.image drawInRect:self.view.bounds];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
    CGContextSetAlpha(UIGraphicsGetCurrentContext(), 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),nPreviousPoint.x, nPreviousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.nBackImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PreviewVC *previewVC = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"PREVIEW_SEGUE"]) {
        if (isDrawFreely) {
            UIImage *im = self.nBackImageView.image;
            
            im = [self createStencilWithCollapseAlpha:YES withImage:im];
            im = [self image:mBackImageview.image withImage:im];
            //UIImageWriteToSavedPhotosAlbum(im, nil, nil, nil);
            previewVC.imageP = im;
        }else{
            UIImage *im  =  [self image:mBackImageview.image withImage:[self createImageFromBeizerPath]];
            previewVC.imageP = im;
        }
               
        
    }
}


-(UIImage *)createImageFromBeizerPath
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIColor whiteColor]setFill];
    UIRectFill(self.view.frame);
    
    [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] setFill];
    [bezerPath fill];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}

-(void)moveAllPoints:(CGPoint)translationPoint
{
    CGPoint center = imageViewTopLeft.center;
    center.x += translationPoint.x;
    center.y += translationPoint.y;
    imageViewTopLeft.center = center;
    
    center = imageViewRightTop.center;
    center.x += translationPoint.x;
    center.y += translationPoint.y;
    imageViewRightTop.center = center;
    
    center = imageViewButtomRight.center;
    center.x += translationPoint.x;
    center.y += translationPoint.y;
    imageViewButtomRight.center = center;
    
   
    
    center = imageViewButtomLeft.center;
    center.x += translationPoint.x;
    center.y += translationPoint.y;
    imageViewButtomLeft.center = center;
    
    center = nMidMarker.center;
    center.x += translationPoint.x;
    center.y += translationPoint.y;
    nMidMarker.center = center;
    
}

- (UIImage *)createStencilWithCollapseAlpha: (BOOL) inCollapseAlpha withImage:(UIImage *)image
{
    // Create image rectangle with current image width/height
    // oddly the size field of UIImage should be in points and we need pixels so we shoud have to multiply by self.scale
    // but that isn't what I'm seeing...
    // Need better test images to see if we are losing detail by not making the bitmap larger.
    float scale = [[UIScreen mainScreen]scale];
    CGRect imageRect = CGRectMake(0, 0, self.view.frame.size.width*scale, self.view.frame.size.height*scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    NSLog(@"%d,%d",width,height);
    
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for ( int y = 0; y < height; y++ )
    {
        for ( int x = 0; x < width; x++ )
        {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            if (inCollapseAlpha )
            {
                if ( rgbaPixel[0] == 0.0 ){
                    rgbaPixel[0] = 255.0;
                    rgbaPixel[1] = 255.0;       // R
                    rgbaPixel[2] = 255.0;       // G
                    rgbaPixel[3] = 255.0;
                    
                    
                }else{
                    rgbaPixel[0] = 255.0;
                    
                    rgbaPixel[1] = 0.0;       // R
                    rgbaPixel[2] = 0.0;       // G
                    rgbaPixel[3] = 0.0;
                }
            }
            // set pixels to black
                   // B
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image1 = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // in order to get the scale right for retina we need to do this:
    
    UIImage * result = [UIImage imageWithCGImage:image1 scale:scale orientation:0];
    CGImageRelease( image1 );
    
    return result;
}


-(UIImage *)imageByTransformingImageBlue:(UIImage *)image{
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    //UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation: UIImageOrientationDownMirrored];
    img = nil;
    
    return flippedImage;
}


@end
