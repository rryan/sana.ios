//
//  ProcedureRunnerViewController.h
//  Mojo
//
//  Created by Richard Lu on 08/01/2012.
//  Copyright (c) 2012 Sana, MIT, CSAIL, All rights reserved.
//  Open Source GPL License 

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
@class GroupViewController;


@interface ProcedureRunnerViewController : UIViewController <UIScrollViewDelegate> {
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UINavigationBar *navigationBar;
    NSMutableArray *viewControllers;//your data source, typically each section
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    NSMutableDictionary *dataDictionary;//the concept that was picked by the user  
    
    GroupViewController *groupVC;
    GDataXMLDocument *domDocument;
    GDataXMLNode *currentElement;
    
    NSMutableArray *procedureWidgetsArray;//"master array of all iOS widgets translated from 
    //Procedure's XML, organized at group level. 
    //[[UITextField, UITextView] ,    [UITextField, UIPickerView, UITextView]]
    //-----group 1's widgets -----           -----group 2's widgets -----
    NSMutableArray *currentGroupWidgetsArray;//"master array of all iOS widgets translated from 


}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

@property (nonatomic, strong) GroupViewController *groupVC;
@property (nonatomic, strong) GDataXMLDocument *domDocument;
@property (nonatomic, strong) GDataXMLNode *currentElement;

@property (nonatomic, strong) NSMutableArray *procedureWidgetsArray;
@property (nonatomic, strong) NSMutableArray *currentGroupWidgetsArray;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDomDocument:(GDataXMLDocument *) domDoc;
- (void)loadScrollViewWithPage:(int)page;

-(void)translateProcedureXMLToiOSWidgets:(GDataXMLDocument *) domDoc;
-(void) collectResponses;

@end




