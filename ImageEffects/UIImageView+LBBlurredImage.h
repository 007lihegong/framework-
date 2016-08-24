//
//  UIImageView+LBBlurredImage.h
//  LBBlurredImage
//
//  Created by Luca Bernardi on 11/11/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

@import UIKit;


typedef void(^LBBlurredImageCompletionBlock)(void);

extern CGFloat const kLBBlurredImageDefaultBlurRadius;

@interface UIImageView (LBBlurredImage)

/**
    设置模糊效果，图像，系数1-20,主线block
 */
- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(LBBlurredImageCompletionBlock)completion;

/**
 设置模糊效果，定义好了的模糊系数
 */
- (void)setImageToBlur:(UIImage *)image
       completionBlock:(LBBlurredImageCompletionBlock)completion;

@end
