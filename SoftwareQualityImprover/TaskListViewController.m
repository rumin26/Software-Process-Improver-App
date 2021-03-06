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
    self.lbl_projectName.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    arr_tasks = [[NSMutableArray alloc]init];
    arr_selectedTasks = [[NSMutableArray alloc]init];
    
    [self databaseOpen];
    NSString *query_task =[ NSString stringWithFormat:@"SELECT task FROM tbl_tasks WHERE project_name = '%@' AND completed='NO' AND selected='NO'",self.lbl_projectName.text];
    
    NSMutableArray *arr_result =[[NSMutableArray alloc]init];
    arr_result =[[database executeQuery:query_task]mutableCopy];
    arr_tasks = [[arr_result valueForKey:@"task"]mutableCopy];
    
    [database close];
    
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
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    cell.textLabel.minimumScaleFactor = FONT_SIZE;
    [cell.textLabel setNumberOfLines:0];
    
    NSString *text = [arr_tasks objectAtIndex:indexPath.row];
        
        
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    CGSize size = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (size.width > cell.textLabel.bounds.size.width)
    {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        [cell.textLabel setText:text];
        [cell.textLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, self.view.frame.size.width -(CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    }
    
    else
    {
        cell.textLabel.frame = CGRectMake(10, 0, self.view.frame.size.width - 18,18);
        [cell.textLabel setText:text];
    }

    
    return cell;
}
- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
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
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [arr_tasks objectAtIndex:indexPath.row];
   
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize labelsize = [cellText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGFloat height = MAX(labelsize.height, 45.0f);
    
    if(height == 45.0f)
    {
        return 50;
    }
    
    else
    {
        return height +5;
    }
    
    
}


#pragma mark - Continue
-(IBAction)continuePressed:(id)sender
{
    [self databaseOpen];
    NSString *emp_email = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
    
    NSString *query=[ NSString stringWithFormat:@"SELECT member_name  FROM tbl_team WHERE member_email = '%@'",emp_email];
    
    
    NSMutableArray *arr =[[NSMutableArray alloc]init];
    arr =[[database executeQuery:query]mutableCopy];
    NSMutableArray *arr_emp_name = [arr valueForKey:@"member_name"];
    
    NSString *str_emp_name = [arr_emp_name objectAtIndex:0];
    
    for(int i = 0; i< arr_selectedTasks.count;i++)
    {
        NSString *query_user=[NSString stringWithFormat:@"Insert into tbl_selected_tasks(project_name, task, emp_email, emp_name,completed) values('%@','%@','%@','%@','NO')",self.lbl_projectName.text,arr_selectedTasks[i],emp_email, str_emp_name];
    
        [database executeNonQuery:query_user];
        
        
        NSString *query_requirement =[ NSString stringWithFormat:@"UPDATE tbl_tasks SET selected = 'YES' WHERE task = '%@'", arr_selectedTasks[i]];
        
        [database executeNonQuery:query_requirement];
        //[arr_selectedTasks removeObjectAtIndex:i];
        //[self.tbl_tasks reloadData];
    }
    
    [self performSegueWithIdentifier:@"openTaskProgress" sender:self];
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    TaskProgressViewController *taskVC = [segue destinationViewController];
    taskVC.str_projectName = str_projectName;
    taskVC.arr_selectedTasks = arr_selectedTasks;
    
    
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
