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
@synthesize str_projectName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_circleProgressBar setProgress:(19.00f/20.00f) animated:YES];
    self.lbl_projectName.text = str_projectName;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
