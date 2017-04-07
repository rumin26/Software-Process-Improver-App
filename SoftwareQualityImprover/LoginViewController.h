//
//  LoginViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *arr_employeeTypes;
    NSString *str_employeeType;
}
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

-(IBAction)openAddProjectView:(id)sender;




@end
