//
//  TaskProgressViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/6/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressBar.h"

@class CircleProgressBar;

@interface TaskProgressViewController : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (strong, nonatomic)IBOutlet UILabel *lbl_projectName;

@property (strong, nonatomic)NSString *str_projectName;

-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;
-(IBAction)pickNewTasks:(id)sender;

@end
