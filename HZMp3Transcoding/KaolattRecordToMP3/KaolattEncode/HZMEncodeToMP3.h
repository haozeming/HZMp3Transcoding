//
//  KaolattEncodeToMP3.h
//  RecordTest
//
//  Created by 郝泽明 on 14/10/21.
//  Copyright (c) 2014年 车语传媒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lame/lame.h"
@interface KaolattEncodeToMP3 : NSObject
{
    lame_t lame;
    FILE *kaolattMP3File;
    NSString *_kaolattMP3FilePath;
}
@property (nonatomic, strong) NSString *kaolattMP3FilePath;

/* !
 * @method 初始化
 * @abstract
 * @discussion
 * @param
 * @result
 */
-(id)init;

/* !
 * @method 编码--可以实现边录音边转码
 * @abstract 可以实现即使语音
 * @discussion
 * @param
 * @result
 */
-(void)encodeToMP3With:(NSData *)originalData;
@end
