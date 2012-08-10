//
//  SettingsViewController.m
//  Sana
//
//  Created by Richard on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize settingsData;//an NSDictionary whose keys are the setting category, and values are the settings themselves.  Terrible explanation
//"general" : [phoneNumber], "network" : [packetsize, enablewifionly], "local":[clinic], "personal" : [owner, lostandfoundmessage]
@synthesize settingsSections;//an array representing the titles of each settings general category
//i.e., settingsSection[0] = general, settingsSection[1]= network, settingsSection[2]=local, settingsSection[3]=personal

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Home"
																	  style:UIBarButtonItemStyleBordered target:self action:@selector(homeButtonClicked:)];
	self.navigationItem.leftBarButtonItem = homeButtonItem;
	
	NSArray *generalArray = [[NSArray alloc]initWithObjects:@"Phone Number",@"Sana Version",@"About Sana",@"Contact Us",nil];
	NSArray *networkArray = [[NSArray alloc]initWithObjects:@"Packet Size",@"Force Connection Type",@"Compression", nil];
	NSArray *personalArray = [[NSArray alloc]initWithObjects:@"Owner",@"Clinic",@"Lost and Found Message",@"Alternate Phone Number", nil];
	self.settingsData = [[NSDictionary alloc]initWithObjectsAndKeys:generalArray,@"General",networkArray,@"Network",personalArray,@"Personal",nil ];
	
	self.settingsSections = [[settingsData allKeys]sortedArrayUsingSelector:@selector(compare:)];
	
}

-(IBAction)homeButtonClicked:(id)sender{
	[UIView beginAnimations:nil context:NULL];//class method
	[UIView setAnimationDuration:0.4];
	//note that to animate the return transition, you need to add the superview in the forView: param
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view.superview cache:YES];
	[self.navigationController.view removeFromSuperview];
	[UIView commitAnimations];
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [settingsSections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[settingsData objectForKey:[settingsSections objectAtIndex:section]] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [settingsSections objectAtIndex:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
   	NSString *key =  [settingsSections objectAtIndex: indexPath.section];
	NSString *text = [[settingsData objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
