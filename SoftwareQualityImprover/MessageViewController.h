//
//  MessageViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/26/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"
#import "CAPostEditorViewController.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface MessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arr_messages;
    NSMutableArray *arr_sender;
    NSMutableArray *arr_receiver;
    
    Sqlite *database;
    
}
-(IBAction)backbtnPressed:(id)sender;
-(IBAction)signOutPressed:(id)sender;

@property(strong,nonatomic)IBOutlet UITableView *tbl_messages;
@property(strong, nonatomic)IBOutlet UILabel *lbl_receiverName;

@end
