//
//  User.h
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "JKDBModel.h"

@interface User : JKDBModel

// 名字
@property (nonatomic, copy) NSString * name;
// 头像路径
@property (nonatomic, copy) NSString * portrait;

@end
