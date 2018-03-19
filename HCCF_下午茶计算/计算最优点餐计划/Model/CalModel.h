//
//  CalModel.h
//  HCCF_下午茶计算
//
//  Created by Lyh on 2018/3/16.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalModel : NSObject

//满 多少钱
@property (nonatomic, copy) NSString *fullValue;

//减 多少钱
@property (nonatomic, copy) NSString *reduceValue;

//配送费
@property (nonatomic, copy) NSString *deliveryValue;

@end
