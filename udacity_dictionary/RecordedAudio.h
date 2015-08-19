//
//  RecordedAudio.h
//  udacity_dictionary
//
//  Created by IllyaMargarit on 19.08.15.
//  Copyright (c) 2015 Denis Fromfontan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordedAudio : NSObject
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSString *title;

@end
