//
//  MessageViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/26/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    
    
    [self databaseOpen];
    NSString *query_message =[ NSString stringWithFormat:@"SELECT message FROM tbl_messages_pm_tl WHERE project_name = '%@'",projectName];
    
    NSMutableArray *arr_result =[[NSMutableArray alloc]init];
    arr_result =[[database executeQuery:query_message]mutableCopy];
    arr_messages = [[arr_result valueForKey:@"message"]mutableCopy];
    arr_receiver = [[arr_result valueForKey:@"receiver_name"]mutableCopy];
    arr_sender = [[arr_result valueForKey:@"sender_name"]mutableCopy];
    
    //self.lbl_receiverName.text = [arr_receiver objectAtIndex:0];
    
    //arr_tasks = [[arr_result valueForKey:@"task"]mutableCopy];
    
    [database close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [arr_messages count];
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
    
    
    
   // NSString *login_user = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];

    NSString *text = [arr_messages objectAtIndex:indexPath.row];
    
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

#pragma mark - Compose Message
-(IBAction)composeMessage:(id)sender
{
    NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];

    [[NSUserDefaults standardUserDefaults]setValue:@"message" forKey:@"add"];
    
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Message cannot be empty!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
    
            }
            else
            {
                [self databaseOpen];
                NSString *sender = [[NSUserDefaults standardUserDefaults]valueForKey:@"emp_email"];
    
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"employeeType"] isEqualToString:@"Project Manager"])
                {
                    ////Fetch Team Leader
                    NSString *query_receiver =[ NSString stringWithFormat:@"SELECT member_email,member_name FROM tbl_team WHERE project_name = '%@' AND member_type = 'Team Leader'",projectName];
    
                    NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
                    arr_result1 =[[database executeQuery:query_receiver]mutableCopy];
                        NSMutableArray *arr_tl_name = [arr_result1 valueForKey:@"member_name"];
                    NSMutableArray *arr_tl_email = [arr_result1 valueForKey:@"member_email"];
    
                    ////Fetch Project Manager
                    NSString *query_manager =[ NSString stringWithFormat:@"SELECT member_email, member_name FROM tbl_team WHERE project_name = '%@' AND member_email = '%@'",projectName, sender];
    
                    NSMutableArray *arr_result2 =[[NSMutableArray alloc]init];
                    arr_result2 =[[database executeQuery:query_manager]mutableCopy];
                    NSMutableArray *arr_pm_name = [arr_result2 valueForKey:@"member_name"];
                    //NSMutableArray *arr_pm_email = [arr_result2 valueForKey:@"member_email"];
                
                    
                    ////Create Message
                    NSString*sender_name = [[arr_pm_name objectAtIndex:0]stringByAppendingString:@": "];
                    NSString*message = [sender_name stringByAppendingString:text];
                
                    NSString *query_message=[NSString stringWithFormat:@"Insert into tbl_messages_pm_tl(project_name, sender_email,sender_name,receiver_email,receiver_name,message) values('%@','%@','%@','%@','%@','%@')",projectName,sender,[arr_pm_name objectAtIndex:0], [arr_tl_email objectAtIndex:0]  ,[arr_tl_name objectAtIndex:0],message];
    
                    [database executeNonQuery:query_message];
                    ///Fetch sent message
                    [arr_messages addObject:message];
                    
                }
                
                else
                {
                    ///Fetch sender
                    NSString *query_sender =[ NSString stringWithFormat:@"SELECT member_email, member_name FROM tbl_team WHERE project_name = '%@' AND member_email = '%@'",projectName, sender];
                    
                    NSMutableArray *arr_result2 =[[NSMutableArray alloc]init];
                    arr_result2 =[[database executeQuery:query_sender]mutableCopy];
                    NSMutableArray *arr_sender_name = [arr_result2 valueForKey:@"member_name"];
                    
                    ///Fetch Receiver
                    NSString *receiver = [[NSUserDefaults standardUserDefaults]valueForKey:@"send_message"];
                    
                    NSString *query_receiver =[ NSString stringWithFormat:@"SELECT member_email,member_name FROM tbl_team WHERE project_name = '%@' AND member_name = '%@'",projectName, receiver];
                    
                    NSMutableArray *arr_result1 =[[NSMutableArray alloc]init];
                    arr_result1 =[[database executeQuery:query_receiver]mutableCopy];
                    NSMutableArray *arr_receiver_name = [arr_result1 valueForKey:@"member_name"];
                    NSMutableArray *arr_receiver_email = [arr_result1 valueForKey:@"member_email"];
                    
                    ////Create Message
                    NSString*sender_name = [[arr_sender_name objectAtIndex:0]stringByAppendingString:@": "];
                    NSString*message = [sender_name stringByAppendingString:text];
                    
                    NSString *query_message=[NSString stringWithFormat:@"Insert into tbl_messages_pm_tl(project_name, sender_email,sender_name,receiver_email,receiver_name,message) values('%@','%@','%@','%@','%@','%@')",projectName,sender,[arr_sender_name objectAtIndex:0], [arr_receiver_email objectAtIndex:0]  ,[arr_receiver_name objectAtIndex:0],message];
                    
                    [database executeNonQuery:query_message];
                    ///Fetch sent message
                    [arr_messages addObject:message];
                    
                    
                }
                
                
                [self.tbl_messages reloadData];
                
                
//                NSString *query_getmessage =[ NSString stringWithFormat:@"SELECT message FROM tbl_messages_pm_tl WHERE project_name = '%@'",projectName];
//                
//                NSMutableArray *arr_result =[[NSMutableArray alloc]init];
//                arr_result =[[database executeQuery:query_getmessage]mutableCopy];
//                arr_messages = [[arr_result valueForKey:@"message"]mutableCopy];
    
    
                [database close];
                
                [postEditorViewController.view removeFromSuperview];
            }
        }];
        [self.view addSubview:postEditPage.view];
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
