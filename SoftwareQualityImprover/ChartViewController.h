//
//  ChartViewController.h
//  SoftwareQualityImprover
//
//  Created by Rumin Shah on 4/27/17.
//  Copyright © 2017 Rumin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartView.h"
#import "Sqlite.h"

@interface ChartViewController : UIViewController
{
    Sqlite *database;
    NSMutableArray *arr_chart;
    NSArray *sortedArray ;
    
}
@property (strong, nonatomic) IBOutlet BarChartView *barChart;
@end
