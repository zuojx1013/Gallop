/*
 https://github.com/waynezxcv/Gallop

 Copyright (c) 2016 waynezxcv <liuweiself@126.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */




#import "CALayer+WebCache.h"
#import "CALayer+WebCacheOperation.h"
#import "LWRunLoopTransactions.h"
#import "objc/runtime.h"


static char imageURLKey;

@implementation CALayer(WebCache)

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}


- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}


- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

/**
 *  CornerRadius addtion
 *
 */
- (void)sd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
             containerSize:(CGSize)containerSize
              cornerRadius:(CGFloat)cornerRadius
     cornerBackgroundColor:(UIColor *)color
         cornerBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
                 completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
               containerSize:containerSize
                cornerRadius:cornerRadius
       cornerBackgroundColor:color
           cornerBorderColor:borderColor
                 borderWidth:borderWidth
                    progress:nil
                   completed:completedBlock];
}


- (void)sd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
             containerSize:(CGSize)containerSize
              cornerRadius:(CGFloat)cornerRadius
     cornerBackgroundColor:(UIColor *)color
         cornerBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self setContents:(__bridge id)placeholder.CGImage];
        });
    }
    if (url) {
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url
                                                                                           options:options
                                                                                          progress:progressBlock
                                                                                         completed:^(UIImage *image, NSError *error,
                                                                                                     SDImageCacheType cacheType,
                                                                                                     BOOL finished, NSURL *imageURL) {
                                                                                             if (!wself) return;
                                                                                             dispatch_main_sync_safe(^{
                                                                                                 if (!wself) return;
                                                                                                 if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                                                                                                     completedBlock(image, error, cacheType, url);
                                                                                                     return;
                                                                                                 } else if (image) {
                                                                                                     if (cornerRadius != 0) {
                                                                                                         [wself lw_setImage:image
                                                                                                              containerSize:containerSize
                                                                                                               cornerRadius:cornerRadius
                                                                                                      cornerBackgroundColor:color
                                                                                                          cornerBorderColor:borderColor
                                                                                                                borderWidth:borderWidth];
                                                                                                     } else {
                                                                                                         [wself setContents:(__bridge id)image.CGImage];
                                                                                                     }
                                                                                                     [wself setNeedsLayout];
                                                                                                 } else {
                                                                                                     if ((options & SDWebImageDelayPlaceholder)) {
                                                                                                         [wself setContents:(__bridge id)placeholder.CGImage];
                                                                                                         [wself setNeedsLayout];
                                                                                                     }
                                                                                                 }
                                                                                                 if (completedBlock && finished) {
                                                                                                     completedBlock(image, error, cacheType, url);
                                                                                                 }
                                                                                             });
                                                                                         }];
        [self sd_setImageLoadOperation:operation forKey:@"CALayerImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }


}

#pragma mark -

- (void)sd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self setContents:(__bridge id)placeholder.CGImage];
        });
    }
    if (url) {
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url
                                                                                           options:options
                                                                                          progress:progressBlock
                                                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                                             if (!wself) return;
                                                                                             dispatch_main_sync_safe(^{
                                                                                                 if (!wself) return;
                                                                                                 if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                                                                                                     completedBlock(image, error, cacheType, url);
                                                                                                     return;
                                                                                                 } else if (image) {
                                                                                                     [wself setContents:(__bridge id)image.CGImage];
                                                                                                     [wself setNeedsLayout];
                                                                                                 } else {
                                                                                                     if ((options & SDWebImageDelayPlaceholder)) {
                                                                                                         [wself setContents:(__bridge id)placeholder.CGImage];
                                                                                                         [wself setNeedsLayout];
                                                                                                     }
                                                                                                 }
                                                                                                 if (completedBlock && finished) {
                                                                                                     completedBlock(image, error, cacheType, url);
                                                                                                 }
                                                                                             });
                                                                                         }];
        [self sd_setImageLoadOperation:operation forKey:@"CALayerImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}



- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    [self sd_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"CALayerImageLoad"];
}


- (void)lw_delaySetContents:(id)contents {
    [[LWRunLoopTransactions transactionsWithTarget:self
                                          selector:@selector(setContents:)
                                            object:contents] commit];
}

- (void)lw_setImage:(UIImage *)image
      containerSize:(CGSize)size
       cornerRadius:(CGFloat)cornerRadius
cornerBackgroundColor:(UIColor *)color
  cornerBorderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth {
    CGFloat scale = [UIScreen mainScreen].scale;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(size, YES, scale);
        if (nil == UIGraphicsGetCurrentContext()) {
            return;
        }
        UIBezierPath* cornerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                                              cornerRadius:cornerRadius];
        UIBezierPath* backgroundRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        [color setFill];
        [backgroundRect fill];
        [cornerPath addClip];
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        [borderColor setStroke];
        [cornerPath stroke];
        [cornerPath setLineWidth:borderWidth];
        id processedImageRef = (__bridge id _Nullable)(UIGraphicsGetImageFromCurrentImageContext().CGImage);
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setContents:processedImageRef];
        });
    });
}



@end