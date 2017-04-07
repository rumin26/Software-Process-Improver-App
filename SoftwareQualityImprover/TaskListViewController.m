//
//  TaskListViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/6/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskProgressViewController.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController
@synthesize str_projectName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lbl_projectName.text = self.str_projectName;
    arr_tasks = [[NSMutableArray alloc]initWithObjects:@"Food Truth App", @"Convert Units", nil];
    arr_selectedTasks = [[NSMutableArray alloc]init];
    [self.btn_continue setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_tasks count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [arr_tasks objectAtIndex:indexPath.row];
    //tableView.allowsMultipleSelection = YES;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    str_taskName = [arr_tasks objectAtIndex:indexPath.row];
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone)
    {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [arr_selectedTasks addObject:[arr_tasks objectAtIndex:indexPath.row]];
    }
    else
    {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        [arr_selectedTasks removeObject:[arr_tasks objectAtIndex:indexPath.row]];
            
    }
    
    NSLog(@"selected Tasks:%@", arr_selectedTasks);
    
    if(arr_selectedTasks.count>0)
    {
        [self.btn_continue setEnabled:YES];
    }
    
    else
    {
        [self.btn_continue setEnabled:NO];
    }
}

#pragma mark - Continue
-(IBAction)continuePressed:(id)sender
{
    [self performSegueWithIdentifier:@"openTaskProgress" sender:self];
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        TaskProgressViewController *taskVC = [segue destinationViewController];
        taskVC.str_projectName = str_projectName;
    
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
