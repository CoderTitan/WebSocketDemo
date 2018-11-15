

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

// 监听客户端有没有连接成功,如果连接成功,服务端会发送connection事件,通知客户端连接成功
// serverSocket: 服务端, clientSocket: 客户端
serverSocket.on('connection', function (clientSocket) {
    // 建立socket连接成功
    console.log('建立连接成功')

    // 建立聊天事件
    clientSocket.onchecking('chat', function (data) {
        // 客户端发送的数据
        // serverSocket:给所有连接到服务器的客户端发送数据
        // clientSocket:给当前客户端发送数据, 谁连接的给谁发
        clientSocket.emit('chat', 'Hello World')

        console.log(data)
    })
})


server.listen(9090)
console.log('监听9090')
