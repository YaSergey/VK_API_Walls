//
//  Attachment.h
//  VK_API_Walls
//
//  Created by Sergey Yasnetsky on 30.05.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"


@interface Attachment : Photo

@property (nonatomic, strong) Photo * photo;
@property (nonatomic, copy) NSString * type;


@end
