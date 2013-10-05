//
//  JYGraphic.h
//  MVGraphic
//
//  Created by 재영 김 on 12. 3. 19..
//  Copyright 2012 연세대학교. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JYGraphic : NSObject {
    
}
+ (void )setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
+ (UIImage* )setSquareView:(UIImage *)image ratio:(CGFloat)ratio;
/*
+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+ (UIImage *)addCircle:(UIImage *)img radius:(CGFloat)radius latCon:(CGFloat)lat lonCon:(CGFloat)lon;
+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
*/
@end
