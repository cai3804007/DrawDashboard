//
//  ImagHandlerView.h
//  DrawDashboard
//
//  Created by Sean on 2019/3/18.
//  Copyright © 2019 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagHandlerView : UIView
@property(nonatomic,strong) void(^handleCompletionBlock)(UIImage* imge);

@end

NS_ASSUME_NONNULL_END
