//
//  PointerView.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "PointerView.h"
@interface PointerView()

@end



@implementation PointerView
- (instancetype)initWithFrame:(CGRect)frame
{
   
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.anchorPoint = CGPointMake(0.5, 1);
        self.frame = frame;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self drawNeedle];
}

//画指针
-(void)drawNeedle{
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    CGPoint start = CGPointMake(0,  self.bounds.size.height - self.bounds.size.width/2.0);
    CGPoint bottomcenter = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height - self.bounds.size.width/2.0);
    [needlePath moveToPoint:start];
    [needlePath addArcWithCenter:bottomcenter radius:self.bounds.size.width/2.0 startAngle:M_PI endAngle:0 clockwise:NO];
    
    CGPoint topCenter = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.width/2.0);
    
    [needlePath addArcWithCenter:topCenter radius:self.bounds.size.width/2.0 - self.bounds.size.width/4.0 startAngle:0 endAngle:M_PI clockwise:NO];
    
    
    [needlePath addLineToPoint:start];
    
    [needlePath stroke];
    
    UIBezierPath *innerPath = [UIBezierPath bezierPath];
    CGFloat innerPathRadius = 3;
    CGPoint innerPathStart = CGPointMake(self.bounds.size.width/2.0 + innerPathRadius, self.bounds.size.height - self.bounds.size.width/2.0);
    [innerPath moveToPoint:innerPathStart];
    [innerPath addArcWithCenter:bottomcenter radius:innerPathRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [innerPath stroke];
}

- (void)transformRotateWithAngle:(CGFloat)angle{
//    CGFloat radius = atan2f(self.transform.b, self.transform.a);
//    CGFloat degree = radius * (360/ M_PI);
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, angle);
    self.transform = newTransform;
}


@end
