//
//  ProcedureRunnerViewController.m
//  Mojo
//
//  Created by Richard Lu on 5/16/12.
//  Copyright (c) 2012 MGH Lab of Computer Science. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ProcedureRunnerViewController.h"
#import "GradientButton.h"
#import "GroupViewController.h"

static NSUInteger kNumberOfPages = 6;

@implementation ProcedureRunnerViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize navigationBar;
@synthesize viewControllers;
@synthesize dataDictionary;

@synthesize groupVC;
@synthesize domDocument;
@synthesize currentElement;

@synthesize procedureWidgetsArray;
@synthesize currentGroupWidgetsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDomDocument:(GDataXMLDocument *)domDoc 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.domDocument = domDoc;
        self.dataDictionary = [[NSMutableDictionary alloc]init];
               
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < kNumberOfPages; i++)
        {
            NSLog(@"adding a controller");
            [controllers addObject:[NSNull null]];
        }
        self.viewControllers = controllers;
        
        [self.view addSubview:scrollView];//i had to add the scrollview though it's an outlet
        
        // a page is the width of the scroll view
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
        NSLog(@"scrollview size:%f,%f",scrollView.contentSize.width,scrollView.contentSize.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        
        pageControl.numberOfPages = kNumberOfPages;
        pageControl.currentPage = 0;
        
        // pages are created on demand
        // load the visible page
        // load the page on either side to avoid flashes when the user starts scrolling
        //
        self.procedureWidgetsArray = [[NSMutableArray alloc]init];
        
        [self translateProcedureXMLToiOSWidgets:self.domDocument];
//        
//        [self loadScrollViewWithPage:0];
//        [self loadScrollViewWithPage:1];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Procedure"];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                                     style:UIBarButtonSystemItemCancel target:nil action:@selector(cancelProcedure)];
    item.leftBarButtonItem = cancelButton;
    [self.navigationBar pushNavigationItem:item animated:NO];
}

- (void)loadScrollViewWithPage:(int)page {
    //if there's nothing to load
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
       
    // replace the placeholder if necessary
    UIViewController *controller = [viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null]) {
        
        GroupViewController *groupViewController = [self loadGroupViewController:page];
        [viewControllers replaceObjectAtIndex:page withObject:groupViewController];
    }
    // add the controller's view to the scroll view
//    if ([[viewControllers objectAtIndex:page] view ].superview == nil)
//    {
        NSLog(@"add controller view to scrollview");
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        NSLog(@"controller:%@",controller);
        [(UIViewController *)[viewControllers objectAtIndex:page] view].frame = frame;
        NSLog(@"viewControllers now:%@",viewControllers);
//    UIView *theView = [(NoteWriterProblemPickerViewController *)[viewControllers objectAtIndex:page] view];
    UIView *theView = [(UIViewController *)[viewControllers objectAtIndex:page] view];
        NSLog(@"the view is being added:%@",theView);
//        [scrollView addSubview:[[viewControllers objectAtIndex:page] view ]];
        [scrollView addSubview:theView];

//    }
//    CGRect scrollViewFrame = scrollView.frame;
//    //
//    scrollViewFrame.origin.x = scrollViewFrame.size.width * page;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    NSLog(@"view did scroll");
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    NSLog(@"scrollview contentOffset x:%f %f",scrollView.contentOffset.x, scrollView.frame.size.width);
    int currPage = floor(scrollView.contentOffset.x / pageWidth);
    
    //if you are at the last page, show the save button
    if (currPage+1 == kNumberOfPages) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                        style:UIBarButtonSystemItemSave target:nil action:@selector(saveNote)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                                         style:UIBarButtonSystemItemCancel target:nil action:@selector(cancelProcedure)];
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Procedure"];
        item.leftBarButtonItem = cancelButton;
        item.rightBarButtonItem = rightButton;
        item.hidesBackButton = YES;
        [self.navigationBar pushNavigationItem:item animated:NO];
    }
    else {
        NSLog(@"else reached");
        [self.navigationBar popNavigationItemAnimated:NO];

        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Procedure"];
        item.hidesBackButton = YES;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                        style:UIBarButtonSystemItemCancel target:nil action:@selector(cancelProcedure)];
        item.leftBarButtonItem = cancelButton;
        [self.navigationBar pushNavigationItem:item animated:NO];
    }

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

