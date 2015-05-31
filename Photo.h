//
//  Photo.h
//  VK_API_Walls
//
//  Created by Sergey Yasnetsky on 30.05.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"


@interface Photo : Jastor


@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, copy) NSString * src_big;



@end
