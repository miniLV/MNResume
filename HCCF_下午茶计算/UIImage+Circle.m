//
//  UIImage+Circle.m
//  UIImage
//
//  Created by Mac on 15/11/23.
//  Copyright © 2016年 Lyh. All rights reserved.
//

#import "UIImage+Circle.h"
//#import "UIImageView+WebCache.h"

@implementation UIImage (Circle)

- (UIImage *)circleImage{
    UIGraphicsBeginImageContext(self.size);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

#pragma mark - 截取一丢丢圆弧
- (UIImage *)AlittleCircleImage{

    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获取绘制区域
    CGFloat radius = MIN(self.size.width, self.size.height)*0.5;
    
    CGFloat width = radius * 2;
    
    CGFloat height = width;
    
    CGRect drawRect = CGRectMake(0, 0, width, height);
    
    //使用UIBezierPath 路径裁切
    UIBezierPath *bezierPaht = [UIBezierPath bezierPathWithRect:drawRect];
    
    //添加到路径上
    [bezierPaht addClip];
    
    //将图片绘制在裁剪区域内
    [self drawInRect:drawRect];
    
    //获取绘制的图片
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图文上下文
     UIGraphicsEndImageContext();
    
    return getImage;
 
}
//方法2
-(UIImage *)makeRoundedImageSeRadius: (float) radius
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    imageLayer.contents = (id) self.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(self.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

@end
