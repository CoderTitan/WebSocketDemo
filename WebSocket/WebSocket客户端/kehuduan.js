

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


