//
//  AllMembersViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQlite/Sqlite.h"

@interface AllMembersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arr_membersName;
    NSMutableArray *arr_memberType;
    NSMutableArray *arr_memberEmail;
    
    NSMutableArray *arr_selectedMembers;
    NSMutableArray *arr_selectedMembersType;
    NSMutableArray *arr_selectedMemberEmail;
    
    Sqlite *database;
    
}

@property (strong, nonatomic)IBOutlet UIButton *btn_continue;

-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)continuePressed:(id)sender;

@end
