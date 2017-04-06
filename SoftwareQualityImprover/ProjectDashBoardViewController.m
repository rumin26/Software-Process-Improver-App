//
//  ProjectDashBoardViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "ProjectDashBoardViewController.h"

@interface ProjectDashBoardViewController ()

@end

@implementation ProjectDashBoardViewController
@synthesize str_projectName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_circleProgressBar setProgress:(19.00f/20.00f) animated:YES];
    self.lbl_projectName.text = str_projectName;
    [self.lbl_projectName sizeToFit];
    
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
    if ([MFMailComposeViewController canSendMail])
    {
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:str_projectName];
    }
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - Add Requirement
-(IBAction)addRequirement:(id)sender
{
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
