//
//  ImagesViewController.m
//  ThumbnailImageURLConverterExample
//
//  Created by Yu Sugawara on 2016/03/07.
//  Copyright © 2016年 Yu Sugawara. All rights reserved.
//

#import "ImagesViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ThumbnailImageURLConverter.h"
#import "TableViewCell.h"
#import "Defines.h"

@interface ImagesViewController ()

@property (nonatomic) NSArray<NSString *> *URLStrings;
@property (nonatomic) NSArray<NSString *> *headerTitles;
@end

@implementation ImagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.URLStrings = @[kTwitterURL,
                        kInstagramURL];
    
    self.headerTitles = @[@"Twitter",
                          @"Instagram"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.URLStrings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TIUCSizeOriginal + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSURL *URL = [NSURL URLWithString:self.URLStrings[indexPath.section]];
    URL = [ThumbnailImageURLConverter thumbnailURLFromURL:URL sizeType:indexPath.row];
    
    NSLog(@"%zd - %zd, URL: %@", indexPath.section, indexPath.row, URL);
    
    cell.sizeLabel.text = @"Requesting...";
    cell.URLLabel.text = URL.absoluteString;
    
    __weak TableViewCell *weakCell = cell;
    cell.thumbnailView.image = nil;
    [cell.thumbnailView setImageWithURLRequest:[NSURLRequest requestWithURL:URL]
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           weakCell.sizeLabel.text = [NSString stringWithFormat:@"SizeType: %zd, Size: %@", indexPath.row, NSStringFromCGSize(image.size)];
                                           weakCell.thumbnailView.image = image;
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           NSLog(@"%@ {\nrequest: %@\nerror: %@\n}", indexPath, request, error);
                                       }];
    
    return cell;
}

@end
