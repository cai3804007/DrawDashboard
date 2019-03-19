//
//  ImagHandlerView.m
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import "ImagHandlerView.h"
@interface ImagHandlerView ()<UIGestureRecognizerDelegate>

@property(strong,nonatomic)UIImageView * imageView;

@end
@implementation ImagHandlerView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_imageView];
        self.backgroundColor = [UIColor clearColor];
        [self setUpGestureRecognizer];
    }
    
    return  self;
    
}
-(void)drawRect:(CGRect)rect {
    // Drawing code
}

-(void)setUpGestureRecognizer{
    //拖动/
    UIPanGestureRecognizer  * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    
    
    /**
     旋转
     */
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    
    [self.imageView addGestureRecognizer:rotation];
    
    rotation.delegate = self;
    
    
    /**
     缩放
     */
    UIPinchGestureRecognizer  * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    
    [self.imageView addGestureRecognizer:pinch];
    pinch.delegate = self;
    
    
    //长按
    UILongPressGestureRecognizer  * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    
    [self.imageView addGestureRecognizer:longPress];
    
}
-(void)pan:(UIPanGestureRecognizer*)pan{
    //获取手指偏移量
    CGPoint transP=  [pan translationInView:self.imageView];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, transP.x, transP.y);
    [pan setTranslation:CGPointZero inView:self.imageView];
    
}
-(void)rotation:(UIRotationGestureRecognizer*)rotation{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotation.rotation);
    rotation.rotation = 0;
    
}
-(void)pinch:(UIPinchGestureRecognizer*)pinch{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale) ;
    pinch.scale = 1;
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
   // 这里要注意 长安的状态 有开始。改变。和结束
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.imageView.alpha= 1.0;
            } completion:^(BOOL finished) {
                
                // 获取图片
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                CGContextRef ref = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ref];
                
                UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                self.handleCompletionBlock(imge);
                [self removeFromSuperview];
            }];
        }];
    }
    
}
#pragma mark  代理方法
// 实现这个地理方法这样的话 可用同时响应多个手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
