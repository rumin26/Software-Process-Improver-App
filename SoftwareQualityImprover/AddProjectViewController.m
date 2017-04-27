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
    arr_projects = [[NSMutableArray alloc]init];
    NSString *emp_email = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
    [self databaseOpen];
    
    // Do any additional setup after loading the view.
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"] || [[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Developer/ Tester"])
    {
        self.btn_addProject.hidden = YES;
    }
    else
    {
        
        
        NSString *query=[ NSString stringWithFormat:@"SELECT emp_name FROM tbl_employee WHERE emp_email = '%@' AND emp_type='Project Manager'",emp_email];
        
        
        NSMutableArray *arr =[[NSMutableArray alloc]init];
        arr =[[database executeQuery:query]mutableCopy];
        NSArray *arr_emp = [arr valueForKey:@"emp_name"];
        str_projectManager = [arr_emp objectAtIndex:0];
    }
    
    
    NSString *query_project =[ NSString stringWithFormat:@"SELECT project_name FROM tbl_team WHERE member_email = '%@'",emp_email];
    
    
    NSMutableArray *arr_result =[[NSMutableArray alloc]init];
    arr_result =[[database executeQuery:query_project]mutableCopy];
    arr_projects = [[arr_result valueForKey:@"project_name"]mutableCopy];
    [database close];
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
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //tableView.allowsMultipleSelection = YES;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    str_projectName = [arr_projects objectAtIndex:indexPath.row];
    
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:str_projectName forKey:@"selected_project"];
        [self performSegueWithIdentifier:@"openTeam" sender:nil];
    }
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"])
    {
        [self performSegueWithIdentifier:@"openRequirement" sender:nil];
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
- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
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
        
    }
}

#pragma mark - Add Project
-(IBAction)addProjectbtnPressed:(id)sender
{
    [self databaseOpen];
    Popup *popup = [[Popup alloc] initWithTitle:@"Add Project"
                                       subTitle:@"Enter Project Name"
                          textFieldPlaceholders:@[@"Project Name"]
                                    cancelTitle:@"Cancel"
                                   successTitle:@"Add"
                                    cancelBlock:^{
                                        //Custom code after cancel button was pressed
                                    } successBlock:^{
                                        //Custom code after success button was pressed
                                    
                                        NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"projectName"];
                                        NSString *emp_email = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
                                        
                                        NSString *query_user=[NSString stringWithFormat:@"Insert into tbl_projects(project_name, project_manager) values('%@','%@')",projectName,str_projectManager];
                                        
                                        [database executeNonQuery:query_user];
                                        
                                        NSString *query_manager=[NSString stringWithFormat:@"Insert into tbl_team(project_name, member_name, member_email, member_type) values('%@','%@','%@','Project Manager')",projectName,str_projectManager, emp_email];
                                        
                                        [database executeNonQuery:query_manager];
                                        
                                        NSString *query_project =[ NSString stringWithFormat:@"SELECT project_name FROM tbl_projects WHERE project_manager = '%@'",str_projectManager];
                                        
                                        
                                        NSMutableArray *arr_result =[[NSMutableArray alloc]init];
                                        arr_result =[[database executeQuery:query_project]mutableCopy];
                                        arr_projects = [arr_result valueForKey:@"project_name"];
                                        
                                        [database close];
                                        
                                        
                                        
                                        [self.tbl_projects reloadData];
                                        
                                    }];
    [popup setDelegate:self];
    [popup showPopup];
}

#pragma mark - Sign Out
-(IBAction)signOutPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Database Method

-(void)databaseOpen

{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *myDBnew=[documentsDirectory stringByAppendingPathComponent:@"db_softwareProcess.sqlite"];
    
    database =[[Sqlite alloc]init];
    [database open:myDBnew];
    NSLog(@"path: %@", myDBnew);
    
    NSLog(@"Database opened");
    
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
