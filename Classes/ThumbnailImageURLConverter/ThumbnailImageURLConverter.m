//
//  ThumbnailImageURLConverter.m
//  ThumbnailImageURLConverterExample
//
//  Created by Yu Sugawara on 2016/03/07.
//  Copyright © 2016年 Yu Sugawara. All rights reserved.
//

#import "ThumbnailImageURLConverter.h"

/**
 *  # API
 *  https://dev.twitter.com/overview/api/entities-in-twitter-objects#media
 *
 *  # Sample
 *  https://twitter.com/TheEllenShow/status/440322224407314432
 *  https://pbs.twimg.com/media/BhxWutnCEAAtEQ6.jpg
 */
static NSString *kTIUCTwitterDomain = @"twimg.com";

/**
 *  # API
 *  https://www.instagram.com/developer/
 *  https://www.instagram.com/developer/embedding/
 *
 *  # Sample
 *  https://www.instagram.com/p/BCJkUwphQcD/
 */
static NSString *kTIUCInstagramDomain = @"instagram.com";

@implementation ThumbnailImageURLConverter

+ (nullable NSURL *)thumbnailURLFromURL:(NSURL *)URL
{
    return [self thumbnailURLFromURL:URL sizeType:TIUCSizeMedium];
}

+ (nullable NSURL *)thumbnailURLFromURL:(NSURL *)URL sizeType:(TIUCSizeType)sizeType
{
    return [self thumbnailURLFromURL:URL sizeType:sizeType serviceType:[URL tiuc_serviceType]];
}

+ (nullable NSURL *)thumbnailURLFromURL:(NSURL *)URL sizeType:(TIUCSizeType)sizeType serviceType:(TIUCServiceType)serviceType
{
    NSString *sizeStr = [self sizeStringWithServiceType:serviceType sizeType:sizeType];
    
    switch (serviceType) {
        case TIUCServiceTwitter:
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@", URL.absoluteString, sizeStr]];
        case TIUCServiceInstagram:
            return [NSURL URLWithString:[NSString stringWithFormat:@"media/?size=%@", sizeStr] relativeToURL:URL];
        case TIUCServiceUnsupported:
        default:
            return nil;
    }
}

+ (NSString *)sizeStringWithServiceType:(TIUCServiceType)serviceType
                               sizeType:(TIUCSizeType)sizeType
{
    switch (serviceType) {
        case TIUCServiceTwitter:
            switch (sizeType) {
                case TIUCSizeThumb:
                    return @"thumb";
                case TIUCSizeSmall:
                    return @"small";
                case TIUCSizeMedium:
                    return @"medium";
                case TIUCSizeLarge:
                    return @"large";
                case TIUCSizeOriginal:
                    return @"orig"; // Undocumented
                default:
                    break;
            }
            break;
        case TIUCServiceInstagram:
            switch (sizeType) {
                case TIUCSizeThumb:
                case TIUCSizeSmall:
                    return @"t";
                case TIUCSizeMedium:
                    return @"m";
                case TIUCSizeLarge:
                case TIUCSizeOriginal:
                    return @"l";
                default:
                    break;
            }
            break;
        case TIUCServiceUnsupported:
        default:
            break;
    }
    
    return nil;
}

@end

@implementation NSURL (ThumbnailImageURLConverter)

- (TIUCServiceType)tiuc_serviceType
{
    NSString *host = self.host;
    
    if ([host hasSuffix:kTIUCTwitterDomain]) {
        if ([host hasPrefix:@"video"] ||
            [host hasPrefix:@"amp"])
        {
            return TIUCServiceUnsupported;
        }
        return TIUCServiceTwitter;
    } else if ([host hasSuffix:kTIUCInstagramDomain]) {
        NSArray<NSString *> *pathComponents = self.pathComponents;
        if ([pathComponents count] < 2) return TIUCServiceUnsupported;
        
        NSString *userName = pathComponents[1];
        if ([userName isEqualToString:@"p"]) {
            return TIUCServiceInstagram;
        }
        return TIUCServiceUnsupported;
    }
    
    return TIUCServiceUnsupported;
}

@end
