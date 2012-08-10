//
//  GroupViewControllerViewController.h
//  Sana2.0
//
//  Created by Richard Lu on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcedureRunnerViewController.h"
#import "MultimediaViewController.h"

@interface GroupViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate> {
    
    UITableView *theTableView;
    UIToolbar *toolBar;
    UIBarButtonItem *previousButton;
    UIBarButtonItem *nextButton;
    NSMutableArray *widgetsArray;//each widget in the group
    NSMutableArray *pickerDatasourceArray;
    ProcedureRunnerViewController *procedureRunnerViewController;
    MultimediaViewController *multimediaViewController;
}

@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) NSMutableArray *widgetsArray;
@property (strong, nonatomic) NSMutableArray *pickerDatasourceArray;
@property (strong, nonatomic) ProcedureRunnerViewController *procedureRunnerViewController;
@property (strong, nonatomic) MultimediaViewController *multimediaViewController;

-(IBAction)previousButtonClicked:(id)sender;
-(IBAction)nextButtonClicked:(id)sender;
@end
