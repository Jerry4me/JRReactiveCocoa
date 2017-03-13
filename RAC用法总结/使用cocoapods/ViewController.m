//
//  ViewController.m
//  使用cocoapods
//
//  Created by sky on 2016/11/22.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

/** command */
@property (nonatomic, strong) RACCommand *command;
/** subject */
@property (nonatomic, strong) RACSubject *subject;

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self RACSignal];
    
    
}


#pragma mark - ReactiveCocoa操作方法之重复
// retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
- (void)retry
{
    __block int count = 1;
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (count == 10) {
            [subscriber sendNext:@"success"];
        } else {
            [subscriber sendError:nil];
        }
        
        ++count;
        
        return nil;
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"成功, %@", x);
        
    } error:^(NSError *error) {
    
    }];
}

// replay重放：当一个信号被多次订阅,反复播放内容
- (void)replay
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"helio"];
        [subscriber sendNext:@"process"];
        
        [subscriber sendCompleted];
        
        return nil;
        
    }] replay];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者1 - %@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者2 - %@", x);
    }];
    
}

// throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
- (void)throttle
{
    RACSubject *subject = [RACSubject subject];
    
    self.subject = subject;
    
    // 节流，2秒内，不接收任何信号内容，2秒后获取最后发送的信号内容发出
    [[subject throttle:2.0] subscribeNext:^(id x) {
        NSLog(@"%@", x); // 2秒后才会打印 helio
    }];
    
    [subject sendNext:@"helio"];
    
}

#pragma mark - ReactiveCocoa操作方法之时间
// timeout：超时，可以让一个信号在一定的时间后，自动报错。
- (void)timeout
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
//        [subscriber sendNext:@"helio"];
//        [subscriber sendCompleted];
        
        return nil;
        
    }] timeout:2 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {// 2秒后还没有有信号到, 就会自动调用
        NSLog(@"%@", error);
    }];
}

// interval 定时：每隔一段时间发出信号
- (void)interval
{
    
    [[RACSignal interval:2.0 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) { // 每隔2秒就调用一次这个block
        NSLog(@"%@", x);
    }];
}

// delay 延迟发送next。
- (void)delay
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        [subscriber sendNext:@"helio"];
        [subscriber sendCompleted];
        
        return nil;
        
    }] delay:2.0] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - ReactiveCocoa操作方法之线程
// subscribeOn: 内容传递和副作用都会切换到制定线程中
- (void)subscribeOn
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) { // 该block在新线程中调用
        
        NSLog(@"副作用 - %@", [NSThread currentThread]);
        
        [subscriber sendNext:@"helio"];
        
        [subscriber sendCompleted];
        
        return nil;
    }] subscribeOn:[RACScheduler scheduler]];
    
    [signal subscribeNext:^(id x) { // 该block在新的线程中调用
        NSLog(@"%@ - %@", x, [NSThread currentThread]);
    }];
}

// deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用
- (void)deliverOn
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) { // 该block在当前线程(主线程)调用
        
        [subscriber sendNext:@"helio"];
        
        [subscriber sendCompleted];
        
        return nil;
    }] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault name:@"哟西嘿咻"]]; // 把信号派发到新线程中
    
    [signal subscribeNext:^(id x) { // 该block在新的线程中调用
        NSLog(@"%@", x);
    }];
}

#pragma mark - ReactiveCocoa操作方法之秩序
// doNext : 执行sendNext之前会调用
// doCompleted : 执行sendCompleted之前会调用
- (void)doNextAndDoCompleted
{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"helio"];
        
        [subscriber sendCompleted];
        
        return nil;
        
    }] doNext:^(id x) {
        NSLog(@"sendNext之前调用");
    }] doCompleted:^{
        NSLog(@"sendCompleted之前调用");
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 打印顺序 : sendNext之前调用 -> helio -> sendCompleted之前调用
}

#pragma mark - ReactiveCocoa操作方法之过滤

// switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
- (void)switchToLatest
{
    RACSubject *signalOfSignals = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    RACSubject *signal2 = [RACSubject subject];
    
    [signalOfSignals.switchToLatest subscribeNext:^(id x) { // 订阅最近发送的信号
        NSLog(@"%@", x);
    }];
    [signalOfSignals sendNext:signal2];
    
    [signalOfSignals sendNext:signal];
    
    [signal sendNext:@"intel"];
    [signal2 sendNext:@"helio"];
    
    // 打印intel
}

