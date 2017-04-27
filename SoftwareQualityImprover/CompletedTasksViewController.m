//
//  CompletedTasksViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/25/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "CompletedTasksViewController.h"

@interface CompletedTasksViewController ()

@end

@implementation CompletedTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str_projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    NSString *emp_email = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"])
    {
        
        [self databaseOpen];
        NSString *query_task =[ NSString stringWithFormat:@"SELECT task FROM tbl_tasks WHERE completed = 'YES' AND project_name='%@'",str_projectName];
        
        NSMutableArray *arr_result =[[NSMutableArray alloc]init];
        arr_result =[[database executeQuery:query_task]mutableCopy];
        arr_completedTasks = [[arr_result valueForKey:@"task"]mutableCopy];
        [database close];
    }
    else
    {
        [self databaseOpen];
        NSString *query_task =[ NSString stringWithFormat:@"SELECT task FROM tbl_selected_tasks WHERE completed = 'YES' AND project_name='%@' AND emp_email='%@'",str_projectName,emp_email];
        
        NSMutableArray *arr_result =[[NSMutableArray alloc]init];
        arr_result =[[database executeQuery:query_task]mutableCopy];
        arr_completedTasks = [[arr_result valueForKey:@"task"]mutableCopy];
        [database close];
    }
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
    return [arr_completedTasks count];
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
    NSString *text =[ arr_completedTasks objectAtIndex:indexPath.row];
    
    
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
    
    //cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [arr_completedTasks objectAtIndex:indexPath.row];
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"InComplete!" description:@"Do you want to mark this requirement as incomplete?" okButtonTitle:@"InComplete" cancelButtonTitle:@"Cancel"];
    alertView.delegate = self;
    [alertView show];
    selectedIndex = indexPath.row;
    
    
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

#pragma mark - MODropAlertView
- (void)alertViewDidDisappear:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(buttonType == DropAlertButtonOK)
    {
        [self databaseOpen];
        NSString *query_task =[ NSString stringWithFormat:@"UPDATE tbl_selected_tasks SET completed = 'NO' WHERE task = '%@'", [arr_completedTasks objectAtIndex:selectedIndex]];
        
        [database executeNonQuery:query_task];
        
        NSString *query_task1 =[ NSString stringWithFormat:@"UPDATE tbl_tasks SET completed = 'NO', selected='NO' WHERE task = '%@'", [arr_completedTasks objectAtIndex:selectedIndex]];
        
        [database executeNonQuery:query_task1];
        
        [arr_completedTasks removeObjectAtIndex:selectedIndex];
        [self.tbl_compTasks reloadData];
        
    }
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
