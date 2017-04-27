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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.pickerView reloadAllComponents];
    str_employeeType = @"Project Manager";
    self.txtfield_password.text = @"";
    self.txtfield_email.text = @"";
    
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
    str_employeeType = arr_employeeTypes[row];
    [[NSUserDefaults standardUserDefaults]setValue:str_employeeType forKey:@"employeeType"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont systemFontOfSize:14.0f]];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.textColor = [UIColor whiteColor];
        
    }
    // Fill the label text here
    tView.text = arr_employeeTypes[row];
    
    return tView;
}

#pragma mark - Login
-(IBAction)openAddProjectView:(id)sender
{
    [self databaseOpen];
    
    NSString *query=[ NSString stringWithFormat:@"SELECT emp_email, emp_password, emp_name, emp_type  FROM tbl_employee WHERE emp_email = '%@' AND emp_password ='%@' AND emp_type='%@'",self.txtfield_email.text, self.txtfield_password.text,str_employeeType];
    
    
    NSMutableArray *arr =[[NSMutableArray alloc]init];
    arr =[[database executeQuery:query]mutableCopy];
    
    if(arr.count>0)
    {
        [[NSUserDefaults standardUserDefaults]setValue:self.txtfield_email.text forKey:@"emp_email"];
        
        [self performSegueWithIdentifier:@"login" sender:nil];
        
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Credentials!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alt show];
    }
    
    [database close];
}

#pragma mark - Sign Up
-(IBAction)signUpPressed:(id)sender
{
    [self performSegueWithIdentifier:@"signUp" sender:nil];
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
