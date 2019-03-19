//
//  DashboardView.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "DashboardView.h"
#import "PointerView.h"
#define pointRotatedAroundAnchorPoint(point,anchorPoint,angle) CGPointMake((point.x-anchorPoint.x)*cos(angle) - (point.y-anchorPoint.y)*sin(angle) + anchorPoint.x, (point.x-anchorPoint.x)*sin(angle) + (point.y-anchorPoint.y)*cos(angle)+anchorPoint.y)

@interface DashboardView()
@property (nonatomic, strong)PointerView *point;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGPoint p0;
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

- (void)handlePan: (UIPanGestureRecognizer *) gesture
{  //SYLog(@"手势状态%ld",gesture.state);
    if (gesture.state == UIGestureRecognizerStateEnded) {//停止滑动
       
    }
      CGPoint currentPosition = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.p0 = currentPosition;
    }
    
  
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        NSLog (@"[%f,%f]",currentPosition.x, currentPosition.y);
        CGPoint p1 = currentPosition;
        CGFloat dx = fabs(p1.x - self.p0.x);
        CGFloat dy = fabs(p1.y - self.p0.y);
        // 这段代码只在第一象限移动手指有意义，其它的你需要自己实现
        CGFloat ang = M_PI_2 - atan(dy / dx);
       // [self.point transformRotateWithAngle:ang];

        self.point.transform = CGAffineTransformRotate(self.point.transform, ang);
//
//        CGFloat angle = [DashboardView getAnglesWithThreePoint:self.point.center pointB:self.point.layer.anchorPoint pointC:currentPosition];
        
        
//        let p1 = gesture.location(in: view)
//        let dx = abs(p1.x - p0.x)
//        let dy = abs(p1.y - p0.y)
//        var ang = atan(dy / dx)
//        if p1.x >= p0.x && p1.y <= p0.y {  // 第一象限
//            ang = CGFloat.pi / 2 - ang
//        } else if p1.x > p0.x && p1.y > p0.y { // 第四象限
//            ang = CGFloat.pi / 2 + ang
//        } else if p1.x < p0.x && p1.y > p0.y { // 第三象限
//            ang = CGFloat.pi * 1.5 - ang
//        } else {
//            ang = CGFloat.pi * 1.5 + ang  // 第二象限
//        }
        //arrowImage.transform = CGAffineTransform(rotationAngle: ang)

        
        
        
        
        
       
    }
}

+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC {
    
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    return angle;
}


//切除范围外的不响应事件
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.point.layer.frame];
    
 
    BOOL b = CGPathContainsPoint(maskPath.CGPath, NULL, point, YES);
    if (b) {
        return YES;
    }else
        return NO;
}

@end




