//
//  HomeViewController.h
//  Sana
//
//  Created by Richard on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "JBKenBurnsView.h"

@class SettingsViewController;
@class GradientButton;

@interface HomeViewController : UIViewController <KenBurnsViewDelegate>{
    
	
	__weak GradientButton *createNewEncounterButton;
	__weak GradientButton *vewPreviousEncountersButton;
	__weak GradientButton *viewNotificationsButton;
	__weak GradientButton *settingsButton;
	UINavigationController *availableProceduresNavigationController;
	UINavigationController *previousEncountersNavigationController;
	UINavigationController *notificationsNavigationController;
	UINavigationController *settingsNavigationController;
    KenBurnsView *kenView;

}

//@property (strong, nonatomic) DetailViewController *detailViewController;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//weak is recommended for IBOutlet properties; also update the backing ivars (note keyword "__weak")
@property (nonatomic, weak) IBOutlet GradientButton *createNewEncounterButton;
@property (nonatomic, weak) IBOutlet GradientButton *viewPreviousEncountersButton;
@property (nonatomic, weak) IBOutlet GradientButton *viewNotificationsButton;
@property (nonatomic, weak) IBOutlet GradientButton *settingsButton;

@property (nonatomic, strong) UINavigationController *availableProceduresNavigationController;
@property (nonatomic, strong) UINavigationController *previousEncountersNavigationController;
@property (nonatomic, strong) UINavigationController *notificationsNavigationController;
@property (nonatomic, strong) UINavigationController *settingsNavigationController;

@property (nonatomic, retain) IBOutlet KenBurnsView *kenView;

-(IBAction)createNewEncounter:(id)sender;
-(IBAction)viewPreviousEncounters:(id)sender;
-(IBAction)viewNotifications:(id)sender;
-(IBAction)viewSettings:(id)sender;

@end
