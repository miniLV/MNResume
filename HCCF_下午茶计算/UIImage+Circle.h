//
//  UIImage+Circle.h
//  UIImage
//
//  Created by Mac on 15/11/23.
//  Copyright © 2016年 Lyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circle)

- (UIImage *)circleImage;

//截取一丢丢圆弧
- (UIImage *)AlittleCircleImage;

//方法2
-(UIImage *)makeRoundedImageSeRadius: (float) radius;


@end
