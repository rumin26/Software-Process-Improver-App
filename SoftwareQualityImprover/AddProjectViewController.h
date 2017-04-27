//
//  AddProjectViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"
#import "Popup.h"

@interface AddProjectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, PopupDelegate>
{
    NSMutableArray *arr_projects;
    NSString *str_projectName;
    NSString *str_projectManager;
    
    Sqlite *database;
}

@property(strong,nonatomic)IBOutlet UIButton *btn_addProject;
@property(strong, nonatomic)IBOutlet UITableView *tbl_projects;


-(IBAction)signOutPressed:(id)sender;
-(IBAction)addProjectbtnPressed:(id)sender;

@end
