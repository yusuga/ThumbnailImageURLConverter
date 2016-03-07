//
//  ThumbnailImageURLConverter.h
//  ThumbnailImageURLConverterExample
//
//  Created by Yu Sugawara on 2016/03/07.
//  Copyright © 2016年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TIUCServiceType) {
    TIUCServiceUnsupported,
    TIUCServiceTwitter,
    TIUCServiceInstagram,
};

typedef NS_ENUM(NSInteger, TIUCSizeType) {
    TIUCSizeThumb,
    TIUCSizeSmall,
    TIUCSizeMedium,
    TIUCSizeLarge,
    TIUCSizeOriginal,
};

NS_ASSUME_NONNULL_BEGIN
@interface ThumbnailImageURLConverter : NSObject

+ (nullable NSURL *)thumbnailURLFromURL:(NSURL *)URL;
+ (nullable NSURL *)thumbnailURLFromURL:(NSURL *)URL sizeType:(TIUCSizeType)sizeType;
+ (nullable NSURL *)thumbnailURLFromURL:(NSURL *)URL sizeType:(TIUCSizeType)sizeType serviceType:(TIUCServiceType)serviceType;

@end

@interface NSURL (ThumbnailImageURLConverter)

- (TIUCServiceType)tiuc_serviceType;

@end
NS_ASSUME_NONNULL_END