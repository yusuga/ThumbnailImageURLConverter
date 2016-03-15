//
//  ThumbnailImageURLConverterTests.m
//  ThumbnailImageURLConverterTests
//
//  Created by Yu Sugawara on 2016/03/07.
//  Copyright © 2016年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AFNetworking/AFNetworking.h>
#import "ThumbnailImageURLConverter.h"
#import "Defines.h"

@interface ThumbnailImageURLConverterTests : XCTestCase

@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation ThumbnailImageURLConverterTests

- (void)setUp
{
    [super setUp];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    self.manager = manager;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThumbnailURL
{
    for (TIUCServiceType serviceType = TIUCServiceTwitter; serviceType <= TIUCServiceInstagram; serviceType++) {
        NSString *URLString;
        switch (serviceType) {
            case TIUCServiceTwitter:
                URLString = kTwitterURL;
                break;
            case TIUCServiceInstagram:
                URLString = kInstagramURL;
                break;
            default:
                XCTFail(@"Unsupported serviceType: %zd", serviceType);
                continue;
        }
        
        for (TIUCSizeType sizeType = 0; sizeType <= TIUCSizeOriginal; sizeType++) {
            NSURL *URL = [ThumbnailImageURLConverter thumbnailURLFromURL:[NSURL URLWithString:URLString]
                                                                sizeType:sizeType];
            
            XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __func__]];
            [self.manager GET:URL.absoluteString
                   parameters:nil
                      success:^(AFHTTPRequestOperation * _Nonnull operation, UIImage * _Nonnull responseObject) {
                          XCTAssertTrue([responseObject isKindOfClass:[UIImage class]]);
                          NSLog(@"Success: %@, %@", operation.request.URL, NSStringFromCGSize(responseObject.size));
                          [expectation fulfill];
                      } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                          XCTFail(@"Failure: operation: %@, error: %@", operation, error);
                          [expectation fulfill];
                      }];
            [self waitForExpectationsWithTimeout:10. handler:^(NSError *error) {
                XCTAssertNil(error, @"error: %@", error);
            }];
        }
    }
}

- (void)testIgnoreURLOfInstagramUser
{
    NSURL *URL = [NSURL URLWithString:kInstagramUserURL];
    
    XCTAssertEqual([URL tiuc_serviceType], TIUCServiceUnsupported);
    XCTAssertNil([ThumbnailImageURLConverter thumbnailURLFromURL:URL]);
}

@end
