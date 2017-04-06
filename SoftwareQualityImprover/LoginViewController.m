//
//  LoginViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr_employeeTypes = [[NSMutableArray alloc]initWithObjects:@"Project Manager", @"Team Leader",
    @"Developer/ Tester", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return arr_employeeTypes.count;
}


#pragma mark - UIPickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont systemFontOfSize:14.0f]];
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    // Fill the label text here
    tView.text = arr_employeeTypes[row];
    
    return tView;
}

#pragma mark - Open Add Project View
-(IBAction)openAddProjectView:(id)sender
{
    [self performSegueWithIdentifier:@"openAddProject" sender:nil];
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
