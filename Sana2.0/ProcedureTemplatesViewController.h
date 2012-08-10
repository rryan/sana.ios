//
//  AvailableProceduresTableViewController.h
//  Sana
//
//  Created by Richard on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSServices.h"

@interface ProcedureTemplatesViewController : UITableViewController <SDSServicesDelegate> {

    SDSServices *sdsServices;
    NSMutableArray *procedureNamesArray;
}

@property (nonatomic, strong) SDSServices *sdsServices;
@property (nonatomic, strong) NSMutableArray *procedureNamesArray;

@end
