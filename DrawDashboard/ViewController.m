//
//  ViewController.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "ViewController.h"
#import "DashboardView.h"
#import "ImagHandlerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DashboardView *view = [[DashboardView alloc]initWithFrame:CGRectMake(100, 100, 210, 210)];
    [self.view addSubview:view];
//    ImagHandlerView *view = [[ImagHandlerView alloc]initWithFrame:CGRectMake(100, 100, 210, 210)];
//    [self.view addSubview:view];
    
    
    
}


@end
