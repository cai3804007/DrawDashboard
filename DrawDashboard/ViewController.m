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
@property (nonatomic, strong) DashboardView *dasView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DashboardView *view = [[DashboardView alloc]initWithFrame:CGRectMake(100, 100, 210, 210)];
    _dasView = view;
    [self.view addSubview:view];
//    ImagHandlerView *view = [[ImagHandlerView alloc]initWithFrame:CGRectMake(100, 100, 210, 210)];
//    [self.view addSubview:view];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(40, 400, 300, 40)];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(log:) forControlEvents:UIControlEventValueChanged];
}

- (void)log:(UISlider *)slider{
    _dasView.proess = slider.value;
    
}


@end
