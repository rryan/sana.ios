//
//  PhotoViewController.m
//  kidsAidMultimedia
//
//  Created by Richard Lu on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "Image.h"

@implementation PhotoViewController

@synthesize image;
@synthesize imageView;

- (void)loadView {
	self.title = @"Photo";
    
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    
    self.view = imageView;
}


- (void)viewWillAppear:(BOOL)animated {
    //load the picture into the view
    imageView.image = [UIImage imageWithContentsOfFile:image.path];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




@end

