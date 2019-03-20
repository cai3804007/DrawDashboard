//
//  DashboardView.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "DashboardView.h"
#import "PointerView.h"

#define RGB_COLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
@interface DashboardView()
@property (nonatomic, strong)PointerView *point;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, strong) CAShapeLayer *backBorderLayer;
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CALayer *gradientLayer;

@end


@implementation DashboardView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self configPointView];
         [self configBgColor];
        [self.point transformRotateWithAngle: -(M_PI_4 * 3)];
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
    //[point addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
 }

- (void)configBgColor{
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = self.frame.size.width/2.0 - self.lineWith;
    CGFloat start = M_PI_4 * 3;
    CGFloat end = M_PI_4;
    
    _backBorderLayer = [CAShapeLayer layer];
    _backBorderLayer.frame = self.bounds;
    _backBorderLayer.fillColor = [[UIColor clearColor] CGColor];
    _backBorderLayer.strokeColor = RGB_COLOR(235, 235, 235).CGColor; //填充色
    _backBorderLayer.opacity = 1.0f;//背景颜色透明度
    _backBorderLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _backBorderLayer.lineWidth = self.lineWith;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    _backBorderLayer.path = [path CGPath];
    [self.layer addSublayer:_backBorderLayer];
    
    
    _backLayer = [CAShapeLayer layer];
    _backLayer.frame = self.bounds;
    _backLayer.fillColor = [[UIColor clearColor] CGColor];
    _backLayer.strokeColor = [[UIColor redColor] CGColor];
    _backLayer.lineCap = kCALineCapRound;
    _backLayer.lineWidth = self.lineWith;
    _backLayer.path = [path CGPath];
    _backLayer.strokeEnd = 0;
    
    _gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayerLeft = [CAGradientLayer layer];
    gradientLayerLeft.frame = CGRectMake(0, 0, self.frame.size.width/2.0, self.frame.size.height);
    UIColor *red = [UIColor redColor];
    UIColor *yellow = [UIColor yellowColor];
    UIColor *blue = [UIColor blueColor];
    
    [gradientLayerLeft setColors:@[(id)red.CGColor,(id)yellow.CGColor]];
    [gradientLayerLeft setLocations:@[@0.15,@0.85]];
    [gradientLayerLeft setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayerLeft setEndPoint:CGPointMake(0.5, 0)];
    [_gradientLayer addSublayer:gradientLayerLeft];
    
    CAGradientLayer *gradientLayerright = [CAGradientLayer layer];
    [gradientLayerright setLocations:@[@0.15,@0.85]];
    gradientLayerright.frame = CGRectMake(self.frame.size.width/2.0,0, self.frame.size.width/2, self.frame.size.height);
    
    [gradientLayerright setColors:@[(id)yellow.CGColor,(id)blue.CGColor]];
    [gradientLayerright setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayerright setEndPoint:CGPointMake(0.5, 1)];
    [_gradientLayer addSublayer:gradientLayerright];
    
    [_gradientLayer setMask:_backLayer];
    [self.layer addSublayer:_gradientLayer];
}

-(void)setProess:(CGFloat)proess{
   
    CGFloat angle = proess - _proess;
     _proess = proess;
    self.backLayer.strokeEnd = proess;
      [self.point transformRotateWithAngle: (M_PI_2 * 3) *angle];
    
}

-(CGFloat)lineWith{
    if (!_lineWith) {
        _lineWith = 10.0f;
    }
    return _lineWith;
}



- (void)handlePan: (UIPanGestureRecognizer *) gesture
{  //SYLog(@"手势状态%ld",gesture.state);
    if (gesture.state == UIGestureRecognizerStateEnded) {//停止滑动
       
    }
    CGPoint currentPosition = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        NSLog (@"[%f,%f]",currentPosition.x, currentPosition.y);
        
        CGFloat angle = [DashboardView getAnglesWithThreePoint:self.point.center pointB:self.point.layer.anchorPoint pointC:currentPosition];
        [self.point transformRotateWithAngle:((angle) / 180.0 * M_PI_2)];
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



@end




