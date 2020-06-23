//
//  LLKImageView.h
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedBlock)(UIButton * button);

@interface LLKElement : UIButton
/** 元素类型*/
@property (nonatomic, assign) NSInteger type;
/** 行*/
@property (nonatomic, assign) NSInteger row;
/** 列*/
@property (nonatomic, assign) NSInteger col;
@property (nonatomic, copy) ClickedBlock clickedBlock;
-(instancetype)initWithFrame:(CGRect)frame clickedBlock:(ClickedBlock)clickedBlock;
@end
