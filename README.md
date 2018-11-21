# WebSocketDemo


- 项目包括
 - `WebSocket`原生搭建的客户端(`JavaScript`语言)
 - 使用`socket.io`框架搭建的服务端(`JavaScript`语言)
 - 使用`socket.io`框架搭建的客户端(`Swift`语言)
   - 服务端使用的是`socket.io`框架搭建的服务端
   - 客户端的框架是[Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)
   - 即时通讯消息相关页面使用的是[JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController), 虽然现在已经不再维护了


<!-- more -->

## 即时通讯

- 相关代码[Demo地址](https://github.com/CoderTitan/WebSocketDemo), 内附服务端代码和`iOS`端聊天室测试`Demo`
- 原文地址: [Socket搭建即时通讯服务器](https://www.titanjun.top/2018/11/16/Socket%E6%90%AD%E5%BB%BA%E5%8D%B3%E6%97%B6%E9%80%9A%E8%AE%AF%E6%9C%8D%E5%8A%A1%E5%99%A8/)
- 即时通讯`（Instant messaging，简称IM）`是一个终端服务，允许两人或多人使用网路即时的传递文字讯息、档案、语音与视频交流
- 即时通讯按使用用途分为企业即时通讯和网站即时通讯
- 根据装载的对象又可分为手机即时通讯和PC即时通讯，手机即时通讯代表是短信，网站、视频即时通讯

### IM通信原理

  - 客户端A与客户端B如何产生通信？客户端A不能直接和客户端B，因为两者相距太远。
  - 这时就需要通过IM服务器，让两者产生通信.
  - 客户端A通过socket与IM服务器产生连接,客户端B也通过socket与IM服务器产生连接
  - A先把信息发送给IM应用服务器，并且指定发送给B，服务器根据A信息中描述的接收者将它转发给B，同样B到A也是这样。
  - 通讯问题: 服务器是不能主动连接客户端的，只能客户端主动连接服务器




### 即时通讯连接原理
- 即时通讯都是长连接，基本上都是[HTTP1.1](https://blog.csdn.net/linsongbin1/article/details/54980801/)协议，设置`Connection`为`keep-alive`即可实现长连接，而`HTTP1.1`默认是长连接，也就是默认`Connection`的值就是`keep-alive`
- HTTP分为长连接和短连接，其实本质上是TCP连接，HTTP协议是应用层的协议，而TCP才是真正的传输层协议, IP是网络层协议，只有负责传输的这一层才需要建立连接
- 例如: 急送一个快递，HTTP协议指的那个快递单，你寄件的时候填的单子就像是发了一个HTTP请求。而TCP协议就是中间运货的运输工具，它是负责运输的，而运输工具所行驶的路就是所谓的TCP连接
- HTTP短连接（非持久连接）是指，客户端和服务端进行一次HTTP请求/响应之后，就关闭连接。所以，下一次的HTTP请求/响应操作就需要重新建立连接。
- HTTP长连接（持久连接）是指，客户端和服务端建立一次连接之后，可以在这条连接上进行多次请求/响应操作。持久连接可以设置过期时间，也可以不设置


### 即时通讯数据传递方式

目前实现即时通讯的有四种方式（短轮询、长轮询、SSE、`Websocket`）

#### 短轮询:
- 每隔一小段时间就发送一个请求到服务器，服务器返回最新数据，然后客户端根据获得的数据来更新界面，这样就间接实现了即时通信
- 优点是简单，缺点是对服务器压力较大，浪费带宽流量（通常情况下数据都是没有发生改变的）。
- 主要是客户端人员写代码，服务器人员比较简单，适于小型应用


#### 长轮询:

- 客户端发送一个请求到服务器，服务器查看客户端请求的数据(服务器中数据)是否发生了变化（是否有最新数据），如果发生变化则立即响应返回，否则保持这个连接并定期检查最新数据，直到发生了数据更新或连接超时
- 同时客户端连接一旦断开，则再次发出请求，这样在相同时间内大大减少了客户端请求服务器的次数.
- 弊端:服务器长时间连接会消耗资源，返回数据顺序无保证，难于管理维护
- 底层实现:在服务器的程序中加入一个死循环，在循环中监测数据的变动。当发现新数据时，立即将其输出给浏览器并断开连接，浏览器在收到数据后，再次发起请求以进入下一个周期

#### SSE
- （`Server-sent Events`服务器推送事件）:为了解决浏览器只能够单向传输数据到服务端，HTML5提供了一种新的技术叫做服务器推送事件SSE
- SSE技术提供的是从服务器单向推送数据给浏览器的功能，加上配合浏览器主动HTTP请求，两者结合起来,实际上就实现了客户端和服务器的双向通信.


#### WebSocket
- 以上提到的这些解决方案中，都是利用浏览器单向请求服务器或者服务器单向推送数据到浏览器
- 而在HTML5中，为了加强web的功能，提供了`websocket`技术，它不仅是一种web通信方式，也是一种应用层协议
- 它提供了浏览器和服务器之间原生的全双工跨域通信，通过浏览器和服务器之间建立`websocket`连接,在同一时刻能够实现客户端到服务器和服务器到客户端的数据发送


## WebSocket

- [WebSocket](http://websocket.org/) 是一种网络通信协议。[RFC6455](https://note.youdao.com/) 定义了它的通信标准
- `WebSocket`是一种双向通信协议，在建立连接后，`WebSocket` 服务器和客户端都能主动的向对方发送或接收数据
- `WebSocket`是基于`HTTP`协议的，或者说借用了`HTTP`协议来完成一部分握手(连接)，在握手(连接)阶段与`HTTP`是相同的,只不过`HTTP`不能服务器给客户端推送，而`WebSocket`可以


### WebSocket如何工作

- Web浏览器和服务器都必须实现`WebSockets`协议来建立和维护连接。
- 由于`WebSockets`连接长期存在，与典型的`HTTP`连接不同，对服务器有重要的影响
- 基于多线程或多进程的服务器无法适用于 `WebSockets`，因为它旨在打开连接，尽可能快地处理请求，然后关闭连接
- 任何实际的`WebSockets`服务器端实现都需要一个异步服务器


![webServer](http://pcat1usdp.bkt.clouddn.com/webServer.jpg)


#### `Websocket`协议

协议头: ws, 服务器根据协议头判断是`Http`还是`websocket`

```js
// 请求头
     GET ws://localhost:12345/websocket/test.html HTTP/1.1
     Origin: http://localhost
     Connection: Upgrade
     Host: localhost:12345
     Sec-WebSocket-Key: JspZdPxs9MrWCt3j6h7KdQ==  
     Upgrade: websocket 
     Sec-WebSocket-Version: 13
    // Sec-WebSocket-Key: 叫“梦幻字符串”是个密钥，只有有这个密钥 服务器才能通过解码认出来，这是个WB的请求，要建立TCP连接了！！！如果这个字符串没有按照加密规则加密，那服务端就认不出来，就会认为这整个协议就是个HTTP请求。更不会开TCP。其他的字段都可以随便设置，但是这个字段是最重要的字段，标识WB协议的一个字段
     

// 响应头
     HTTP/1.1 101 Web Socket Protocol Handshake
     WebSocket-Location: ws://localhost:12345/websocket/test.php
     Connection: Upgrade
     Upgrade: websocket
     Sec-WebSocket-Accept: zUyzbJdkVJjhhu8KiAUCDmHtY/o= 
     WebSocket-Origin: http://localhost
     
    // Sec-WebSocket-Accept: 叫“梦幻字符串”，和上面那个梦幻字符串作用一样。不同的是，这个字符串是要让客户端辨认的，客户端拿到后自动解码。并且辨认是不是一个WB请求。然后进行相应的操作。这个字段也是重中之重，不可随便修改的。加密规则，依然是有规则的
```


### WebSocket客户端
在客户端，没有必要为`WebSockets`使用`JavaScript`库。实现`WebSockets`的`Web` 浏览器将通过`WebSockets`对象公开所有必需的客户端功能（主要指支持`HTML5`的浏览器）

#### 客户端 API

以下 API 用于创建`WebSocket`对象。

```js
var Socket = new WebSocket(url, [protocol] );
```

- 以上代码中的第一个参数`url`, 指定连接的`URL`
- 第二个参数`protocol`是可选的，指定了可接受的子协议


#### WebSocket属性

以下是`WebSocket`对象的属性。假定我们使用了以上代码创建了`Socket`对象

- `Socket.readyState`: 只读属性`readyState`表示连接状态, 可以是以下值
  - 0 : 表示连接尚未建立
  - 1 : 表示连接已建立，可以进行通信
  - 2 : 表示连接正在进行关闭
  - 3 : 表示连接已经关闭或者连接不能打开。
- `Socket.bufferedAmount`: 只读属性`bufferedAmount`
  - 表示已被`send()` 放入正在队列中等待传输，但是还没有发出的`UTF-8`文本字节数


#### WebSocket事件

以下是`WebSocket`对象的相关事件。假定我们使用了以上代码创建了`Socket` 对象：

事件 |	事件处理程序 |	描述
--|--|--
open |	Socket.onopen |	连接建立时触发
message |	Socket.onmessage |	客户端接收服务端数据时触发
error |	Socket.onerror |	通信发生错误时触发
close |	Socket.onclose |	连接关闭时触发


#### WebSocket方法

以下是`WebSocket`对象的相关方法。假定我们使用了以上代码创建了`Socket`对象：

方法 |	描述
--|--
Socket.send() |	使用连接发送数据
Socket.close() |	关闭连接


#### 示例

```js
// 客户端
var socket = new WebSocket("ws://localhost:9090")

// 建立 web socket 连接成功触发事件
socket.onopen = function () {
    // 使用send发送数据
    socket.send("发送数据")
    console.log(socket.bufferedAmount)
    alert('数据发送中')
}

// 接受服务端数据是触发事件
socket.onmessage = function (evt) {
    var received_msg = evt.data
    alert('数据已经接受..')
}

// 断开 websocket 连接成功触发事件
socket.onclose = function () {
    alert('链接已经关闭')
    console.log(socket.readyState)
}

```


### WebSocket服务端

`WebSocket`在服务端的实现非常丰富。`Node.js`、`Java`、`C++`、`Python` 等多种语言都有自己的解决方案, 其中`Node.js`常用的有以下三种

- [µWebSockets](https://github.com/uNetworking/uWebSockets)
- [Socket.IO](https://socket.io/)
- [WebSocket-Node](https://github.com/theturtle32/WebSocket-Node)

下面就着重研究一下`Socket.IO`吧, 因为别的我也不会, 哈哈哈哈......


## `Socket.IO`

- [Socket.IO](https://github.com/socketio)是一个库，可以在浏览器和服务器之间实现实时，双向和基于事件的通信
- [Socket.IO](https://github.com/socketio)是一个完全由`JavaScript`实现、基于`Node.js`、支持`WebSocket`的协议用于实时通信、跨平台的开源框架
- [Socket.IO](https://github.com/socketio)包括了客户端(`iOS,Android`)和服务器端(`Node.js`)的代码，可以很好的实现iOS即时通讯技术
- [Socket.IO](https://github.com/socketio)支持及时、双向、基于事件的交流，可在不同平台、浏览器、设备上工作，可靠性和速度稳定
- [Socket.IO](https://github.com/socketio)实际上是`WebSocket`的父集，`Socket.io`封装了`WebSocket`和轮询等方法，会根据情况选择方法来进行通讯
- 典型的应用场景如：
  - 实时分析：将数据推送到客户端，客户端表现为实时计数器、图表、日志客户
  - 实时通讯：聊天应用
  - 二进制流传输：`socket.io`支持任何形式的二进制文件传输，例如图片、视频、音频等
  - 文档合并：允许多个用户同时编辑一个文档，并能够看到每个用户做出的修改


###  Socket.IO服务端
- [Socket.IO](https://github.com/socketio)实质是一个库, 所以在使用之前必须先导入`Socket.IO`库
- `Node.js`导入库和`iOS`导入第三方库性质一样, 只不过`iOS`使用的是`pods`管理, `Node.js`使用`npm`

#### 导入`Socket.IO`库
 
```
// 1. 进入当当前文件夹
cd ...

// 2. 创建package.json文件
npm init

/// 3. 导入库
npm install socket.io --sava
npm install express --sava
```


#### 创建socket

- `socket`本质还是`http`协议，所以需要绑定`http`服务器，才能启动socket服务.
- 而且需要通过`web`服务器监听端口，`socket`不能监听端口，有人访问端口才能建立连接，所以先创建`web`服务器

```js
// 引入http模块
var http = require('http')

// 面向express框架开发，加载express框架，方便处理get,post请求
var express = require('express')

// 创建web服务器
var server = http.Server(express)

// 引入socket.io模块
var socketio = require('socket.io')

// 创建爱你socket服务器
var serverSocket = socketio(server)


server.listen(9090)
console.log('监听9090')
```


#### 建立socket连接

- 服务器不需要主动建立连接，建立连接是客户端的事情，服务器只需要监听连接
- 客户端主动连接会发送`connection`事件，服务端只需要监听`connection`事件有没有发送，就知道客户端有没有主动连接服务器
- `Socket.IO`本质是通过发送和接受事件触发服务器和客户端之间的通讯，任何能被编辑成`JSON`或二进制的对象都可以传递
- `socket.on`: 监听事件，这个方法会有两个参数，第一个参数是事件名称，第二个参数是监听事件的回调函数，监听到链接就会执行这个回调函数
- 监听`connection`，回调函数会传入一个连接好的`socket`，这个`socket`就是客户端的`socket`
- `socket`连接原理，就是客户端和服务端通过`socket`连接，服务器有`socket`，客户端也有


```js
// 监听客户端有没有连接成功,如果连接成功,服务端会发送connection事件,通知客户端连接成功
// serverSocket: 服务端, clientSocket: 客户端
serverSocket.on('connection', function (clientSocket) {
    // 建立socket连接成功
    console.log('建立连接成功')

    console.log(clientSocket)
})
```

### Socket.IO客户端

- [Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)是`iOS`使用的库, 目前只有`Swift`版本
- iOS中的使用

#### 创建socket对象

创建`SocketIOClient`对象, 两种创建方式

```swift
// 第一种, SocketIOClientConfiguration: 可选参数
public init(socketURL: URL, config: SocketIOClientConfiguration = [])

// 第二种, 底层还是使用的第一种方式创建
public convenience init(socketURL: URL, config: [String: Any]?) {
        self.init(socketURL: socketURL, config: config?.toSocketConfiguration() ?? [])
}
```


- `SocketIOClientConfiguration`: 是一个数组, 等同于`[SocketIOClientOption]`
- `SocketIOClientOption`的所有取值如下


```swift
public enum SocketIOClientOption : ClientOption {
    /// 使用压缩的方式进行传输
    case compress
    /// 通过字典内容连接
    case connectParams([String: Any])
    /// NSHTTPCookies的数组, 在握手过程中传递, Default is nil.
    case cookies([HTTPCookie])
    /// 添加自定义请求头初始化来请求, 默认为nil
    case extraHeaders([String: String])
    /// 将为每个连接创建一个新的connect, 如果你在重新连接有bug时使用.
    case forceNew(Bool)
    /// 传输是否使用HTTP长轮询, 默认false
    case forcePolling(Bool)
    /// 是否使用 WebSockets. Default is `false`
    case forceWebsockets(Bool)
    /// 调度handle的运行队列, 默认在主队列
    case handleQueue(DispatchQueue)
    /// 是否打印调试信息. Default is false
    case log(Bool)
    /// 可自定义SocketLogger调试日志
    case logger(SocketLogger)
    /// 自定义服务器使用的路径.
    case path(String)
    /// 链接失败时, 是否重新链接, Default is `true`
    case reconnects(Bool)
    /// 重新连接多少次. Default is `-1` (无限次)
    case reconnectAttempts(Int)
    /// 等待重连时间. Default is `10`
    case reconnectWait(Int)
    /// 是否使用安全传输, Default is false
    case secure(Bool)
    /// 设置允许那些证书有效
    case security(SSLSecurity)
    /// 自签名只能用于开发模式
    case selfSigned(Bool)
    /// NSURLSessionDelegate 底层引擎设置. 如果你需要处理自签名证书. Default is nil.
    case sessionDelegate(URLSessionDelegate)
}
```

创建`SocketIOClient`

```swift
// 注意协议：ws开头
guard let url = URL(string: "ws://localhost:9090") else { return }
let manager = SocketManager(socketURL: url, config: [.log(true), .compress])
// SocketIOClient
let socket = manager.defaultSocket
```


#### 监听连接

- 创建好`socket`对象,然后连接用`connect`方法
- 因为`socket`需要进行3次握手，不可能马上建议连接，需要监听是否连接成功的回调,使用`on`方法
- `ON`方法两个参数
  - 参数一: 监听的事件名称，参数二：监听事件回调函数，会自动调用
  - 回调函数也有两个参数(参数一：服务器传递的数据 参数二:确认请求数据`ACK`)
  - 在`TCP/IP`协议中，如果接收方成功的接收到数据，那么会回复一个`ACK`数据- `ACK`只是一个标记，标记是否成功传输数据


```swift
// 回调闭包
public typealias NormalCallback = ([Any], SocketAckEmitter) -> ()

// on方法
@discardableResult
open func on(_ event: String, callback: @escaping NormalCallback) -> UUID

// SocketClientEvent: 接受枚举类型的on方法
@discardableResult
open func on(clientEvent event: SocketClientEvent, callback: @escaping NormalCallback) -> UUID {
    // 这里调用的是上面的on方法
    return on(event.rawValue, callback: callback)
}
```

> 完整代码

```swift
guard let url = URL(string: "ws://localhost:9090") else { return }

let manager = SocketManager(socketURL: url, config: [.log(true), .compress])
let socket = manager.defaultSocket

// 监听链接成功
socket.on(clientEvent: .connect) { (data, ack) in
    print("链接成功")
    print(data)
    print(ack)
}
        
socket.connect()
```


### SocketIO事件

`SocketIO`通过事件链接服务器和传递数据


#### 客户端监听事件

```swift
// 监听链接成功
socket.on(clientEvent: .connect) { (data, ack) in
    print("链接成功")
    print(data)
    print(ack)
}
```

#### 客户端发送事件

只有连接成功之后，才能发送事件

```swift
// 建立一个连接到服务器. 连接成功会触发 "connect"事件
open func connect()

// 连接到服务器. 如果连接超时,会调用handle
open func connect(timeoutAfter: Double, withHandler handler: (() -> ())?)

// 重开一个断开连接的socket
open func disconnect()

// 向服务器发送事件, 参数一: 事件的名称，参数二: 传输的数据组
open func emit(_ event: String, with items: [Any])
```

#### 服务器监听事件

- 监听客户端事件，需要嵌套在连接好的`connect`回调函数中
- 必须使用回调函数的`socket`参数，如`function(s)`中的s，监听事件,因此这是客户端的`socket`，肯定监听客户端发来的事件
- 服务器监听连接的回调函数的参数可以添加多个，具体看客户端传递数据数组有几个，每个参数都是与客户段一一对应，第一个参数对应客户端数组第0个数据


```js
// 监听socket连接
socket.on('connection',function(s){

    console.log('监听到客户端连接');

    // data:客户端数组第0个元素
    // data1:客户端数组第1个元素
    s.on('chat',function(data,data1){

        console.log('监听到chat事件');

        console.log(data,data1);
        
    });
});
```

#### 服务器发送事件

这里的`socket`一定要用服务器端的`socket`

```js
// 给当前客户端发送数据，其他客户端收不到.
socket.emit('chat', '服务器' + data)

// 发给所有客户端，不包含当前客户端
socket.emit.broadcast.emit('chat', '发给所有客户端,不包含当前客户端' + data)

// 发给所有客户端，包含当前客户端
socket.emit.sockets.emit('chat', '发给所有客户端,包含当前客户端' + data)
```


## SocketIO分组

- 每一个客户端和服务器只会保持一个`socket`链接, 那么怎么吧每一条信息推送到对应的聊天室, 针对多个聊天室的问题有如何解决
- 给每个聊天室都分组, 服务器就可以给指定的组进行数据的推送, 就不会影响到其他的聊天室

### 如何分组

 - `socket.io`提供[rooms和namespace的API](https://socket.io/docs/rooms-and-namespaces/)
 - 用`rooms`的API就可以实现多房间聊天了，总结出来无外乎就是：`join/leave room` 和 `say to room`
 - 这里的`socket`是客户端的`socket`，也就是连接成功，传递过来的`socket`


```js
// join和leave
io.on('connection', function(socket){
  socket.join('some room');
  // socket.leave('some room');
});
 
// say to room
io.to('some room').emit('some event'):
io.in('some room').emit('some event'):
```

### 分组的原理

- 只要客户端`socket`调用`join`，服务器就会把客户端`socket`和分组的名称绑定起来
- 到时候就可以根据分组的名称找到对应客户端的`socket`，就能给指定的客户端推送信息
- 一个客户端`socket`只能添加到一组，离开的时候，要记得移除

