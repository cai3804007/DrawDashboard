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
    CGFloat angle = [self getAnglesWithThreePoint:CGPointMake(100, 100) pointB:CGPointMake(100, 150) pointC:CGPointMake(200, 150)];
    
    NSLog(@"%f",angle);
    
}

- (void)log:(UISlider *)slider{
    _dasView.proess = slider.value;
    
}

- (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC {
    
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    return angle;
}
@end
