//
//  TaskProgressViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/6/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressBar.h"
#import "Sqlite.h"
#import "MODropAlertView.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f


@class CircleProgressBar;

@interface TaskProgressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MODropAlertViewDelegate>
{
    Sqlite *database;
    NSInteger selectedIndex;
    NSMutableArray *arr_compTasks;
    NSMutableArray *arr_TotalTasks;
    
    
    
}
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (strong, nonatomic)IBOutlet UILabel *lbl_projectName;
@property (strong, nonatomic)IBOutlet UITableView *tbl_tasks;


@property (strong, nonatomic)NSString *str_projectName;
@property (strong, nonatomic)NSMutableArray *arr_selectedTasks;

-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)pickNewTasks:(id)sender;
-(IBAction)completedPressed:(id)sender;

@end
