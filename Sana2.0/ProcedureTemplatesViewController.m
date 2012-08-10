//
//  AvailableProceduresTableViewController.m
//  Sana
//
//  Created by Richard on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProcedureTemplatesViewController.h"
#import "SDSServices.h"
#import "ProcedureRunnerViewController.h"

//a class extension, which just means that this is where private properties go
@interface ProcedureTemplatesViewController () {
    
    NSMutableArray *procedureTemplatesArray;
    NSDate *availableProcedureTemplatesLastUpdate;
}
@end

@implementation ProcedureTemplatesViewController

@synthesize sdsServices;
@synthesize procedureNamesArray;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

	//[UIApplication sharedApplication].statusBarHidden = YES;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Home"
				style:UIBarButtonItemStyleBordered target:self action:@selector(homeButtonClicked:)];
	self.navigationItem.leftBarButtonItem = homeButtonItem;
    
    self.sdsServices = [[SDSServices alloc]initWithDelegate:self];
    [sdsServices getProcedureTemplates];
    
}

-(IBAction)homeButtonClicked:(id)sender{
    
	[UIView beginAnimations:nil context:NULL];//class method
	[UIView setAnimationDuration:0.4];
	//note that to animate the return transition, you need to add the superview in the forView: param
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view.superview cache:YES];
	[self.navigationController.view removeFromSuperview];
	[UIView commitAnimations];

}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) loadAvailableProcedureTemplates {
    
    if ([[self getLastUpdated] timeIntervalSinceNow] < -1) {
        
        if (!self.sdsServices) {
            self.sdsServices = [[SDSServices alloc]initWithDelegate:self];
        }
    //        NSArray *result = [self fetchDataFromDisk];
    //        if ([result count] >0) {
    //            self.mAllPatients = [[NSMutableArray alloc]init];
    //            for (RolodexPatientEntity *pt in result) {
    //                [mAllPatients addObject:[self convertRolodexPatientToNSDictionary:pt]];
    //            }
    //            //            NSLog(@"mAllPatients count:%d",[mAllPatients count]);
    //            
    //            int i;
    //            int numPatients = [mAllPatients count];
    //            NSDictionary *lDict = nil;
    //            
    //            for (i = 0; i < numPatients; i++) {
    //                lDict = [mAllPatients objectAtIndex: i];
    //                if ([[lDict objectForKey:@"panel"] isEqualToString:@"1"]) {
    //                    [self.mPanelPatients addObject: lDict];
    //                }
    //            }
    //            
    //            //            printf("self.mAllPatients count: %i", [self.mAllPatients count]);
    //            //            printf("\nself.mPanelPatient count: %i", [self.mPanelPatients count]);
    //            
    //            if ([self.mPanelPatients count]==0) {
    //                NSLog(@"core data no mpanel patients");
    //                self.mListName = @"all";
    //                
    //            }
    //            else {
    //                self.mListName = @"panel";
    //            }
    //            
    //            hideIndex = NO;
    //            [self.tableView setScrollEnabled:YES];
    //            [self.tableView reloadData];  
    //            
    //        } 
    //        else {
//    NSString *lRolodexUrl = [RolodexURL stringByAppendingString:lOncalluserid];
//    NSLog(@"lRolodexurl:%@",lRolodexUrl);
//    [httpTool get:lRolodexUrl withTimeOut:10];
//    [mModalActivityView showWithMessage:@"Loading Rolodex"];
//    hideIndex = YES;

//}
//else {//get new data from server
//    User *user = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] user];
//    NSString *lOncalluserid = user.oncallUserId;
//    NSString *lRolodexUrl = [RolodexURL stringByAppendingString:lOncalluserid];
//    NSLog(@"lRolodexurl:%@",lRolodexUrl);
//    [httpTool get:lRolodexUrl withTimeOut:10];
//    [mModalActivityView showWithMessage:@"Loading Rolodex"];
//    hideIndex = YES;
//}
    }
}

-(NSDate*) getLastUpdated{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate = (NSDate *)[prefs objectForKey:@"availableProcedureTemplatesLastUpdate"];
    if (!lastUpdate) {
        lastUpdate = [NSDate date];
    }
    [self saveLastUpdated:lastUpdate];
    return lastUpdate;
}

-(void) saveLastUpdated:(NSDate *) date{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:date forKey:@"availableProcedureTemplatesLastUpdate"];
}

#pragma mark -
#pragma mark MDSServices Delegate Methods
-(void)gotProcedureTemplates:(NSArray *) formTemplatesArray {
    
    [self.tableView reloadData];
    
}

-(void)gotProcedureTemplatesError:(NSString *)errorString {

}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"Test Procedure";
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    if (!self.sdsServices) {
        self.sdsServices = [[SDSServices alloc]initWithDelegate:self];
    }
    
    GDataXMLDocument *domDoc = [self.sdsServices loadProcedureXML];
    ProcedureRunnerViewController *procedureRunnerVC = [[ProcedureRunnerViewController alloc]initWithNibName:@"ProcedureRunnerViewController" bundle:nil andDomDocument:domDoc];

    [self presentModalViewController:procedureRunnerVC animated:YES];

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

