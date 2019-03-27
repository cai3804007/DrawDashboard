//
//  ViewController.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "ViewController.h"
#import "DashboardView.h"
@interface ViewController ()
@property (nonatomic, strong) DashboardView *dasView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DashboardView *view = [[DashboardView alloc]initWithFrame:CGRectMake(100, 100, 210, 210)];
    _dasView = view;
    [self.view addSubview:view];
 
}




@end
