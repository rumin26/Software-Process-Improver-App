//
//  LoginViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQlite/Sqlite.h"

@interface LoginViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *arr_employeeTypes;
    NSString *str_employeeType;
    NSString *str_email;
    NSString *str_password;
    
    Sqlite *database;
    
}
@property (strong, nonatomic) IBOutlet UITextField *txtfield_email;
@property (strong, nonatomic) IBOutlet UITextField *txtfield_password;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

-(IBAction)openAddProjectView:(id)sender;
-(IBAction)signUpPressed:(id)sender;




@end
