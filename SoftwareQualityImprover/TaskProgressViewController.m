//
//  TaskProgressViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/6/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "TaskProgressViewController.h"

@interface TaskProgressViewController ()

@end

@implementation TaskProgressViewController
@synthesize str_projectName, arr_selectedTasks;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lbl_projectName.text = str_projectName;
    arr_selectedTasks = [[NSMutableArray alloc]init];
    arr_compTasks = [[NSMutableArray alloc]init];
    arr_TotalTasks = [[NSMutableArray alloc]init];
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString *emp_email = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
    
    [self databaseOpen];
    NSString *query_task =[ NSString stringWithFormat:@"SELECT task FROM tbl_selected_tasks WHERE project_name = '%@' AND completed='NO' AND emp_email='%@'",self.lbl_projectName.text, emp_email];
    
    NSMutableArray *arr_result =[[NSMutableArray alloc]init];
    arr_result =[[database executeQuery:query_task]mutableCopy];
    arr_selectedTasks = [[arr_result valueForKey:@"task"]mutableCopy];
    
    
    
    
    NSString *query_totaltask =[ NSString stringWithFormat:@"SELECT task FROM tbl_selected_tasks WHERE project_name = '%@' AND emp_email='%@'",self.lbl_projectName.text, emp_email];
    
    NSMutableArray *arr_result2 =[[NSMutableArray alloc]init];
    arr_result2 =[[database executeQuery:query_totaltask]mutableCopy];
    arr_TotalTasks = [[arr_result2 valueForKey:@"task"]mutableCopy];
    int b = arr_TotalTasks.count;
    float total_tasks = (float)b;
    
    
    
    NSString *query_comptask =[ NSString stringWithFormat:@"SELECT task FROM tbl_selected_tasks WHERE project_name = '%@' AND completed='YES' AND emp_email='%@'",self.lbl_projectName.text, emp_email];
    
    NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
    arr_result1 =[[database executeQuery:query_comptask]mutableCopy];
    
    arr_compTasks = [[arr_result1 valueForKey:@"task"]mutableCopy];
    int a = arr_compTasks.count;
    float compTasks = (float)a;
    
    
    [database close];
    
    
    [self.tbl_tasks reloadData];
    [_circleProgressBar setProgress:(compTasks/total_tasks) animated:YES];
    
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

#pragma mark - Pick New Tasks
-(IBAction)pickNewTasks:(id)sender
{
    [self performSegueWithIdentifier:@"pickNewTask" sender:nil];
    
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_selectedTasks count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    cell.textLabel.minimumScaleFactor = FONT_SIZE;
    [cell.textLabel setNumberOfLines:0];
    
    NSString *text = [arr_selectedTasks objectAtIndex:indexPath.row];
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Complete!" description:@"Do you want to mark this task as complete?" okButtonTitle:@"Mark Complete" cancelButtonTitle:@"Cancel"];
    alertView.delegate = self;
    [alertView show];
    selectedIndex = indexPath.row;
    
    
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [arr_selectedTasks objectAtIndex:indexPath.row];
    
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
#pragma mark - MODropAlertView
- (void)alertViewDidDisappear:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(buttonType == DropAlertButtonOK)
    {
        [self databaseOpen];
        NSString *query_task =[ NSString stringWithFormat:@"UPDATE tbl_selected_tasks SET completed = 'YES' WHERE task = '%@'", [arr_selectedTasks objectAtIndex:selectedIndex]];
        
        [database executeNonQuery:query_task];
        
        NSString *query_task1 =[ NSString stringWithFormat:@"UPDATE tbl_tasks SET completed = 'YES' WHERE task = '%@'", [arr_selectedTasks objectAtIndex:selectedIndex]];
        
        [database executeNonQuery:query_task1];
        
        [arr_selectedTasks removeObjectAtIndex:selectedIndex];
        
        int b = arr_TotalTasks.count;
        float total_tasks = (float)b;
        
        
        NSString *emp_email = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
        NSString *query_comptask =[ NSString stringWithFormat:@"SELECT task FROM tbl_selected_tasks WHERE project_name = '%@' AND completed='YES' AND emp_email='%@'",self.lbl_projectName.text, emp_email];
        
        NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
        arr_result1 =[[database executeQuery:query_comptask]mutableCopy];
        
        arr_compTasks = [[arr_result1 valueForKey:@"task"]mutableCopy];
        int a = arr_compTasks.count;
        float compTasks = (float)a;
        
        [_circleProgressBar setProgress:(compTasks/total_tasks) animated:YES];
        [self.tbl_tasks reloadData];
        [database close];
        
        
    }
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

#pragma mark - Completed Pressed
-(IBAction)completedPressed:(id)sender
{
    [self performSegueWithIdentifier:@"openCompletedTask" sender:nil];
}

#pragma mark - Create Chart
-(IBAction)createChart:(id)sender
{
    [self performSegueWithIdentifier:@"chartInput" sender:nil];
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
