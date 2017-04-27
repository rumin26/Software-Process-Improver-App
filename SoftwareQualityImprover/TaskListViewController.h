//
//  TaskListViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/6/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface TaskListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *arr_tasks;
    NSMutableArray *arr_selectedTasks;
    NSString *str_taskName;
    
    Sqlite *database;
    
}
@property (strong, nonatomic)IBOutlet UILabel *lbl_projectName;
@property (strong, nonatomic)IBOutlet UIButton *btn_continue;
@property(strong, nonatomic)IBOutlet UITableView *tbl_tasks;


@property (strong, nonatomic)NSString *str_projectName;

-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)continuePressed:(id)sender;


@end