// skip:(NSUInteger):跳过几个信号,不接受。
- (void)skip
{
    [[self.textField.rac_textSignal skip:3] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// takeUntil:(RACSignal *):获取信号直到某个信号执行完成
- (void)takeUntil
{
    // 一直获取textField的信号直到loginBtn被销毁
    [self.textField.rac_textSignal takeUntil:self.loginBtn.rac_willDeallocSignal];
}

// takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
- (void)takeLast
{
    RACSubject *signal = [RACSubject subject];
    
    [[signal takeLast:3] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [signal sendNext:@"one"];
    [signal sendNext:@"two"];
    [signal sendNext:@"three"];
    [signal sendNext:@"four"];
    [signal sendNext:@"five"];
    [signal sendNext:@"six"];
    [signal sendNext:@"seven"];
    
    [signal sendCompleted]; // 必须要调用这个, 否则不知道一共有多少信号
}

// take:从开始一共取N次的信号
- (void)take
{
    RACSubject *signal = [RACSubject subject];
    
    [[signal take:5] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [signal sendNext:@"one"];
    [signal sendNext:@"two"];
    [signal sendNext:@"three"];
    [signal sendNext:@"four"];
    [signal sendNext:@"five"];
    [signal sendNext:@"six"];
    [signal sendNext:@"seven"];
}

// distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
- (void)distinctUntilChanged
{
    // 过滤，当上一次和当前的值不一样，就会发出内容。
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    
    [[self.textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// ignore:忽略完某些值的信号.
- (void)ignore
{
    [[self.textField.rac_textSignal ignore:@"tracy"] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// filter:过滤信号，使用它可以获取满足条件的信号.
- (void)filter
{
    [[self.textField.rac_textSignal filter:^BOOL(id value) {
        return [value length] > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - ReactiveCocoa操作方法之组合
// reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
- (void)reduce
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
        
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        
        return nil;
        
    }];
    
    RACSignal *combineSignal = [[RACSignal combineLatest:@[signal1, signal2] reduce:^id(NSNumber *num1, NSNumber *num2){
        
        return [NSString stringWithFormat:@"%@ - %@", num1, num2];
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    
}


// combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
- (void)combineLatest
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
        
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        
        return nil;
        
    }];
    
    RACSignal *combineSignal = [signal1 combineLatestWith:signal2];
    
    [combineSignal subscribeNext:^(id x) {
        NSLog(@"%@", x); // 打印出一个RACTuple对象
    }];
}

// zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
- (void)zipWith
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    RACSignal *zipSignal = [signal1 zipWith:signal2];
    
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@", x); // 打印出一个RACTuple对象
    }];
}

// merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
- (void)merge
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    RACSignal *mergeSignal = [signal1 merge:signal2];
    
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    
}

// then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
- (void)then
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted]; // 只有当该信号发送完成了才会创建下面then的block中的信号
        
        return nil;
        
    }] then:^RACSignal *{
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"helio"];
            
            [subscriber sendCompleted];
            
            return nil;
            
        }];
        
    }] subscribeNext:^(id x) { // 这里订阅的只是then中block返回的信号
        NSLog(@"%@", x);
    }];
}

// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (void)concat
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"tracy"];
        
        [subscriber sendCompleted];
        
        return nil;
        
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"mcgrady"];
        
        [subscriber sendCompleted];
        
        return nil;
        
    }];
    
    // 拼接的信号
    // 第一个信号不发出completed, 第二个信号就不会发送信息
    RACSignal *concatSignal = [signal1 concat:signal2];
    
    
    [concatSignal subscribeNext:^(id x) {
       
        NSLog(@"%@", x);
        
    }];
    
    
}


#pragma mark - different between map and flattenMap
/*
 * map中的block返回对象
 * flattenMap中的block返回信号
 * 开发中, 如果信号发出的值不是信号, 则用map
 * 开发中, 如果信号发出的值是信号, 则用flattenMap
 * 也就是说, signal of signals, 用flattenMap!
 */

- (void)mapAndFlattenMap
{
    RACSubject *signalOfSignals = [RACSubject subject];
    
    signalOfSignals.name = @"信号的信号";
    
    RACSubject *signal = [RACSubject subject];
    
    signal.name = @"信号";
    
    [[signalOfSignals flattenMap:^RACStream *(id value) {
        
       // 信号的信号发出信号时就会调用这个block
       
       return value;
        
    }] subscribeNext:^(id x) {
    
        // 信号的信号发出的信号发生改变时会调用这个block
    
        NSLog(@"%@", x);
    }];
    
    [signal sendNext:@"before"]; // 不会打印
    [signalOfSignals sendNext:signal];
    [signal sendNext:@"after"]; // 会打印
}

