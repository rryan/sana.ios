//
//  MultimediaViewController.h
//  kidsAidMultimedia
//
//  Created by Richard Lu on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SanaConstants.h"
#import "ProcedureRunnerViewController.h"

@interface MultimediaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

    ProcedureRunnerViewController *procedureRunnerViewController;
@private
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) ProcedureRunnerViewController *procedureRunnerViewController;

-(IBAction)addMultimedia:(id)sender;
-(BOOL)showMultimediaCaptureUI: (MultimediaType) mmType presentingViewController: (UIViewController *) vc delegate:(id <UIImagePickerControllerDelegate>) theDelegate;
-(void)saveMultimediaToDatabase:(id)mm;

@end
