//
//  ChartViewController.m
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/27/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()

@end

@implementation ChartViewController
@synthesize barChart;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self databaseOpen];
    arr_chart = [[NSMutableArray alloc]init];
    
    NSString *projectName = [[NSUserDefaults standardUserDefaults]valueForKey:@"selected_project"];
    NSString *query_message =[ NSString stringWithFormat:@"SELECT * FROM tbl_chart  WHERE project_name = '%@' AND requirement <>'' ORDER BY requirement,design,coding,testing,documentation DESC",projectName];
    
    NSMutableArray *arr_result =[[NSMutableArray alloc]init];
    arr_result =[[database executeQuery:query_message]mutableCopy];
    
    NSArray *req = [arr_result valueForKey:@"requirement"];
    NSArray *des = [arr_result valueForKey:@"design"];
    NSArray *cod = [arr_result valueForKey:@"coding"];
    NSArray *test = [arr_result valueForKey:@"testing"];
    NSArray *doc = [arr_result valueForKey:@"documentation"];
    
    NSString *req1 = [req objectAtIndex:0];
    NSString *des1 = [des objectAtIndex:0];
    NSString *cod1 = [cod objectAtIndex:0];
    NSString *test1 = [test objectAtIndex:0];
    NSString *doc1 = [doc objectAtIndex:0];
    
    [arr_chart addObject:req1];
    [arr_chart addObject:des1];
    [arr_chart addObject:cod1];
    [arr_chart addObject:test1];
    [arr_chart addObject:doc1];
    
    NSArray *sortedArray = [arr_chart sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        return [((NSString *)secondObject) compare:((NSString *)firstObject) options:NSNumericSearch];
    }];
    //arr_chart = [arr_result valueForKey:@""]
    NSLog(@"%@",sortedArray);
    
    [self loadBarChartUsingArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Bar Chart Setup

- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    NSArray *array = [barChart createChartDataWithTitles:[NSArray arrayWithObjects:@"Documentation", @"Coding", @"Testing", @"Design", @"Requirement", nil]
                                                  values:[NSArray arrayWithObjects:@"11.0", @"9.0", @"7.0", @"5.0",@"4.0", nil]
                                                  colors:[NSArray arrayWithObjects:@"87E317", @"17A9E3", @"E32F17", @"FFE53D",@"FFE53D", nil]
                                             labelColors:[NSArray arrayWithObjects:@"FFFFFF", @"FFFFFF", @"FFFFFF",@"FFFFFF",@"FFFFFF", nil]];
    
    //Set the Shape of the Bars (Rounded or Squared) - Rounded is default
    [barChart setupBarViewShape:BarShapeRounded];
    
    //Set the Style of the Bars (Glossy, Matte, or Flat) - Glossy is default
    [barChart setupBarViewStyle:BarStyleGlossy];
    
    //Set the Drop Shadow of the Bars (Light, Heavy, or None) - Light is default
    [barChart setupBarViewShadow:BarShadowLight];
    
    //Generate the bar chart using the formatted data
    [barChart setDataWithArray:array
                      showAxis:DisplayBothAxes
                     withColor:[UIColor blackColor]
       shouldPlotVerticalLines:YES];
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