// Map作用:把源信号的值映射成一个新的值
- (void)map
{
    [[self.textField.rac_textSignal map:^id(id value) {
        
        
        return [NSString stringWithFormat:@"map : %@", value];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
- (void)flattenMap
{
    [[self.textField.rac_textSignal flattenMap:^RACStream *(id value) {
        
        // 信号发生改变的时候就会调用这个block
        
        // 在block里处理信号, 返回信号
        
        
        return [RACReturnSignal return:[NSString stringWithFormat:@"FlattenMap : %@", value]];
        
    }] subscribeNext:^(id x) {
    
        // 绑定源信号, 信号处理之后就会调用这个block
        
        NSLog(@"%@", x);
    }];
}

#pragma mark

// 信号绑定, [signal bind]
- (void)signalBinding
{
    [[self.textField.rac_textSignal bind:^RACStreamBindBlock{
        
        // block表示绑定一个信号
        
        return ^RACStream *(id value, BOOL *stop){
        
            // 当信号有新的值发出, 就会调用这个block
            
            // block 作用 : 做返回值的处理
            
//            if ([value isEqualToString:@"tracy"]) *stop = YES;
            
            return [RACReturnSignal return:[NSString stringWithFormat:@"处理后 : %@", value]];
            
        };
    }] subscribeNext:^(id x) {
        
        // 信号处理完就会调用这个block
        
        NSLog(@"%@", x);
    }];
}

// 用户名与密码的检验, 少于5位数 loginBtn不可按
- (void)bindingAccountAndPwd
{
    @weakify(self)
    [[RACSignal combineLatest:@[self.accountField.rac_textSignal, self.pwdField.rac_textSignal]] subscribeNext:^(RACTuple *x) {
        
        @strongify(self)
        
        NSString *account = [x first];
        NSString *pwd = [x second];
        
        self.loginBtn.enabled = account.length >= 5 && pwd.length >= 5;
        
    }];
    
}

// RAC常见宏用法
- (void)commonRACMacro
{
    // 绑定某个对象的某个属性
    // textField.text改变 -> btn.titleLabel.text跟着改变
    RAC(self.btn.titleLabel, text) = self.textField.rac_textSignal;
    
    // 监听某个对象的某个属性
    [RACObserve(self.btn.titleLabel, text) subscribeNext:^(id x) {
        NSLog(@"text = %@", x);
    }];
    
    // @weakify(obj) 和 @strongify(obj) 需要配对使用
    // 需手动导入RACEXTScope.h
    @weakify(self)
    
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        
        self.view.backgroundColor = [UIColor blueColor];
        
        return nil;
        
    }];
    
    // 将数据包装成RACTuple元组类
    RACTuple *tuple = RACTuplePack(@"xdq", @21);
    
    // 解包元组, 会把元组的值, 按顺序给参数里面的变量赋值
    RACTupleUnpack(NSString *name, NSNumber *age) = tuple;
    /* 相当于 name = @"xdq", age = @21 */
    
    
}

// RAC常见用法
- (void)commonRACUsage
{
    // 代替代理 : 调用jmp2orangevc:的同时调用这个block
    [[self rac_signalForSelector:@selector(jmp2orangevc:)] subscribeNext:^(id x) {
        NSLog(@"点击了按钮哦呵呵哒");
    }];
    
    // KVO : 对象的某个值改变了调用这个KVO
    [[self.btn rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 监听事件 : 某个控件的某个触摸事件发生了调用这个block
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了, 给我监听到了");
    }];
    
    // 监听通知 : 收到了通知就会调用这个block
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    // 监听文本框文字改变
    [[self.textField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"文本框发生改变 - %@", x);
    }];
    
    // 处理多个请求, 都有结果返回的时候统一做处理
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [subscriber sendNext:@"发送请求1"];
       
       return nil;
    }];
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [subscriber sendNext:@"发送请求2"];
       
       return nil;
    }];
    
    [self rac_liftSelector:@selector(updateWithR1:R2:) withSignalsFromArray:@[request1, request2]];
}

- (void)updateWithR1:(id)data1 R2:(id)data2
{
    NSLog(@"更新UI - %@ - %@", data1, data2);
}