-(void)cancelProcedure {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)changePage:(id)sender
//{
//    int page = pageControl.currentPage;
//	
//    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
//    
//	// update the scroll view to the appropriate page
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    [scrollView scrollRectToVisible:frame animated:YES];
//    
//	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
//    pageControlUsed = YES;
//}

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

-(void)translateProcedureXMLToiOSWidgets:(GDataXMLDocument *) domDoc {

    NSArray *groupsArray = [self getGroups:domDoc];
    for (GDataXMLElement *group in groupsArray) {
        self.currentGroupWidgetsArray = nil;
        self.currentGroupWidgetsArray = [[NSMutableArray alloc]init];
        NSLog(@"group children:%@",group.children);
        for (GDataXMLElement *groupChild in group.children) {
            NSMutableDictionary *widgetPackage = [self createWidgetFromXML:groupChild];
            //if there is no widgetPackage then don't add it
            if (widgetPackage) {
                [self.currentGroupWidgetsArray addObject:widgetPackage];
                NSLog(@"curre group widgets:%@",currentGroupWidgetsArray);
            }
        }
        [self.procedureWidgetsArray addObject:self.currentGroupWidgetsArray];
    }
    NSLog(@"proc widgets array at the end of translateProcedure:%@",self.procedureWidgetsArray);

    [self runProcedure:0];
    
}

-(void) runProcedure:(NSInteger) startingGroupNumber {
    
        [self loadScrollViewWithPage:startingGroupNumber];
        [self loadScrollViewWithPage:startingGroupNumber + 1];
}

-(GroupViewController *) loadGroupViewController:(NSInteger) groupNumber {
    
    GroupViewController *groupViewController = [[GroupViewController alloc]initWithNibName:@"GroupViewController" bundle:nil];
    groupViewController.procedureRunnerViewController = self;
    NSMutableArray *groupWidgetsArray = [self.procedureWidgetsArray objectAtIndex:groupNumber];
    groupViewController.widgetsArray = groupWidgetsArray;
    NSLog(@"wid count:%d",[groupWidgetsArray count]);
    for (id widgetPackage in groupWidgetsArray) {
        NSLog(@"widgetpack:%@",widgetPackage);
        if ([[widgetPackage objectForKey:@"widgetObject"] isKindOfClass:[UIPickerView class]]){
            groupViewController.pickerDatasourceArray = [widgetPackage objectForKey:@"widgetDatasource"];
            NSLog(@"picker name:%@",groupViewController.pickerDatasourceArray);
        }
    }
    return groupViewController;
}

-(id) createWidgetFromXML:(GDataXMLElement *)element {
    
    id widgetPackage;
    if ([element.name isEqualToString:@"xforms:input"]) {
        widgetPackage = [self createInputField:element];
    }
    else if ([element.name isEqualToString:@"xforms:label"]){
        widgetPackage = [self createLabel:element];
    }
    else if ([element.name isEqualToString:@"xforms:textarea"]){
        widgetPackage = [self createTextArea:element];
    }
    else if ([element.name isEqualToString:@"xforms:select1"]){
        widgetPackage = [self createPicker:element];
    }
    else if ([element.name isEqualToString:@"xforms:select"]){
        widgetPackage = [self createCheckboxes:element];
    }
//    else if ([element.name isEqualToString:@"xforms:repeat"] && [[element attributeForName:@"id"].name isEqualToString:@"picturesList"]){
    else if ([element.name isEqualToString:@"xforms:repeat"]){
        widgetPackage = [self createMultimediaCaptureGUI:element];
        NSLog(@"widget Pckage inside create:%@",widgetPackage);
    }
    else {
        NSLog(@"%@ element is not going to be widgetified",element.name);
    }
    return widgetPackage;
}

-(void) showNextGroup {
    

}

