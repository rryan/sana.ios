//
//  GroupViewControllerViewController.m
//  Sana2.0
//
//  Created by Richard Lu on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"
#import "MultimediaViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

@synthesize theTableView;
@synthesize toolBar;
@synthesize previousButton;
@synthesize nextButton;
@synthesize widgetsArray;
@synthesize pickerDatasourceArray;
@synthesize procedureRunnerViewController;
@synthesize multimediaViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.widgetsArray = [[NSMutableArray alloc]init];
        self.pickerDatasourceArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark UIPickerView Delegate Methods (only if applicable)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.pickerDatasourceArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerDatasourceArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"Selected ethnicity: %@. Index of selected ethnicity: %i", [self.pickerDatasourceArray objectAtIndex:row], row);
}

#pragma mark - 
#pragma mark UISegmentedControl method
- (void)segmentSelected:(id)sender {
    
    NSLog(@"segment selected");
}

-(void) showMultimediaCaptureVC:(id)sender {
   
    NSLog(@"show mm selected");
    MultimediaViewController *mmQuestionVC = [[MultimediaViewController alloc]initWithNibName:@"MultimediaQuestionViewController" bundle:nil];
    [self.procedureRunnerViewController presentViewController:mmQuestionVC animated:YES completion:nil];
    NSLog(@"parent:%@",self.parentViewController);

}

-(void) showCamera:(id)sender {
    
    
    
    
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 380;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

    }

    CGFloat verticalWidgetSpacing = 0;
    NSLog(@"self widgets array:%@",self.widgetsArray);
    for (id item in self.widgetsArray) {
        NSLog(@"item:%@:",item);
        NSLog(@"cell height:%f",cell.bounds.size.height);
//       cell.layer.borderWidth = 1.0f;
//        cell.layer.borderColor = [[UIColor greenColor] CGColor];
        if ([item isKindOfClass:[NSDictionary class]]) {
            id theItem = [item objectForKey:@"widgetObject"];
            CGRect newFrame = CGRectMake(0,verticalWidgetSpacing, cell.bounds.size.width-20, cell.bounds.size.height);
            if ([theItem isKindOfClass:[UIView class]]) {
                UIView *newItem = (UIView *)theItem;
                newItem.frame = newFrame;
                newItem.layer.cornerRadius = 10.0;
//                newItem.layer.borderWidth = 1.0f;
//                newItem.layer.borderColor = [[UIColor redColor] CGColor];
                if ([theItem isKindOfClass:[UITextView class]]) {
                    CGRect newFrame = newItem.frame;
                    newFrame.size.height = tableView.bounds.size.height *0.825;
                    newFrame.size.width = cell.bounds.size.width-20-4;
                    newFrame.origin.x = 2;
                    newItem.frame = newFrame;
                    
                }
                else if ([theItem isKindOfClass:[UIPickerView class]]){
                    UIPickerView *newItem = (UIPickerView *)theItem;
                    newItem.delegate = self;
                }
//                else if ([theItem isKindOfClass:[UIButton class]]){
//                    NSLog(@"button");
//                    UIButton *newItem = (UIButton *)theItem;
//                    [newItem addTarget:self action:@selector(showMultimediaCaptureVC:) forControlEvents:UIControlEventTouchUpInside];
//                }
                [cell.contentView addSubview:newItem];
            }
            else if ([[item objectForKey:@"widgetType"] isEqualToString:@"checkboxes"]){
                NSArray *checkboxesArray = [item objectForKey:@"widgetObject"];
                NSInteger checkboxSpace = 0;
                for (NSMutableDictionary *box in checkboxesArray) {

                    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0,verticalWidgetSpacing + checkboxSpace, cell.bounds.size.width-20, cell.bounds.size.height)];
                    
                    UILabel *boxLabel = [box objectForKey:@"UILabel"];
                    CGRect newBoxFrame = boxLabel.frame;
                    newBoxFrame.origin.x = 2;
                    newBoxFrame.origin.y = 0;
                    newBoxFrame.size.height = 48;
                    newBoxFrame.size.width = cell.bounds.size.width * 0.64;
                    boxLabel.frame = newBoxFrame;
//                    NSLog(@"boxLabel new frame:%@",boxLabel.frame);
                    
                    UISegmentedControl *boxSegmentedControl = [box objectForKey:@"UISegmentedControl"];
                    [boxSegmentedControl addTarget:self action:@selector(segmentSelected:)forControlEvents:UIControlEventValueChanged];
                    CGRect newFrame = boxSegmentedControl.frame;
                    newFrame.origin.x = cell.bounds.size.width * 0.65;
                    newFrame.origin.y = 0;
                    boxSegmentedControl.frame = newFrame;
                    
//                    container.layer.borderWidth = 1.0f;
//                    container.layer.borderColor = [[UIColor redColor] CGColor];
//                    boxLabel.layer.borderWidth = 1.0f;
//                    boxLabel.layer.borderColor = [[UIColor blueColor] CGColor];
//                    boxSegmentedControl.layer.borderWidth = 1.0f;
//                    boxSegmentedControl.layer.borderColor = [[UIColor greenColor] CGColor];

                    [cell.contentView addSubview:container];
                    [container addSubview:boxLabel];
                    [container addSubview:boxSegmentedControl];

                    checkboxSpace += 48;
                }
            }
            else if ([[item objectForKey:@"widgetType"] isEqualToString:@"multimediaGUI"]){
                NSArray *mmButtonsArray = [item objectForKey:@"widgetObject"];
                NSInteger mmButtonVerticalSpacing = tableView.bounds.size.height/4;

                for (UIButton *b in mmButtonsArray) {
                    CGRect newFrame = b.frame;
                    NSLog(@"tableview.bounds.size.width:%f",tableView.bounds.size.width);
                    newFrame.origin.x = (tableView.bounds.size.width)/6;
                    newFrame.origin.y = mmButtonVerticalSpacing;
                    newFrame.size.height = 48;
                    newFrame.size.width = cell.bounds.size.width * 0.60;
                    b.frame = newFrame;
                    b.tag = 2;
//                    b.layer.borderWidth = 1.0f;
//                    b.layer.borderColor = [[UIColor redColor] CGColor];
                    [cell.contentView addSubview:b];
                    mmButtonVerticalSpacing += 58;
                    if (!self.multimediaViewController) {
                        self.multimediaViewController = [[MultimediaViewController alloc]init];
                        self.multimediaViewController.procedureRunnerViewController = self.procedureRunnerViewController;
                    }
                    
                    [b addTarget:self.multimediaViewController action:@selector(addMultimedia:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else {
                NSLog(@"unhandled widget type; not being drawn");
            }
            verticalWidgetSpacing += 48;
        }
    }
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

-(IBAction)previousButtonClicked:(id)sender {
    
}
-(IBAction)nextButtonClicked:(id)sender {
    
}




@end
