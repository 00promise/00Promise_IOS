//
//  JYGraphic.m
//  MVGraphic
//
//  Created by 재영 김 on 12. 3. 19..
//  Copyright 2012 알마테르. All rights reserved.
//

#import "JYGraphic.h"
#import <QuartzCore/QuartzCore.h>

@implementation JYGraphic

/// 동그라미 이미지뷰 만드는 함수
+ (void )setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize
{
    //UIImage* img = [self setSquareView:roundedView.image ratio:newSize];
    //UIImageView* imgView = [[UIImageView alloc] initWithImage:img];
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;

    roundedView.center = saveCenter;
    roundedView.layer.masksToBounds = YES;
    //[roundedView release];
}
// 작사각형을 정사각형으로 만드는 함수
+ (UIImage* )setSquareView:(UIImage *)image ratio:(CGFloat)ratio 
{
    // Create a thumbnail version of the image for the event object.
	CGSize size = image.size;
	CGSize croppedSize;
	CGFloat offsetX = 0.0;
	CGFloat offsetY = 0.0;
    
	// check the size of the image, we want to make it 
	// a square with sides the size of the smallest dimension
	if (size.width > size.height) {
		offsetX = (size.height - size.width) / 2;
		croppedSize = CGSizeMake(size.height, size.height);
	} else {
		offsetY = (size.width - size.height) / 2;
		croppedSize = CGSizeMake(size.width, size.width);
	}
    
	// Crop the image before resize
	CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
	// Done cropping
    
	// Resize the image
	CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
	UIGraphicsBeginImageContext(rect.size);
	[[UIImage imageWithCGImage:imageRef] drawInRect:rect];
	UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	// Done Resizing
    
	return thumbnail;
}
+ (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object  
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

+(UIImage *)addCircle:(UIImage *)img radius:(CGFloat)radius latCon:(CGFloat)lat lonCon:(CGFloat)lon{
    int w = img.size.width;
    int h = img.size.height; 
    lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
	//draw the circle
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
	CGRect leftOval = {lat- radius/2, lon - radius/2, radius, radius};
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.3);
	CGContextAddEllipseInRect(context, leftOval);
	CGContextFillPath(context);
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}

+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if ((CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipLast)) {
        
        CGImageRef retVal = NULL;
        
        size_t width = CGImageGetWidth(sourceImage);
        size_t height = CGImageGetHeight(sourceImage);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                              8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        if (offscreenContext != NULL) {
            CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
            
            retVal = CGBitmapContextCreateImage(offscreenContext);
            CGContextRelease(offscreenContext);
        }
        
        CGColorSpaceRelease(colorSpace);
        imageWithAlpha = retVal;
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;
}
+(UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //create a context to do our clipping in
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 imageToCrop.size.width,
                                 imageToCrop.size.height);
    
    //draw the image to our clipped context using our offset rect
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    
    //pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    return cropped;
}


@end
