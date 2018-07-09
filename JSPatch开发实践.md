#JSPatch开发实践

## JSPatch介绍

JSPatch是一个开源的项目[Github](https://github.com/bang590/JSPatch)，只需要在项目里引入极小的引擎文件，就可以使用 JavaScript 调用任何 Objective-C 的原生接口，替换任意 Objective-C 原生方法。目前主要用于下发 JS 脚本替换原生 Objective-C 代码，实时修复线上 bug。

### 实现原理

- 为注册的新类添加方法

  ```objective-c
  Class cls = objc_allocateClassPair(superCls, "JPObject", 0);
  objc_registerClassPair(cls);

  SEL selector = NSSelectorFromString(@"setRedBackground");
  class_addMethod(cls, selector, setBlackBackground, "");

  id newVC = [[cls alloc] init];
  [self.navigationController pushViewController:newVC animated:YES];
  ```

- 替换某个类的方法为新的实现

  ```objective-c
  Class sourceClass = NSClassFromString(@"ViewController");
  id sourceControler = [[sourceClass alloc] init];
   
  SEL changeTitle = NSSelectorFromString(@"changeTitle");   
  class_replaceMethod(sourceClass, changeTitle, donotChangeTitle, "");    [sourceControler performSelector:changeTitle];
  ```

- 类名 方法名 映射 相应的类和方法

  ```objective-c
  //    生成类
  Class destinationClass = NSClassFromString(@"SecondViewController");
  id viewController = [[destinationClass alloc] init];
  //    生成方法
  SEL selector = NSSelectorFromString(@"changeBackgroundColor");
  [viewController performSelector:selector];
      
  [self.navigationController pushViewController:viewController animated:YES];
  ```

###方法调用

引入JSPatch后，可以通过以下代码创建一个UIView对象，并且设置背景颜色和透明度。涵盖了 require 引入类，JS 调用接口，消息传递，对象持有和转换，参数转换这五个方面，接下来逐一看看具体实现。

```js
require('UIView')
var view = UIView.alloc().init()
view.setBackgroundColor(require('UIColor').grayColor())
view.setAlpha(0.5)
```

####require

调用 `require('UIView')` 后，就可以直接使用 `UIView` 这个变量去调用相应的类方法了，require 做的事很简单，就是在JS全局作用域上创建一个同名变量，变量指向一个对象，对象属性 `__clsName` 保存类名，同时表明这个对象是一个 OC Class。

```js
var _require = function(clsName) {
  if (!global[clsName]) {
    global[clsName] = {
      __clsName: clsName
    }
  }
  return global[clsName]
}
```

####JS调用接口

a.`require('UIView')` 这句话在 JS 全局作用域生成了 `UIView` 这个对象，它有个属性叫 `__isCls`，表示这代表一个 OC 类。 b.调用 `UIView` 这个对象的 `alloc()` 方法，会去到 `__c()`函数，在这个函数里判断到调用者 `__isCls` 属性，知道它是代表 OC 类，把方法名和类名传递给 OC 完成调用。

b.对于一个自定义id对象，JavaScriptCore 会把这个自定义对象的指针传给 JS，这个对象在 JS 无法使用，但在回传给 OC 时 OC 可以找到这个对象。对于这个对象生命周期的管理，按我的理解如果JS有变量引用时，这个 OC 对象引用计数就加1 ，JS 变量的引用释放了就减1，如果 OC 上没别的持有者，这个OC对象的生命周期就跟着 JS 走了，会在 JS 进行垃圾回收时释放。

#### 方法替换

替换 UIViewController 的 -viewWillAppear: 方法为例：

1. 把UIViewController的 `-viewWillAppear:` 方法通过 `class_replaceMethod()` 接口指向 `_objc_msgForward`，这是一个全局 IMP，OC 调用方法不存在时都会转发到这个 IMP 上，这里直接把方法替换成这个 IMP，这样调用这个方法时就会走到 `-forwardInvocation:`。

2. 为UIViewController添加 `-ORIGviewWillAppear:` 和 `-_JPviewWillAppear:` 两个方法，前者指向原来的IMP实现，后者是新的实现，稍后会在这个实现里回调JS函数。

3. 改写UIViewController的 `-forwardInvocation:` 方法为自定义实现。一旦OC里调用 UIViewController 的 `-viewWillAppear:` 方法，经过上面的处理会把这个调用转发到 `-forwardInvocation:` ，这时已经组装好了一个 NSInvocation，包含了这个调用的参数。在这里把参数从 NSInvocation 反解出来，带着参数调用上述新增加的方法 `-_JPviewWillAppear:`，在这个新方法里取到参数传给JS，调用JS的实现函数。整个调用过程就结束了，整个过程图示如下：

   ![JSPatch方法替换](https://camo.githubusercontent.com/48cbbd8ee1c8af0ef8f18a2e0ab0d50a085afab1/687474703a2f2f626c6f672e636e62616e672e6e65742f77702d636f6e74656e742f75706c6f6164732f323031352f30362f4a535061746368322e706e67)

   ​

##JSPatch使用

### OC与JSPatch代码转换

```objective-c
//OC
@interface JPTableViewController : UITableViewController
@end
    
@interface JPTableViewController()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
    
@end
    
@implementation JPTableViewController : UITableViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
```



```js
defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
    ...
  },
})
```

































