//
//  PhotoViewController.h
//  kidsAidMultimedia
//
//  Created by Richard Lu on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Image;

@interface PhotoViewController : UIViewController{


@private
    Image *image;
    UIImageView *imageView;
}

@property(nonatomic) Image *image;
@property(nonatomic) UIImageView *imageView;

@end