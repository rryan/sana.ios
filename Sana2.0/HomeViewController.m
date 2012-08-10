//
//  HomeViewController.m
//  Sana
//
//  Created by Richard on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "ProcedureTemplatesViewController.h"
#import "PreviousEncountersViewController.h"
#import "NotificationsViewController.h"
#import "SettingsViewController.h"
#import "GradientButton.h"

@implementation HomeViewController

//@synthesize detailViewController = _detailViewController;
//@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

@synthesize createNewEncounterButton;
@synthesize viewPreviousEncountersButton;
@synthesize viewNotificationsButton;
@synthesize settingsButton;

@synthesize availableProceduresNavigationController;
@synthesize previousEncountersNavigationController;
@synthesize notificationsNavigationController;
@synthesize settingsNavigationController;

@synthesize kenView;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

-(IBAction)createNewEncounter:(id)sender{

	ProcedureTemplatesViewController *availableProcedureTemplatesVC = [[ProcedureTemplatesViewController alloc]initWithNibName:@"ProcedureTemplatesViewController"
																	bundle:nil];
	self.availableProceduresNavigationController = [[UINavigationController alloc]initWithRootViewController:availableProcedureTemplatesVC];
	[UIView beginAnimations:nil context:NULL];//class method
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];

	//set the color of the navbar to black
	self.availableProceduresNavigationController.navigationBar.tintColor = [UIColor blackColor];

	availableProcedureTemplatesVC.title = @"Choose A Procedure";
	
	[self.view addSubview:self.availableProceduresNavigationController.view];
	
	[UIView commitAnimations];
	
}


-(IBAction)viewPreviousEncounters:(id)sender{
	NSLog(@"viewing prev encounter");
	PreviousEncountersViewController *previousEncountersViewController = [[PreviousEncountersViewController alloc]initWithNibName:@"PreviousEncountersViewController"
																												  bundle:nil];
	
	[UIView beginAnimations:nil context:NULL];//class method
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	
	self.previousEncountersNavigationController = [[UINavigationController alloc]initWithRootViewController:previousEncountersViewController];
	//previousEncountersNavigationController.navigationBar.barStyle = UIBarStyleBlack;//this is one way to change navigationbar's color
	previousEncountersNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	previousEncountersViewController.title = @"Previous Encounters";
	
	[self.view addSubview:self.previousEncountersNavigationController.view];
	
	[UIView commitAnimations];
}


-(IBAction)viewNotifications:(id)sender{
	NSLog(@"view notifications");
	
	NotificationsViewController *notificationsViewController = [[NotificationsViewController alloc]initWithNibName:@"NotificationsViewController"
																																			 bundle:nil];
	self.notificationsNavigationController = [[UINavigationController alloc]initWithRootViewController:notificationsViewController];
	notificationsNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[UIView beginAnimations:nil context:NULL];//class method
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	

	notificationsViewController.title = @"Available Notifications";
	
	[self.view addSubview:self.notificationsNavigationController.view];
	
	[UIView commitAnimations];
}

-(IBAction)viewSettings:(id)sender{
	NSLog(@"view settings");

	SettingsViewController *settingsViewController = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
	settingsViewController.title = @"Settings";
	self.settingsNavigationController = [[UINavigationController alloc]initWithRootViewController:settingsViewController];//make sure these are set prior to 
	//beginning the animation effect or else there is a slight delay in having the nav bar appear
	self.settingsNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[UIView beginAnimations:nil context:NULL];//class method
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];

	[self.view addSubview:self.settingsNavigationController.view];
	
	[UIView commitAnimations];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
	
	//UIGlassButton *NewEncounterButton = [UIGlassButton alloc] initWithFrame:CGRectMake(20, 20, 200, 40)];
	//[NewEncounterButton setTitle:@"Create New Encounter" forState:UIControlStateNormal];
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[UIApplication sharedApplication].statusBarHidden = YES;//hide the status bar with carrier info, etc
	[self.createNewEncounterButton useRedDeleteStyle];
	[self.viewPreviousEncountersButton useRedDeleteStyle];
	[self.viewNotificationsButton useRedDeleteStyle];
	[self.settingsButton useBlackStyle];
	
	//creating gradient button in code
	/*GradientButton *testButton = [[GradientButton alloc]initWithFrame:CGRectMake(20, 223, 280, 72)];
	[testButton setTitle:@"Create New Encounter" forState:UIControlStateNormal];
	[testButton useRedDeleteStyle];
	[self.view addSubview:testButton];*/
    
    //start the KenBurnsEffect. Thanks JK!
    self.kenView.layer.borderWidth = 1;
    self.kenView.layer.borderColor = [UIColor blackColor].CGColor;
    self.kenView.delegate = self;
    
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"main_background.png"],
                         [UIImage imageNamed:@"sun_moon_lake.jpg"],
                         [UIImage imageNamed:@"mountain_village.jpg"],
                         [UIImage imageNamed:@"african_merchant.jpg"],
                         [UIImage imageNamed:@"senagalese_women.jpg"],
                         [UIImage imageNamed:@"rural_brazil.jpg"],
                         [UIImage imageNamed:@"rip_van_winkle.jpg"],
                         [UIImage imageNamed:@"wooden_house.jpg"],
                         nil];
    
    [self.kenView animateWithImages:myImages transitionDuration:20 loop:YES isLandscape:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.kenView.delegate = nil;
    [self setKenView:nil];
}

#pragma KenBurnsViewDelegate
- (void)didShowImageAtIndex:(NSUInteger)index
{
    NSLog(@"Finished image: %d", index);
}

- (void)didFinishAllAnimations
{
    NSLog(@"Yay all done!");
}

@end
