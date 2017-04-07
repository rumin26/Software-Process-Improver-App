//
//  AddProjectViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "AddProjectViewController.h"
#import "ProjectDashBoardViewController.h"
#import "TaskListViewController.h"

@interface AddProjectViewController ()

@end

@implementation AddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"] || [[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Developer/ Tester"])
    {
        self.btn_addProject.hidden = YES;
    }
    else
    {
        
    }
    arr_projects = [[NSMutableArray alloc]initWithObjects:@"Food Truth App", @"Convert Units", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_projects count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [arr_projects objectAtIndex:indexPath.row];
    //tableView.allowsMultipleSelection = YES;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    str_projectName = [arr_projects objectAtIndex:indexPath.row];
    
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"] || [[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
    {
        [self performSegueWithIdentifier:@"openProject" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"openTaskList" sender:self];
    }
    
//    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
//    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
//        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
//        
//    }else{
//        thisCell.accessoryType = UITableViewCellAccessoryNone;
//        
//    }
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"openTaskList"])
    {
        TaskListViewController *taskVC = [segue destinationViewController];
        taskVC.str_projectName = str_projectName;
    }
    else
    {
        ProjectDashBoardViewController *projectDashVC = [segue destinationViewController];
        projectDashVC.str_projectName = str_projectName;
    }
}

#pragma mark - Sign Out
-(IBAction)signOutPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
