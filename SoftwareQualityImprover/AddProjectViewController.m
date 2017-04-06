//
//  AddProjectViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "AddProjectViewController.h"
#import "ProjectDashBoardViewController.h"

@interface AddProjectViewController ()

@end

@implementation AddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr_projects = [[NSMutableArray alloc]initWithObjects:@"Food Truth App", nil];
    
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
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    str_projectName = [arr_projects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"openProject" sender:self];
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProjectDashBoardViewController *projectDashVC = [segue destinationViewController];
    projectDashVC.str_projectName = str_projectName;
    
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
