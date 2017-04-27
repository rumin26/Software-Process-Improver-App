//
//  ProjectDashBoardViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "ProjectDashBoardViewController.h"
#import "CAPostEditorViewController.h"

@interface ProjectDashBoardViewController ()

@end

@implementation ProjectDashBoardViewController
@synthesize str_projectName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lbl_projectName.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    //[self.lbl_projectName sizeToFit];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"])
    {
        self.btn_addRequirement.hidden = YES;
        self.lbl.text = @"Task List";
        [self.btn_message setTitle:@"Message" forState:UIControlStateNormal];
        [self.btn_req setTitle:@"Completed Tasks >" forState:UIControlStateNormal];
        [self. btn_message sizeToFit];
        arr_tasks = [[NSMutableArray alloc]init];
    }
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
    {
        self.btn_addTasks.hidden = YES;
        self.lbl.text = @"Requirement List";
        arr_requirements = [[NSMutableArray alloc]init];

    }
    else
    {
        self.btn_addTasks.hidden = YES;
        self.btn_addRequirement.hidden = YES;
        self.btn_req.hidden = YES;
        self.lbl.text = @"Task List";
    }
    
    self.lbl.textAlignment = NSTextAlignmentCenter;
    
    self.menuItems = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
    {
        [self databaseOpen];
        NSString *query_requirement =[ NSString stringWithFormat:@"SELECT requirement FROM tbl_requirement WHERE project_name = '%@'",self.lbl_projectName.text];
    
        NSMutableArray *arr_result =[[NSMutableArray alloc]init];
        arr_result =[[database executeQuery:query_requirement]mutableCopy];
        arr_requirements = [[arr_result valueForKey:@"requirement"]mutableCopy];
        int requirement_count = arr_requirements.count;
        float a = (float)requirement_count;
        
        NSString *query_completed_requirement =[ NSString stringWithFormat:@"SELECT requirement FROM tbl_requirement WHERE project_name = '%@' AND completed = 'YES'",self.lbl_projectName.text];
        
        NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
        arr_result1 =[[database executeQuery:query_completed_requirement]mutableCopy];
        
        int completed_requirement_count = arr_result1.count;
        completed_req = (float)completed_requirement_count;
        
        [_circleProgressBar setProgress:(completed_req/a) animated:YES];
        [database close];
    }
    else
    {
        [self databaseOpen];
        NSString *query_task =[ NSString stringWithFormat:@"SELECT task FROM tbl_tasks WHERE project_name = '%@'",self.lbl_projectName.text];
        
        NSMutableArray *arr_result =[[NSMutableArray alloc]init];
        arr_result =[[database executeQuery:query_task]mutableCopy];
        arr_tasks = [[arr_result valueForKey:@"task"]mutableCopy];
        
        int task_count = arr_tasks.count;
        float b = (float)task_count;
        
        
        NSString *query_completed_tasks =[ NSString stringWithFormat:@"SELECT task FROM tbl_tasks WHERE project_name = '%@' AND completed = 'YES'",self.lbl_projectName.text];
        
        NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
        arr_result1 =[[database executeQuery:query_completed_tasks]mutableCopy];
        
        int completed_task_count = arr_result1.count;
        completed_task = (float)completed_task_count;
        
        
        [_circleProgressBar setProgress:(completed_task/b) animated:YES];
        
        [database close];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Back Button

-(IBAction)backbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Email TL
-(IBAction)sendEmailTL:(id)sender
{

    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"])
    {
        [self databaseOpen];
        // Hide already showing popover
        NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
        
        NSString *query_receiver =[ NSString stringWithFormat:@"SELECT member_name FROM tbl_team WHERE project_name = '%@' AND member_type <> 'Team Leader'",projectName];
        
        NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
        arr_result1 =[[database executeQuery:query_receiver]mutableCopy];
        self.menuItems = [arr_result1 valueForKey:@"member_name"];
        
        
        [self.menuPopover dismissMenuPopover];
        
        self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:MENU_POPOVER_FRAME menuItems:self.menuItems];
        
        self.menuPopover.menuPopoverDelegate = self;
        [self.menuPopover showInView:self.view];
        [database close];
        
    }
    else
    {
        [self performSegueWithIdentifier:@"openMessages" sender:nil];
    }
    
}

