//
//  ChartInputViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/27/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "ChartInputViewController.h"

@interface ChartInputViewController ()

@end

@implementation ChartInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr_defects = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sign Out
-(IBAction)signOutPressed:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark- Back Button

-(IBAction)backbtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark- Create Chart
-(IBAction)createChart:(id)sender
{
    float a = [self.txtfield1.text floatValue];
    float b = [self.txtfield2.text floatValue];
    float c = [self.txtfield3.text floatValue];
    float d = [self.txtfield4.text floatValue];
    float e = [self.txtfield5.text floatValue];
    
    NSNumber *num1 = [NSNumber numberWithFloat:a];
    NSNumber *num2 = [NSNumber numberWithFloat:b];
    NSNumber *num3 = [NSNumber numberWithFloat:c];
    NSNumber *num4 = [NSNumber numberWithFloat:d];
    NSNumber *num5 = [NSNumber numberWithFloat:e];
    
    //arr_defects = [[NSMutableArray alloc]initWithObjects:num1,num2,num3,num4,num5, nil];
    NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    [self databaseOpen];
    NSString *query_user=[NSString stringWithFormat:@"Insert into tbl_chart(project_name, requirement, design, coding, testing, documentation) values('%@','%@','%@','%@','%@','%@')",projectName,self.txtfield1.text,self.txtfield2.text,self.txtfield3.text,self.txtfield4.text,self.txtfield5.text];
    
    [database executeNonQuery:query_user];
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init]; // Don't always need this
//    // Note you can't use setObject: forKey: if you are using NSDictionary
//    [dict setObject:num1 forKey:self.txtfield1.text];
//    [dict setObject:num2 forKey:self.txtfield2.text];
//    [dict setObject:num3 forKey:self.txtfield3.text];
//    [dict setObject:num4 forKey:self.txtfield4.text];
//    [dict setObject:num5 forKey:self.txtfield5.text];
//
//    NSArray *orderedKeys = [dict keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
//        return [obj2 compare:obj1];
//    }];
//    NSLog(@"%@",orderedKeys);
    
    //[[NSUserDefaults standardUserDefaults]setObject:sortedArray forKey:@"chart_array"];
    
    [database close];
    [self performSegueWithIdentifier:@"chart" sender:nil];
    
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