// RACMulticastConnection
- (void)RACMulticastConnection
{
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"发送订阅请求");
//        
//        return nil;
//    }];
//    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"接受数据");
//    }];
//    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"接收数据");
//    }];
    /*  以上会打印两次 @"发送订阅请求"  */
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求");
        
        [subscriber sendNext:@"helio"];
        
        return nil;
    }];
    
    // 创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 订阅信号
    [connect.signal subscribeNext:^(id x) {
       NSLog(@"订阅者-信号");
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者-信号2");
    }];
    
    // 连接, 激活信号
    [connect connect];
    
    
}

// RACCommand
- (void)RACCommand
{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) { // 执行[command execute:] 就会调用这个block
    
        NSLog(@"执行命令");
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    self.command = command;
    
    [self.command execute:nil];
    
    [self.command.executionSignals.switchToLatest subscribeNext:^(id x) {
    
        NSLog(@"%@", x);
    }];

    // 用于signal of signals, 直接获取最新发出的信号, 也就是RACCommand的信号
//    [self.command.executionSignals.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//        
//    }];
    
    // 监听命令是否执行完毕
    [[command.executing skip:1] subscribeNext:^(id x) {
       if([x boolValue] == YES) {
        NSLog(@"正在执行");
       } else {
        NSLog(@"执行完成");
       }
    }];
}

// 字典转模型
- (void)dict2model
{
    // 字典转模型
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSArray *models = [[array.rac_sequence map:^id(id value) {
        
//        return [Model modelWithDict:value];
        return nil;
    }] array];
}

// 遍历字典
- (void)enumerateDict
{
    NSDictionary *dict = @{@"jack" : @"21", @"rose" : @"22", @"jones" : @"18"};
    
    [dict.rac_sequence.signal subscribeNext:^(id x) {
       // 解包元组
       
       
       RACTupleUnpack(NSString *key, NSString *value) = x;
       
       NSLog(@"key = %@, value = %@", key, value);
       
    }];
}

// 遍历数组
- (void)enumerateArray
{
    
    NSArray *array = @[@1, @2, @3, @4];
    
    // 数组 -> RACSequence
    RACSequence *sequence = array.rac_sequence;
    
    // RACSequence -> RACSignal
    RACSignal *signal = sequence.signal;
    
    // 订阅, 遍历数组
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// 使用RACReplaySubject
- (void)RACReplaySubject
{
    RACReplaySubject *rs = [RACReplaySubject subject];
    
    // 使用方法类似RACSubject
    // 如果想要订阅一个信号的时候就重复播放之前的所有值, 就必须先发送再订阅
    
    [rs subscribeNext:^(id x) {
        NSLog(@"one = %@", x);
    }];
    
    [rs sendNext:@"偶嗨哟"];
    [rs sendNext:@"噢啦是哟"];
    [rs sendNext:@"fxxk durant"];
    
    [rs subscribeNext:^(id x) {
        NSLog(@"two = %@", x);
    }];
}


// 使用RACSubject
- (void)RACSubject
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id x) { // 第一个订阅者
        NSLog(@"one = %@", x);
    }];
    
    [subject subscribeNext:^(id x) { // 第二个订阅者
        NSLog(@"two = %@", x);
    }];
    
    // 发送信号
    [subject sendNext:@"哦和"];
    
    [subject sendNext:@"和和"];
}


// 使用RACSignal
- (void)RACSignal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"创建");
        
        [subscriber sendNext:@"data"];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
           NSLog(@"销毁");
        }];
    }];
    
    
    [signal subscribeNext:^(id x) { // 第一个订阅者
        NSLog(@"id = %@", x);
    }];
    
    [signal subscribeNext:^(id x) { // 第二个订阅者
        NSLog(@"id2 = %@", x);
    }];
    
    /*
        控制台输出为 :
         2017-03-13 15:48:09.632 使用cocoapods[41347:10397774] 创建
         2017-03-13 15:48:09.634 使用cocoapods[41347:10397774] id = data
         2017-03-13 15:48:09.636 使用cocoapods[41347:10397774] 销毁
         2017-03-13 15:48:09.637 使用cocoapods[41347:10397774] 创建
         2017-03-13 15:48:09.638 使用cocoapods[41347:10397774] id2 = data
         2017-03-13 15:48:09.639 使用cocoapods[41347:10397774] 销毁
         
         由此可见有多个订阅者订阅了该信号源的话, 就会多次调用信号源block中的方法, 产生副作用
    */
    
}

- (IBAction)jmp:(id)sender {

    TwoViewController *two = [[TwoViewController alloc] init];
    
    [self presentViewController:two animated:YES completion:nil];
}




@end
