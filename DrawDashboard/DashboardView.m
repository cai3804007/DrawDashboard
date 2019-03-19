//
//  DashboardView.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "DashboardView.h"
#import "PointerView.h"

@interface DashboardView()
@property (nonatomic, strong)PointerView *point;
@property (nonatomic, strong) NSTimer *timer;
@end


@implementation DashboardView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self configPointView];
 
    }
    return self;
}

- (void)configPointView{
    CGFloat dashboardWith = self.frame.size.width/2.0;
    CGFloat pointWidth = 20;
    PointerView *point = [[PointerView alloc]initWithFrame:CGRectMake(dashboardWith - pointWidth/2.0, 15, pointWidth, dashboardWith - 15)];
    [self addSubview:point];
    _point = point;
    self.backgroundColor = [UIColor orangeColor];
    [point addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
 }

- (void) handlePan: (UIPanGestureRecognizer *) gesture
{  //SYLog(@"手势状态%ld",gesture.state);
    if (gesture.state == UIGestureRecognizerStateEnded) {//停止滑动
       
    }
    CGPoint currentPosition = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
                NSLog (@"[%f,%f]",currentPosition.x, currentPosition.y);
       // self.currentRadian = [self calculateRadian:currentPosition];
        
        [self setNeedsDisplay];
        //根据角度计算value
       // [self countValue];
        //返回value
    }
}


@end
