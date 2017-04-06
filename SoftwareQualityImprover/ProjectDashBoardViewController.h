//
//  ProjectDashBoardViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/5/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CircleProgressBar.h"

@class CircleProgressBar;

@interface ProjectDashBoardViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
}
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (strong, nonatomic)IBOutlet UILabel *lbl_projectName;

@property (strong, nonatomic)NSString *str_projectName;


-(IBAction)backbtnPressed:(id)sender;
-(IBAction)sendEmailTL:(id)sender;
-(IBAction)addRequirement:(id)sender;
-(IBAction)signOutPressed:(id)sender;

@end
