//
//  AllMembersViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "AllMembersViewController.h"

@interface AllMembersViewController ()

@end

@implementation AllMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr_membersName = [[NSMutableArray alloc]init];
    arr_memberType = [[NSMutableArray alloc]init];
    
    arr_selectedMembers = [[NSMutableArray alloc]init];
    arr_selectedMemberEmail = [[NSMutableArray alloc]init];
    arr_selectedMembersType = [[NSMutableArray alloc]init];
    
    [self databaseOpen];
    
    NSString *query=[ NSString stringWithFormat:@"SELECT emp_email, emp_name, emp_type  FROM tbl_employee WHERE emp_type <>'Project Manager'"];
    
    NSMutableArray *arr =[[NSMutableArray alloc]init];
    arr =[[database executeQuery:query]mutableCopy];
    
    arr_membersName = [[arr valueForKey:@"emp_name"]mutableCopy];
    arr_memberType = [[arr valueForKey:@"emp_type"]mutableCopy];
    arr_memberEmail = [[arr valueForKey:@"emp_email"]mutableCopy];
    
    [database close];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_membersName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [arr_membersName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [arr_memberType objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    
    //tableView.allowsMultipleSelection = YES;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone)
    {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [arr_selectedMembers addObject:[arr_membersName objectAtIndex:indexPath.row]];
        [arr_selectedMembersType addObject:[arr_memberType objectAtIndex:indexPath.row]];
        [arr_selectedMemberEmail addObject:[arr_memberEmail objectAtIndex:indexPath.row]];
    }
    else
    {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        [arr_selectedMembers removeObject:[arr_membersName objectAtIndex:indexPath.row]];
        [arr_selectedMembersType removeObject:[arr_memberType objectAtIndex:indexPath.row]];
        [arr_selectedMemberEmail addObject:[arr_memberEmail objectAtIndex:indexPath.row]];
    }
    
    NSLog(@"selected Tasks:%@", arr_selectedMembers);
    
    if(arr_selectedMembers.count>0)
    {
        [self.btn_continue setEnabled:YES];
    }
    
    else
    {
        [self.btn_continue setEnabled:NO];
    }

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

#pragma mark - Continue Pressed
-(IBAction)continuePressed:(id)sender
{
    NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    [self databaseOpen];
    
    for(int i = 0; i< [arr_selectedMembers count]; i++)
    {
        NSString *query_user=[NSString stringWithFormat:@"Insert into tbl_team(project_name, member_name, member_email, member_type) values('%@','%@','%@','%@')",projectName, arr_selectedMembers[i], arr_selectedMemberEmail[i], arr_selectedMembersType[i]];
    
        [database executeNonQuery:query_user];
    }
    [database close];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
