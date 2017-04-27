//
//  SignUpViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/24/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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


#pragma mark- Back Button

-(IBAction)backbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark- SignUp
-(IBAction)signUpPressed:(id)sender
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if(([self.txtfield_email.text length]==0) || ([emailTest evaluateWithObject:_txtfield_email.text] == NO) ||  ([self.txtfield_password.text length]<6) || ([self.txtfield_name.text length]==0))
        
    {
        if([self.txtfield_name.text length]==0)
        {
            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid name!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
            
        }
        
        
        else if([emailTest evaluateWithObject:self.txtfield_email.text] == NO)
        {
            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
            
        }
        
        
        else if ([self.txtfield_password.text length]<6)
        {
            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Password must be six character long." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        
        
    }
    else
        
    {
        [self databaseOpen];
        
        NSString *query_user=[NSString stringWithFormat:@"Insert into tbl_employee(emp_name, emp_email, emp_password, emp_type) values('%@','%@','%@','%@')",self.txtfield_name.text, self.txtfield_email.text, self.txtfield_password.text, str_employeeType];
        
        [database executeNonQuery:query_user];
        [database close];
        
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Sign Up Complete!" message:@"You have successfully signed up." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alt show];

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

#pragma mark - UIAlert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
