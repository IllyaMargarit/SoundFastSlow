//
//  PlaySoundViewController.m
//  udacity_dictionary
//
//  Created by IllyaMargarit on 19.08.15.
//  Copyright (c) 2015 Denis Fromfontan. All rights reserved.
//

#import "PlaySoundViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlaySoundViewController.h"
#import "RecordedAudio.h"


@interface PlaySoundViewController () <AVAudioPlayerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *chipmunkButton;
@property (nonatomic, weak) IBOutlet UIButton *dartvaderButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, readonly) AVAudioPlayer *player;
@property (nonatomic, readonly) AVAudioFile *audioFile;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNode;
@property (nonatomic, readonly) AVAudioEngine *audioEngine;

@end

@implementation PlaySoundViewController
@synthesize player, audioFile, audioEngine;

- (AVAudioPlayer*)player {
    if (!player) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordedAudio.fileURL error:nil];
    }
    return player;
}

- (AVAudioFile*)audioFile {
    if (!audioFile) {
        audioFile = [[AVAudioFile alloc] initForReading:self.recordedAudio.fileURL error:nil];
    }
    return audioFile;
}

- (AVAudioEngine*)audioEngine {
    if (!audioEngine) {
        audioEngine = [[AVAudioEngine alloc] init];
    }
    return audioEngine;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!NSClassFromString(@"AVAudioEngine")) {
        //Проверка на ios 8 (не на наушники а на динамик)
        self.chipmunkButton.enabled = NO;
        self.dartvaderButton.enabled = NO;
    }
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}

//Helper
- (void)stopPlayer {
    [player stop];
    [self.audioEngine stop];
    [self.audioEngine reset];
}

- (void)playWithRate:(float)rate {
    self.player.enableRate = YES;
    self.player.rate = rate;
    self.player.currentTime = 0.0;
    self.player.delegate = self;
    [self.player play];
    self.stopButton.enabled = YES;
}

- (IBAction)playSlow:(UIButton*)sender {
    [self stopPlayer];
    [self playWithRate:0.5];
}

- (IBAction)playfust:(UIButton*)sender {
    [self stopPlayer];
    [self playWithRate:2.0];
}

- (void)playAudioWithPith:(float)pitch {
    
    [self stopPlayer];
    self.stopButton.enabled = NO;
    [self.audioEngine stop];
    [self.audioEngine reset];
    
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    [audioEngine attachNode:self.audioPlayerNode];
    
    AVAudioUnitTimePitch *changePitchEffect = [[AVAudioUnitTimePitch alloc]init];
    changePitchEffect.pitch = pitch;
    [self.audioEngine attachNode:changePitchEffect];
    [self.audioEngine connect:self.audioPlayerNode to:changePitchEffect format:nil];
    [self.audioEngine connect:changePitchEffect to:self.audioEngine.outputNode format:nil];
    [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stopButton.enabled = NO;
        });
    }];
    [self.audioEngine startAndReturnError:nil];
    [self.audioPlayerNode play];
    
    
    
    
}

- (IBAction)playChipmunk:(UIButton*)sender {
    [self stopPlayer];
    [self playAudioWithPith:1000.0];
}

- (IBAction)playDartvader:(UIButton*)sender {
    [self stopPlayer];
    [self playAudioWithPith:-1000.0];
}

- (IBAction)stop:(UIButton*)sender {
    [self stopPlayer];
    self.stopButton.enabled = NO;
    [self.audioPlayerNode stop];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.stopButton.enabled = NO;
}






@end




