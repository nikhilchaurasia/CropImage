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
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    nCurrentPoint = CGPointMake(100, 100);
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
    [self getSelectedImageView:currentPoint];
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    nCurrentPoint = [touch locationInView:self.view];
    [self getSelectedImageView:nCurrentPoint];
    
    [selectedImageView setCenter:nCurrentPoint];
    [self drawPath];
    nPreviousPoint = nCurrentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    selectedImageView = nil;
}

-(UIImageView *)getSelectedImageView:(CGPoint)currentTouchPoint
{
    if (CGRectContainsPoint(imageViewTopLeft.frame, currentTouchPoint)) {
        selectedImageView = imageViewTopLeft;
    }
    if (CGRectContainsPoint(imageViewButtomLeft.frame, currentTouchPoint)) {
        selectedImageView = imageViewButtomLeft;
    }
    if (CGRectContainsPoint(imageViewRightTop.frame, currentTouchPoint)) {
        selectedImageView = imageViewRightTop;
    }
    if (CGRectContainsPoint(imageViewButtomRight.frame, currentTouchPoint)) {
        selectedImageView = imageViewButtomRight;
    }if (CGRectContainsPoint(nMidMarker.frame, currentTouchPoint)) {
        selectedImageView = nMidMarker;
    }
   
    return selectedImageView;
}

-(UIImage *)image:(UIImage *)originalImage withImage:(UIImage *)maskImage
{
   // UIGraphicsBeginImageContext(self.view.frame.size);
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
   // UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
  //  UIGraphicsEndImageContext();
    
}




- (IBAction)nMaskImageTapped:(id)sender {

    
   
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PREVIEW_SEGUE"]) {
        
        PreviewVC *previewVC = segue.destinationViewController;
        UIImage *im  =  [self image:mBackImageview.image withImage:[self createImageFromBeizerPath]];
        previewVC.imageP = im;
        
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

@end
