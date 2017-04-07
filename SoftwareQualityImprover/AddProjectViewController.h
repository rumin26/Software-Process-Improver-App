//
//  AddProjectViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddProjectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arr_projects;
    NSString *str_projectName;
}

@property(strong,nonatomic)IBOutlet UIButton *btn_addProject;


-(IBAction)signOutPressed:(id)sender;

@end
