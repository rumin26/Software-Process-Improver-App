//
//  ChartInputViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/27/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"

@interface ChartInputViewController : UIViewController
{
    NSMutableArray *arr_defects;
    Sqlite *database;

}
@property(strong, nonatomic)IBOutlet UITextField *txtfield1;
@property(strong, nonatomic)IBOutlet UITextField *txtfield2;
@property(strong, nonatomic)IBOutlet UITextField *txtfield3;
@property(strong, nonatomic)IBOutlet UITextField *txtfield4;
@property(strong, nonatomic)IBOutlet UITextField *txtfield5;

@end
