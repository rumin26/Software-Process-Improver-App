//
//  TeamMembersViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "TeamMembersViewController.h"

@interface TeamMembersViewController ()

@end

@implementation TeamMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr_teamMembersName = [[NSMutableArray alloc]init];
    arr_memberType = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self databaseOpen];
    
    NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    
    NSString *query=[ NSString stringWithFormat:@"SELECT member_email, member_name, member_type  FROM tbl_team WHERE project_name='%@' AND member_type <>'Project Manager'",projectName];
    
    NSMutableArray *arr =[[NSMutableArray alloc]init];
    arr =[[database executeQuery:query]mutableCopy];
    arr_teamMembersName = [[arr valueForKey:@"member_name"]mutableCopy];
    arr_memberType = [[arr valueForKey:@"member_type"]mutableCopy];
    
    [database close];

    [self.tbl_team reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_teamMembersName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [arr_teamMembersName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [arr_memberType objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    //tableView.allowsMultipleSelection = YES;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //str_projectName = [arr_projects objectAtIndex:indexPath.row];
    
//    
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"] || [[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
//    {
//        [self performSegueWithIdentifier:@"openTeam" sender:self];
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"openTaskList" sender:self];
//    }
    
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

#pragma mark - Sign Out
-(IBAction)signOutPressed:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark- Back Button

-(IBAction)backbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Pick Team Members

-(IBAction)pickTeamMembers:(id)sender
{
    [self performSegueWithIdentifier:@"allMembers" sender:nil];
}

#pragma mark - Dashboard
-(IBAction)dashboardPressed:(id)sender
{
    [self performSegueWithIdentifier:@"openDash" sender:nil];
    
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
