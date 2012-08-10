//
//  Image.h
//  kidsAidMultimedia
//
//  Created by Richard Lu on 8/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Image : NSManagedObject {
@private
}
@property (nonatomic) NSString * name;
@property (nonatomic) id contents;
@property (nonatomic) NSDate * date;
@property (nonatomic) NSString * path;
@property (nonatomic) Question *imageToQuestion;

@end
