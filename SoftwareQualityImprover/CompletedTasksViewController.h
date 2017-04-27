//
//  CompletedTasksViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite.h"
#import "MODropAlertView.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface CompletedTasksViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MODropAlertViewDelegate>
{
    NSMutableArray *arr_completedTasks;
    Sqlite *database;
    NSInteger selectedIndex;
}
@property(strong,nonatomic)IBOutlet UITableView *tbl_compTasks;

@end
