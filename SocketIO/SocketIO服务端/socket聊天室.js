
/// socket聊天室服务器

// 引入http模块
var http = require('http');

// 创建Web服务器
var server = http.createServer();

// 引入socket模块
var socketIO = require('socket.io');

// 创建socket服务器
var serverSocket = socketIO(server);


// 创建房间数组
var rooms = []


// 监听是否连接成功
serverSocket.on('connection',function(clientSocket){
    // 到这里说明连接成功
    console.log('连接成功')

    // 进入房间
    clientSocket.on('joinRoom', function (room) {
        console.log('有人进入房间' + room.roomName)

        // 进入房间
        var count = rooms.length
        for (var i = 0; i < count; i++) {
            var rm = rooms[i]

            // 判断房间名是否一样
            if (rm.roomName != room.roomName) {
                rooms.push(room)
            }
        }
    })

    // 离开房间
    clientSocket.on('leaveRoom', function (roomName) {
        console.log('离开房间')

        clientSocket.leave(roomName)
    })


    // 监听消息事件
    clientSocket.on('msg', function (msg) {
        // 监听消息事件
        console.log('给' + msg.roomName + '发送' + msg.text)

        // 转发给其他段,告知,给哪个分组发送消息
        // 获取当前客户端分组
        serverSocket.to(msg.roomName).emit('msg', msg)
    })
})


// 监听服务器端号
server.listen(8080)
console.log('开始监听8080')
