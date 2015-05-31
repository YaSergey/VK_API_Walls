//
//  Responce.h
//  VK_API_Walls
//
//  Created by Sergey Yasnetsky on 30.05.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"

@interface Response : Attachment

@property (nonatomic, strong) Attachment * attachment;
@property (nonatomic, copy) NSString * text;




@end
