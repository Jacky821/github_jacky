//
//  LLKGameCenter.h
//  连连看
//
//  Created by ucsmy on 16/7/20.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GameOverBlock)(BOOL);

@interface LLKGameCenter : UIView
@property (nonatomic, copy) GameOverBlock gameOverBlock;
/** 时间*/
@property (nonatomic, assign) NSInteger timeValue;
-(instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col;
-(void)start;
@end
