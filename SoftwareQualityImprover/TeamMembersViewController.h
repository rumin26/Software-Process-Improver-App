//
//  TeamMembersViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"

@interface TeamMembersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arr_teamMembersName;
    NSMutableArray *arr_memberType;
    
    Sqlite *database;
    
}

@property(strong, nonatomic)IBOutlet UITableView *tbl_team;


-(IBAction)pickTeamMembers:(id)sender;
-(IBAction)dashboardPressed:(id)sender;
-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;

@end
