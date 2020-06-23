//
//  LLKalgorithmClass.m
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "LLKalgorithmClass.h"

@implementation LLKalgorithmClass

+(BOOL)connectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data
{
    if ([self oneConnectionWithCGPoint:pointA pointB:pointB data:data]) {
        return YES;
    }
    else if ([self twoConnectionWithCGPoint:pointA pointB:pointB data:data])
    {
        return YES;
    }
    else if ([self thirdConnectionWithCGPoint:pointA pointB:pointB data:data])
    {
        return YES;
    }
    return NO;
}
/**
 * 直连
 * pointA：点击的其中一个元素
 * pointB：点击的另一个元素
 * data：数据图
 */
+ (BOOL)oneConnectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data{
    //如果同行
    NSInteger minValue = -1;
    NSInteger maxValue = -1;
    //同行
    if (pointA.x == pointB.x) {
        //相邻
        if (fabs(pointA.y - pointB.y) == 1) {
            return YES;
        }
        //判断哪个值大小
        if (pointA.y > pointB.y) {
            minValue = pointB.y;
            maxValue = pointA.y;
        }
        else{
            maxValue = pointB.y;
            minValue = pointA.y;
        }
        //遍历数据minValue 与 maxValue 之间的数值 如果为0代表通路 否则有阻碍
        if (pointA.x > data.count) {
            return NO;
        }
        NSMutableArray *list = data[(NSInteger)pointA.x];
        for (NSInteger i = minValue + 1; i < maxValue; i++){
            NSNumber *number = list[i];
            if ([number integerValue] != 0) {
                return NO;
            }
        }
    }
    //同列
    else if (pointA.y == pointB.y){
        //相邻
        if (fabs(pointA.x - pointB.x) == 1) {
            return YES;
        }
        //判断哪个值大小
        if (pointA.x > pointB.x) {
            minValue = pointB.x;
            maxValue = pointA.x;
        }
        else{
            maxValue = pointB.x;
            minValue = pointA.x;
        }
        //遍历数据minValue 与 maxValue 之间的数值 如果为0代表通路 否则有阻碍
        if (pointA.y > data.count) {
            return NO;
        }
        for (NSInteger i = minValue + 1; i < maxValue; i++){
            NSMutableArray *list = data[i];
            NSNumber *number = list[(NSInteger)pointA.y];
            if ([number integerValue] != 0) {
                return NO;
            }
        }
    }
    else{
        return NO;
    }
    return YES;
}

/**
* 一折连
* pointA：点击的其中一个元素
* pointB：点击的另一个元素
* data：数据图
*/
+(BOOL)twoConnectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data{
    CGPoint point1 = CGPointMake(pointA.x, pointB.y);//取第一个拐点
    CGPoint point2 = CGPointMake(pointB.x, pointA.y);//取第二个拐点
    NSArray *list = data[(NSInteger)point1.x];
    NSNumber *number = list[(NSInteger)point1.y];
    if ([number integerValue] == 0) {//判断第一个拐点的位置是不是通路(通路为0)
        //拿到拐点分别和要进行一折连的两个点 进行直连判断 如果都能直连 可以一折连
        BOOL flagA = [self oneConnectionWithCGPoint:point1 pointB:pointB data:data];
        BOOL flagB = [self oneConnectionWithCGPoint:point1 pointB:pointA data:data];
        if (flagA && flagB){
            NSLog(@"拐点：%@", NSStringFromCGPoint(point1));
            NSLog(@"pointA : %@", NSStringFromCGPoint(pointA));
            NSLog(@"pointB : %@", NSStringFromCGPoint(pointB));
            return YES;
        }
    }
    
    list = data[(NSInteger)point2.x];
    number = list[(NSInteger)point2.y];
    if ([number integerValue] == 0) {//判断第二个拐点的位置是不是通路(通路为0)
        //拿到拐点分别和要进行一折连的两个点 进行直连判断 如果都能直连 可以一折连
        BOOL flagA = [self oneConnectionWithCGPoint:point2 pointB:pointB data:data];
        BOOL flagB = [self oneConnectionWithCGPoint:point2 pointB:pointA data:data];
        if (flagA && flagB){
            NSLog(@"%@", NSStringFromCGPoint(point2));
            NSLog(@"pointA : %@", NSStringFromCGPoint(pointA));
            NSLog(@"pointB : %@", NSStringFromCGPoint(pointB));
            return YES;
        }
    }
    return NO;
}

/**
* 两折连
* pointA：点击的其中一个元素
* pointB：点击的另一个元素
* data：数据图
*/
+(BOOL)thirdConnectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data{
    NSInteger row = data.count;
    NSInteger col = [[data lastObject] count];
    //左
    for (NSInteger i = pointA.y - 1; i >= 0; i--) {
        NSArray *list = data[(NSInteger)pointA.x];
        NSNumber *number = list[i];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(pointA.x, i) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    //右
    for (NSInteger i = pointA.y + 1; i < col; i++) {
        NSArray *list = data[(NSInteger)pointA.x];
        NSNumber *number = list[i];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(pointA.x, i) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    //上
    for (NSInteger i = pointA.x - 1; i >= 0; i--) {
        NSArray *list = data[i];
        NSNumber *number = list[(NSInteger)pointA.y];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(i, pointA.y) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    //下
    for (NSInteger i = pointA.x + 1; i < row; i++) {
        NSArray *list = data[i];
        NSNumber *number = list[(NSInteger)pointA.y];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(i, pointA.y) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    return NO;
}
@end
