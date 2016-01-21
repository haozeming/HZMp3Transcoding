//
//  HZMEncode.h
//  HZMp3Transcoding
//
//  Created by 郝泽明 on 16/1/21.
//  Copyright © 2016年 Vega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lame/lame.h"

@interface HZMEncode : NSObject
{
    lame_t lame;
    FILE *mp3File;
}

/*转码路径*/
@property (nonatomic, strong) NSString *mp3FilePath;

/* !
 * @method 初始化
 * @abstract
 * @discussion
 * @param
 * @result
 */
-(instancetype)init;

/* !
 * @method 编码--可以实现边录音边转码
 * @abstract 可以实现即使语音
 * @discussion
 * @param
 * @result
 */
-(void)encodeToMP3With:(NSData *)originalData;

@end
