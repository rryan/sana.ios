//
//  Question.h
//  kidsAidMultimedia
//
//  Created by Richard Lu on 8/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Question : NSManagedObject {
@private
}
@property (nonatomic) NSString * title;
@property (nonatomic) NSDate * date;
@property (nonatomic) NSManagedObject * questionToImage;

@end