-(NSArray *)getGroups:(GDataXMLDocument *) domDoc {
    NSError *error;
    NSArray *groupsArray = [domDoc nodesForXPath:@"//sana:group" error:&error];
    return groupsArray;
}

#pragma mark iOS Widget Creation Methods
/************************************************/
/* Converts:                                    */
/* <xforms:input ref="data/observation@1/value">*/
/* <xforms:label>Enter Text</xforms:label>      */
/* </xforms:input>                              */
/* Into:                                        */
/*    UILabel                                   */
/*    UITextField                               */
/************************************************/
-(NSMutableDictionary *)createInputField:(GDataXMLElement *) inputElement {
    
    UITextField *inputField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.frame.size.height)];
    inputField.backgroundColor = [UIColor whiteColor];

    //an <xforms:input> must have its first child as a <xforms:label>; not going to parse deeper than that
    if ([[[inputElement childAtIndex:0] name] isEqualToString:@"xforms:label"]) {
        NSMutableDictionary *labelWidgetPackage = [self createLabel:[[inputElement elementsForName:@"xforms:label"] objectAtIndex:0]];
        //add immediately b/c label goes on top of input box.
        [self.currentGroupWidgetsArray addObject:labelWidgetPackage];
    }
    
    NSMutableDictionary *inputWidgetPackage = [[NSMutableDictionary alloc]init];
    [inputWidgetPackage setObject:inputField forKey:@"widgetObject"];

    return inputWidgetPackage;
}

//xforms:textarea = UITextView
-(NSMutableDictionary *)createTextArea:(GDataXMLElement *) textAreaElement {

    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, 300)];
    textView.backgroundColor = [UIColor whiteColor];
  
    if ([[[textAreaElement childAtIndex:0] name] isEqualToString:@"xforms:label"]) {
        NSMutableDictionary *labelWidgetPackage = [self createLabel:[[textAreaElement elementsForName:@"xforms:label"] objectAtIndex:0]];
        [self.currentGroupWidgetsArray addObject:labelWidgetPackage];

    }
    
    NSMutableDictionary *textAreaWidgetPackage = [[NSMutableDictionary alloc]init];
    [textAreaWidgetPackage setObject:textView forKey:@"widgetObject"];
    
    return textAreaWidgetPackage;
}

//xforms:label = UILabel
-(NSMutableDictionary *)createLabel:(GDataXMLElement *)labelElement {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [labelElement stringValue];
    NSMutableDictionary *widgetPackage = [[NSMutableDictionary alloc]init];
    [widgetPackage setObject:label forKey:@"widgetObject"];
//    [widgetPackage setObject:nil forKey:@"widgetDatasource"];
    return widgetPackage;
}

//xforms:select1 = UIPickerView
-(NSMutableDictionary *)createPicker:(GDataXMLElement *) select1Element {
    
    UIPickerView *select1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    select1.showsSelectionIndicator = YES;
    
    if ([[[select1Element childAtIndex:0] name] isEqualToString:@"xforms:label"]) {
        NSMutableDictionary *labelWidgetPackage = [self createLabel:[[select1Element elementsForName:@"xforms:label"] objectAtIndex:0]];
        //add immediately b/c xforms:label goes on top of xforms:textarea in our UI.
        [self.currentGroupWidgetsArray addObject:labelWidgetPackage];
        
    }
    
    NSArray *itemsArray = [select1Element elementsForName:@"xforms:item"];
    NSMutableArray *pickerDatasourceArray = [[NSMutableArray alloc]init];
    for (GDataXMLElement *item in itemsArray) {
        GDataXMLElement *valueElement = [[item elementsForName:@"xforms:value"] objectAtIndex:0];
        [pickerDatasourceArray addObject:[valueElement stringValue]];
    }
    
    //gather all the <xforms:item> elements to generate the UIPickerView datasource  
    NSMutableDictionary *widgetPackage = [[NSMutableDictionary alloc]init];
    [widgetPackage setObject:select1 forKey:@"widgetObject"];
    [widgetPackage setObject:pickerDatasourceArray forKey:@"widgetDatasource"];
    
    return widgetPackage;
}

