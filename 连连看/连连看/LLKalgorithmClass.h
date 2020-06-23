//
//  LLKalgorithmClass.h
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLKalgorithmClass : NSObject
/** 判断两点之间是否能连*/
+(BOOL)connectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data;
@end
