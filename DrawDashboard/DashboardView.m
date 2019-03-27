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
#define radiansToDegrees(x) (180.0 * x / M_PI)

/* 弧度转角度 */
#define SK_RADIANS_TO_DEGREES(radian) \
((radian) * (180.0 / M_PI))
/* 角度转弧度 */
#define SK_DEGREES_TO_RADIANS(angle) \
((angle) / 180.0 * M_PI)


static const CGFloat CUTOFF  =  M_PI_2 / 6;

@interface DashboardView()
@property (nonatomic, strong)PointerView *point;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, strong) CAShapeLayer *backBorderLayer;
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CALayer *gradientLayer;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIBezierPath *roundPath;
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
    CGFloat pointWidth = 10;
    PointerView *point = [[PointerView alloc]initWithFrame:CGRectMake(dashboardWith - pointWidth/2.0, 15, pointWidth, dashboardWith - 15)];
    [self addSubview:point];
    _point = point;
    self.backgroundColor = [UIColor orangeColor];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
 }

- (void)configBgColor{
    CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    self.radius = self.frame.size.width/2.0 - self.lineWith;
    CGFloat start = M_PI_4 * 3;
    CGFloat end = M_PI_4;
    
    _backBorderLayer = [CAShapeLayer layer];
    _backBorderLayer.frame = self.bounds;
    _backBorderLayer.fillColor = [[UIColor clearColor] CGColor];
    _backBorderLayer.strokeColor = RGB_COLOR(235, 235, 235).CGColor; //填充色
    _backBorderLayer.opacity = 1.0f;//背景颜色透明度
    _backBorderLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _backBorderLayer.lineWidth = self.lineWith;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:_radius startAngle:start endAngle:end clockwise:YES];
    self.endPoint = path.currentPoint;
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
    
//   CAShapeLayer  *layer = [CAShapeLayer layer];
//    layer.path = self.roundPath.CGPath;
//    layer.fillColor = [[UIColor clearColor] CGColor];
//    layer.strokeColor = [UIColor blackColor].CGColor; //填充色
//
//    [self.layer addSublayer:layer];
   
}

-(void)setProess:(CGFloat)proess{
    _proess = proess;
    self.backLayer.strokeEnd = proess;
}

-(CGFloat)lineWith{
    if (!_lineWith) {
        _lineWith = 10.0f;
    }
    return _lineWith;
}



- (void)handlePan: (UIPanGestureRecognizer *)gesture
{  //SYLog(@"手势状态%ld",gesture.state);
    if (gesture.state == UIGestureRecognizerStateEnded) {//停止滑动
       
    }
    CGPoint currentPosition = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        NSLog (@"[%f,%f]",currentPosition.x, currentPosition.y);
        [self handleGestureWithLocation:currentPosition];
    }
}


- (void)tapPan: (UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    [self handleGestureWithLocation:point];
    
}


- (void)handleGestureWithLocation:(CGPoint)location{
    
    BOOL b = CGPathContainsPoint(self.roundPath.CGPath, NULL, location, YES);
    if (b) {
 
        CGFloat direction = 1.0f;
        CGPoint line1Start = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        CGPoint line1End = CGPointMake(self.frame.size.width/2.0, 0);
        
        CGFloat angle = angleBetweenLines(line1Start, line1End,line1Start, location);
      
        
        if (angle > 135) {
            angle = 135;
        }
        if (location.x < self.frame.size.width/2.0){
            direction = -1.0f;
        }
        CGFloat radian = SK_DEGREES_TO_RADIANS(angle * direction);
        
        [self.point transformMakeRotateWithAngle:radian];
        self.proess = 0.5 + ((135 -angle)/135.0) * direction * 0.5;
        self.proess = angle/135.0 * direction * 0.5 + 0.5;
          NSLog(@"angle ====== %f   proess ====== %f",angle,self.proess);
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




//两条线之间的角度
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    return radiansToDegrees(rads);
}



/// 计算三点之间的角度
///
/// - Parameters:
///   - p1: 点1
///   - p2: 点2（也是角度所在点）
///   - p3: 点3
/// - Returns: 角度（180度制）
- (CGFloat)getAnglesWithThreePointsP1:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3{
    //排除特殊情况，三个点一条线
    if ((p1.x == p2.x && p2.x == p3.x) || ( p1.y == p2.x && p2.x == p3.x)){
        return 0;
    }
    
    CGFloat a = fabs(p1.x - p2.x);
    CGFloat b = fabs(p1.y - p2.y);
    CGFloat c = fabs(p3.x - p2.x);
    CGFloat d = fabs(p3.y - p2.y);
    
    if ((a < 1.0 && b < 1.0) || (c < 1.0 && d < 1.0)){
        return 0;
    }
    CGFloat e = a*c+b*d;
    CGFloat f = sqrt(a*a+b*b);
    CGFloat g = sqrt(c*c+d*d);
    CGFloat r = (CGFloat)(acos(e/(f*g)));
//    return r ;      //弧度值
    return (180*r/M_PI);      //角度值
}



//切除范围外的不响应事件
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
   
    BOOL b = CGPathContainsPoint(self.roundPath.CGPath, NULL, point, YES);
    
    if (b) {
        return YES;
    }else
        return NO;
}


-(CGPoint)needleOrigin{
    return CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height / 2.0);
}

-(UIBezierPath *)roundPath{
    if (!_roundPath) {
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
        CGPoint origin = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        CGFloat radius = 210/2.0 - 10;
        CGPoint startPoint = [self calcCircleCoordinateWithCenter:origin andWithAngle:225 + SK_RADIANS_TO_DEGREES(CUTOFF) andWithRadius:radius];
        [maskPath moveToPoint:origin];
        [maskPath addLineToPoint:startPoint];
        maskPath.lineCapStyle = kCGLineCapRound;
        maskPath.lineWidth = self.lineWith;
        CGFloat startAngle = M_PI_4 * 3 - CUTOFF;
        CGFloat endAngle = M_PI_4 + CUTOFF;
        [maskPath addArcWithCenter:origin radius:radius startAngle:startAngle  endAngle: endAngle clockwise:YES];
        [maskPath addLineToPoint:origin];
        [maskPath closePath];
        _roundPath = maskPath;
    }
    return _roundPath;
}



/*根据IOS视图中圆组件的中心点(x,y)、半径(r)、圆周上某一点与圆心的角度这3个
条件来计算出该圆周某一点在IOS中的坐标(x2,y2)。

注意：
（1）IOS坐标体系与数学坐标体系有差别，因此不能完全采用数学计算公式。
（2）数学计算公式：
x2=x+r*cos(角度值*PI/180)
y2=y+r*sin(角度值*PI/180)
（3）IOS中计算公式：
x2=x+r*cos(角度值*PI/180)
y2=y-r*sin(角度值*PI/180)

--------------------------------------------------------------
参数说明
--------------------------------------------------------------
@param (CGPoint) center

圆圈在IOS视图中的中心坐标，即该圆视图的center属性

@param (CGFloat) angle   传度数  比如 60  90 180 等
角度值，是0～360之间的值。
注意：
（1）请使用下面坐标图形进行理解。
（2）角度是逆时针转的，从x轴中心(0,0)往右是0度角（或360度角），往左是180度角，往上是90度角，往下是270度角。

(y)
^
|
|
|
|
-----------------> (x)
|(0,0)
|
|
|
@param (CGFloat) radius
圆周半径
*/
#pragma mark 计算圆圈上点在IOS系统中的坐标
- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
} 


@end




