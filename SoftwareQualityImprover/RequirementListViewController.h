//
//  RequirementListViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"
#import "MODropAlertView.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface RequirementListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MODropAlertViewDelegate>
{
    NSMutableArray *arr_requirements;
    Sqlite *database;
    NSInteger selectedIndex;
    
    
}

@property(strong,nonatomic)IBOutlet UITableView *tbl_requirements;

-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)goToTasks:(id)sender;
-(IBAction)completedRequirementPressed:(id)sender;

@end
