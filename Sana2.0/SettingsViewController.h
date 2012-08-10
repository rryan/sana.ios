//
//  SettingsViewController.h
//  Sana
//
//  Created by Richard on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	NSDictionary *settingsData;
	NSArray *settingSections;
}

@property (nonatomic, strong) NSDictionary *settingsData;
@property (weak, nonatomic) NSArray *settingsSections;

@end
