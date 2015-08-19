//
//  PlaySoundViewController.h
//  udacity_dictionary
//
//  Created by IllyaMargarit on 19.08.15.
//  Copyright (c) 2015 Denis Fromfontan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordedAudio;

@interface PlaySoundViewController : UIViewController
@property (nonatomic, strong) RecordedAudio *recordedAudio;

@end