//xforms:select = A series of UISegmentedControls (which are the closest thing to checkboxes)
/*
        widgetPackage is { "widgetType": "checkboxes", 
                        "widgetObject"= [{"UILabel" = UILabel, "UISegmentedControl" = UISegmentedControl, "Value":"fever"},
                                         {"UILabel" = UILabel, "UISegmentedControl" = UISegmentedControl, "Value"="headache"}
                                        ]          
                         }
 */
-(NSMutableDictionary *)createCheckboxes:(GDataXMLElement *) selectElement {  
    
    if ([[[selectElement childAtIndex:0] name] isEqualToString:@"xforms:label"]) {
        NSMutableDictionary *labelWidgetPackage = [self createLabel:[[selectElement elementsForName:@"xforms:label"] objectAtIndex:0]];
        //add immediately b/c xforms:label goes on top of xforms:textarea in our UI.
        [self.currentGroupWidgetsArray addObject:labelWidgetPackage];
        
    }
    
    NSArray *itemsArray = [selectElement elementsForName:@"xforms:item"];
    NSMutableArray *checkBoxArray = [[NSMutableArray alloc]init];
    for (GDataXMLElement *item in itemsArray) {
        GDataXMLElement *valueElement = [[item elementsForName:@"xforms:value"] objectAtIndex:0];
            
        NSMutableDictionary *segmentedControlDictionary = [[NSMutableDictionary alloc]init];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = UITextAlignmentLeft;
        label.text = [valueElement stringValue];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"yes",@"no", nil]];
        [segmentedControlDictionary setObject:label forKey:@"UILabel"];
        [segmentedControlDictionary setObject:segmentedControl forKey:@"UISegmentedControl"];
        [segmentedControlDictionary setObject:label.text forKey:@"Value"];
        [checkBoxArray addObject:segmentedControlDictionary];
    }
    
    //gather all the <xforms:item> elements to generate the UILabel and UISegmentedControls   
    NSMutableDictionary *widgetPackage = [[NSMutableDictionary alloc]init];
    [widgetPackage setObject:checkBoxArray forKey:@"widgetObject"];
    [widgetPackage setObject:@"checkboxes" forKey:@"widgetType"];
    
    return widgetPackage;
}

/*
 widgetPackage is {"widgetType" = "multimediaGUI","widgetObject"= [UIButton, UIButton,UIButton]}
*/
-(NSMutableDictionary *)createMultimediaCaptureGUI:(GDataXMLElement *) inputElement {

    UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width/3, self.scrollView.frame.size.height)];
    addPictureButton.backgroundColor = [UIColor clearColor];    
    [addPictureButton setTitle:@" Add Picture" forState:UIControlStateNormal];
    [addPictureButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [addPictureButton setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
    
    UIButton *addVideoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width/3, self.scrollView.frame.size.height)];
    addVideoButton.backgroundColor = [UIColor clearColor];    
    [addVideoButton setTitle:@" Add Video" forState:UIControlStateNormal];
    [addVideoButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [addVideoButton setImage:[UIImage imageNamed:@"movie.png"] forState:UIControlStateNormal];
    
    UIButton *addAudioButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width/3, self.scrollView.frame.size.height)];
    addAudioButton.backgroundColor = [UIColor clearColor];    
    [addAudioButton setTitle:@" Add Audio" forState:UIControlStateNormal];
    [addAudioButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [addAudioButton setImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateNormal];
    
    NSMutableArray *mmButtonsArray = [[NSMutableArray alloc]init];
    [mmButtonsArray addObject:addPictureButton];
    [mmButtonsArray addObject:addVideoButton];
    [mmButtonsArray addObject:addAudioButton];
    
    NSMutableDictionary *widgetPackage = [[NSMutableDictionary alloc]init];
    [widgetPackage setObject:@"multimediaGUI" forKey:@"widgetType"];
    [widgetPackage setObject:mmButtonsArray forKey:@"widgetObject"];
    
    return widgetPackage;
}

-(void) collectResponses {
    
}

@end
