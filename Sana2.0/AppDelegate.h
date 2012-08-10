//
//  AppDelegate.h
//  Sana2.0
//
//  Created by Richard Lu on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSServices.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SDSServicesDelegate> {
    
    SDSServices *sdsServices;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) SDSServices *sdsServices;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