#pragma mark - Add Requirement
-(IBAction)addRequirement:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:@"requirement" forKey:@"add"];
    CAPostEditorViewController *postEditPage = [[CAPostEditorViewController alloc] initWithNibName:@"CAPostEditView" bundle:[NSBundle mainBundle]];
    postEditPage.postText = @"";
    postEditPage.isEditingMode = YES;
    postEditPage.textLimit = 180;
    //postEditPage.attachmentURL = [NSURL URLWithString:@""]; // attachment URL
    postEditPage.heightConstraint = 300;
    [postEditPage setBackButtonBlock:^(CAPostEditorViewController *postEditorViewController, UIButton *backButton, NSString *text) {
        
        [postEditorViewController.view removeFromSuperview];
    }];
    [postEditPage setPostButtonBlock:^(CAPostEditorViewController *postEditorViewController, UIButton *postButton, NSString *text) {
        if([text length ]==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Requirement cannot be empty!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            [self databaseOpen];
            NSString *query_requirement=[NSString stringWithFormat:@"Insert into tbl_requirement(project_name, requirement,completed) values('%@','%@','NO')",self.lbl_projectName.text,text];
            
            [database executeNonQuery:query_requirement];
            
            [arr_requirements addObject:text];
            
            int requirement_count = arr_requirements.count;
            float a = (float)requirement_count;
            
            NSString *query_completed_requirement =[ NSString stringWithFormat:@"SELECT requirement FROM tbl_requirement WHERE project_name = '%@' AND completed = 'YES'",self.lbl_projectName.text];
            
            NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
            arr_result1 =[[database executeQuery:query_completed_requirement]mutableCopy];
            
            int completed_requirement_count = arr_result1.count;
            completed_req = (float)completed_requirement_count;
            
            [_circleProgressBar setProgress:(completed_req/requirement_count) animated:YES];
            [self.tbl_view reloadData];
            [database close];
            
            [postEditorViewController.view removeFromSuperview];
        }
    }];
    [self.view addSubview:postEditPage.view];
}

#pragma mark -Add Task
-(IBAction)addTask:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:@"task" forKey:@"add"];
    CAPostEditorViewController *postEditPage = [[CAPostEditorViewController alloc] initWithNibName:@"CAPostEditView" bundle:[NSBundle mainBundle]];
    postEditPage.postText = @"";
    postEditPage.isEditingMode = YES;
    postEditPage.textLimit = 180;
    //postEditPage.attachmentURL = [NSURL URLWithString:@""]; // attachment URL
    postEditPage.heightConstraint = 300;
    [postEditPage setBackButtonBlock:^(CAPostEditorViewController *postEditorViewController, UIButton *backButton, NSString *text) {
        
        [postEditorViewController.view removeFromSuperview];
    }];
    [postEditPage setPostButtonBlock:^(CAPostEditorViewController *postEditorViewController, UIButton *postButton, NSString *text) {
        if([text length ]==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Task cannot be empty!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }

        else
        {
            [self databaseOpen];
            NSString *query_task=[NSString stringWithFormat:@"Insert into tbl_tasks(project_name, task,completed,selected) values('%@','%@','NO', 'NO')",self.lbl_projectName.text,text];
            
            [database executeNonQuery:query_task];
            
            [arr_tasks addObject:text];
            int task_count = arr_tasks.count;
            float b = (float)task_count;
            
            
            
            NSString *query_completed_tasks =[ NSString stringWithFormat:@"SELECT task FROM tbl_tasks WHERE project_name = '%@' AND completed = 'YES'",self.lbl_projectName.text];
            
            NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
            arr_result1 =[[database executeQuery:query_completed_tasks]mutableCopy];
            
            int completed_task_count = arr_result1.count;
            
            completed_task = (float)completed_task_count;
            
            
            [_circleProgressBar setProgress:(completed_task/b) animated:YES];
            
            [self.tbl_view reloadData];
            [database close];
            [postEditorViewController.view removeFromSuperview];
        }
    }];
    [self.view addSubview:postEditPage.view];

}

#pragma mark - Sign Out
-(IBAction)signOutPressed:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - MailComposer Delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"])
    {
        return [arr_tasks count];
    }
    
    else
    {
        return [arr_requirements count];
    }
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
    NSString *text;
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Team Leader"])
    {
        text = [arr_tasks objectAtIndex:indexPath.row];
        
    }
    else
    {
        text = [arr_requirements objectAtIndex:indexPath.row];
    
    }
    
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
    NSString *cellText;
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
    {
        cellText = [arr_requirements objectAtIndex:indexPath.row];
    }
    else
    {
        cellText = [arr_tasks objectAtIndex:indexPath.row];
    }
    
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

#pragma mark - Open Completed Task/Requirement
-(IBAction)openCompleted_req_task:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
    {
        [self performSegueWithIdentifier:@"openReq" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"compTasks" sender:nil];
    }
}

#pragma mark -MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    
    NSString *title = [NSString stringWithFormat:@"%@",[self.menuItems objectAtIndex:selectedIndex]];
    [[NSUserDefaults standardUserDefaults]setValue:title forKey:@"send_message"];
    
    [self performSegueWithIdentifier:@"openMessages" sender:nil];
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
