//
//  ProjectDashBoardViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CircleProgressBar.h"
#import "Sqlite.h"
#import "MLKMenuPopover.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f
#define MENU_POPOVER_FRAME  CGRectMake(25, 250, 140, 88)

@class CircleProgressBar;

@interface ProjectDashBoardViewController : UIViewController<MLKMenuPopoverDelegate, UITableViewDelegate, UITableViewDataSource>
{
    MFMailComposeViewController *mailComposer;
    NSMutableArray *arr_requirements;
    NSMutableArray *arr_tasks;
    Sqlite *database;
    float completed_req;
    float completed_task;
}
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (strong, nonatomic)IBOutlet UILabel *lbl_projectName;
@property (strong, nonatomic)IBOutlet UIButton *btn_addRequirement;
@property (strong, nonatomic)IBOutlet UIButton *btn_addTasks;
@property (strong, nonatomic)IBOutlet UIButton *btn_message;
@property (strong, nonatomic)IBOutlet UILabel *lbl;
@property (strong, nonatomic)IBOutlet UITableView *tbl_view;
@property (strong, nonatomic)IBOutlet UIButton *btn_req;


@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@property(nonatomic,strong) NSMutableArray *menuItems;
@property (strong, nonatomic)NSString *str_projectName;


-(IBAction)backbtnPressed:(id)sender;
-(IBAction)sendEmailTL:(id)sender;
-(IBAction)addRequirement:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)addTask:(id)sender;
-(IBAction)openCompleted_req_task:(id)sender;

@end
