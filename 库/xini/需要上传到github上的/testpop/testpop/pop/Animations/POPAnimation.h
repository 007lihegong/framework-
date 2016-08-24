/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/NSObject.h>

#import "POPAnimationTracer.h"
#import "POPGeometry.h"

@class CAMediaTimingFunction;

/**
 @abstract The abstract animation base class.
 @discussion Instantiate and use one of the concrete animation subclasses.
 
 实例化并使用动画的一个具体子类。
 */
@interface POPAnimation : NSObject

/**
 @abstract The name of the animation.
 @discussion Optional property to help identify the animation.
 
 可选属性来帮助识别动画
 */
@property (copy, nonatomic) NSString *name;

/**
 @abstract The beginTime of the animation in media time.
 @discussion Defaults to 0 and starts immediately.
 
 开始时间（距当前时间多久，默认为0，立即开始）
 */
@property (assign, nonatomic) CFTimeInterval beginTime;

/**
 @abstract The animation delegate.
 @discussion See {@ref POPAnimationDelegate} for details.
 
 动画的代理
 */
@property (weak, nonatomic) id delegate;

/**
 @abstract The animation tracer.
 @discussion Returns the existing tracer, creating one if needed. Call start/stop on the tracer to toggle event collection.
 
 动画追踪，返回现有的
 */
@property (readonly, nonatomic) POPAnimationTracer *tracer;

/**
 @abstract Optional block called on animation start.
 
 动画开始
 */
@property (copy, nonatomic) void (^animationDidStartBlock)(POPAnimation *anim);

/**
 @abstract Optional block called when value meets or exceeds to value.
 
 调用值大于或等于
 */
@property (copy, nonatomic) void (^animationDidReachToValueBlock)(POPAnimation *anim);

/**
 @abstract Optional block called on animation completion.
 
 动画完成
 */
@property (copy, nonatomic) void (^completionBlock)(POPAnimation *anim, BOOL finished);

/**
 @abstract Optional block called each frame animation is applied.
 
 每一帧的动画
 */
@property (copy, nonatomic) void (^animationDidApplyBlock)(POPAnimation *anim);

/**
 @abstract Flag indicating whether animation should be removed on completion.
 @discussion Setting to NO can facilitate animation reuse. Defaults to YES.
 
 是否在动画完成后删除，默认为yes，no的话就会设置不促进动画重用
 */
@property (assign, nonatomic) BOOL removedOnCompletion;

/**
 @abstract Flag indicating whether animation is paused.
 @discussion A paused animation is excluded from the list of active animations. On initial creation, defaults to YES. On animation addition, the animation is implicity unpaused. On animation completion, the animation is implicity paused including for animations with removedOnCompletion set to NO.
 
 动画是否停止
 */
@property (assign, nonatomic, getter = isPaused) BOOL paused;

/**
 @abstract Flag indicating whether animation autoreverses.
 @discussion An animation that autoreverses will have twice the duration before it is considered finished. It will animate to the toValue, stop, then animate back to the original fromValue. The delegate methods are called as follows:

     1) animationDidStart: is called at the beginning, as usual, and then after each toValue is reached and the autoreverse is going to start.
     2) animationDidReachToValue: is called every time the toValue is reached. The toValue is swapped with the fromValue at the end of each animation segment. This means that with autoreverses set to YES, the animationDidReachToValue: delegate method will be called a minimum of twice.
     3) animationDidStop:finished: is called every time the toValue is reached, the finished argument will be NO if the autoreverse is not yet complete.
 
 动画运行过去再运行回来，往返
 */
@property (assign, nonatomic) BOOL autoreverses;

/**
 @abstract The number of times to repeat the animation.
 @discussion A repeatCount of 0 or 1 means that the animation will not repeat, just like Core Animation. A repeatCount of 2 or greater means that the animation will run that many times before stopping. The delegate methods are called as follows:

     1) animationDidStart: is called at the beginning of each animation repeat.
     2) animationDidReachToValue: is called every time the toValue is reached.
     3) animationDidStop:finished: is called every time the toValue is reached, the finished argument will be NO if the autoreverse is not yet complete.

When combined with the autoreverses property, a singular animation is effectively twice as long.
 
 动画重复的次数
 */
@property (assign, nonatomic) NSInteger repeatCount;

/**
 @abstract Repeat the animation forever.
 @discussion This property will make the animation repeat forever. The value of the repeatCount property is undefined when this property is set. The finished parameter of the delegate callback animationDidStop:finished: will always be NO.
 
 动画无限循环运行，没有定义重复次数，永远不会停止
 */
@property (assign, nonatomic) BOOL repeatForever;

@end

/**
 @abstract The animation delegate.
 */
@protocol POPAnimationDelegate <NSObject>
@optional

/**
 @abstract Called on animation start.
 @param anim The relevant animation.
 
 动画开始
 */
- (void)pop_animationDidStart:(POPAnimation *)anim;

/**
 @abstract Called when value meets or exceeds to value.
 @param anim The relevant animation.
 
 动画调用值超过了某个值
 */
- (void)pop_animationDidReachToValue:(POPAnimation *)anim;

/**
 @abstract Called on animation stop.
 @param anim The relevant animation.
 @param finished Flag indicating finished state. Flag is true if the animation reached completion before being removed.
 
 停止动画
 */
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished;

/**
 @abstract Called each frame animation is applied.
 @param anim The relevant animation.
 
 每一帧动画
 */
- (void)pop_animationDidApply:(POPAnimation *)anim;

@end


@interface NSObject (POP)

/**
 @abstract Add an animation to the reciver.
 @param anim The animation to add.
 @param key The key used to identify the animation.
 @discussion The 'key' may be any string such that only one animation per unique key is added per object.
 
 添加一个动画接收器
 “键”可以是任何字符串,这样只有一个动画每唯一键添加对象。
 */
- (void)pop_addAnimation:(POPAnimation *)anim forKey:(NSString *)key;

/**
 @abstract Remove all animations attached to the receiver.
 
 删除所有动画连接到的接收器
 */
- (void)pop_removeAllAnimations;

/**
 @abstract Remove any animation attached to the receiver for 'key'.
 @param key The key used to identify the animation.
 
 删除key的接收器
 */
- (void)pop_removeAnimationForKey:(NSString *)key;

/**
 @abstract Returns an array containing the keys of all animations currently attached to the receiver.
 @param The order of keys reflects the order in which animations will be applied.
 
 返回一个数组查看所有接收器
 */
- (NSArray *)pop_animationKeys;

/**
 @abstract Returns any animation attached to the receiver.
 @param key The key used to identify the animation.
 @returns The animation currently attached, or nil if no such animation exists.
 
 返回该key对应的对象
 */
- (id)pop_animationForKey:(NSString *)key;

@end

/**
 *  This implementation of NSCopying does not do any copying of animation's state, but only configuration.
 *  i.e. you cannot copy an animation and expect to apply it to a view and have the copied animation pick up where the original left off.
 *  Two common uses of copying animations:
 *  * you need to apply the same animation to multiple different views.
 *  * you need to absolutely ensure that the the caller of your function cannot mutate the animation once it's been passed in.
 */
@interface POPAnimation (NSCopying) <NSCopying>

@end
