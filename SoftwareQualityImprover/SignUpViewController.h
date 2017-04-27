//
//  SignUpViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/24/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"

@interface SignUpViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *arr_employeeTypes;
    NSString *str_employeeType;
    
    Sqlite *database;
}

@property(strong, nonatomic)IBOutlet UITextField *txtfield_name;
@property(strong, nonatomic)IBOutlet UITextField *txtfield_email;
@property(strong, nonatomic)IBOutlet UITextField *txtfield_password;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;


-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signUpPressed:(id)sender;

@end
