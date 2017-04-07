//
//  TaskListViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/6/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *arr_tasks;
    NSMutableArray *arr_selectedTasks;
    NSString *str_taskName;
    
}
@property (strong, nonatomic)IBOutlet UILabel *lbl_projectName;
@property (strong, nonatomic)IBOutlet UIButton *btn_continue;


@property (strong, nonatomic)NSString *str_projectName;

-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)continuePressed:(id)sender;


@end
