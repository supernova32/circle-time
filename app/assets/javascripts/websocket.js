//= require fabric.min

var my_id;

function xinspect(obj){
    var str = "";
    for(var k in obj)
        if (obj.hasOwnProperty(k)) //omit this test if you want to see built-in properties
            str += k + " = " + obj[k] + "\n";
    return str;
}

var dispatcher = new WebSocketRails('circle.patriciocano.me:3001/websocket');
dispatcher.on_open = function(data) {
    console.log('Connection has been established: ' + xinspect(data));
};

dispatcher.bind('connection_accepted', function(data){
    console.log('Registering new circle');
    dispatcher.trigger('register_circle');
});

dispatcher.bind('new_circle_broadcast', function(data){
    console.log('Received new circle: ' + xinspect(data));
    dispatcher.trigger('get_circles');
});

dispatcher.bind('my_id', function(data){
    console.log('Received my id: '+ data);
    my_id = data;
});
dispatcher.bind('circle_disconnected', function(data){
    console.log('Circle disconnected. ID: ' + data);
    dispatcher.trigger('get_circles');
});
dispatcher.bind('new_position', function(data){
    console.log('Received new circle position: ' + xinspect(data));
    dispatcher.trigger('get_circles');
});
var canvas;
var circle;
var dx = 10;
var dy = 10;
var x = 250;
var y = 250;
var WIDTH = 500;
var HEIGHT = 500;
var colors = ['yellow', 'orange', 'green', 'red', 'grey', 'brown', 'black'];

function init() {
    canvas = new fabric.Canvas('canvas');
    canvas.selection = false;
    circle = new fabric.Circle({
        left: x,
        top: y,
        fill: 'purple',
        width: 10,
        height: 10,
        radius: 5
    });
    circle.set('selectable', false);
    canvas.add(circle);
    dispatcher.trigger('get_circles');
}

dispatcher.bind('all_circles', function(data){
    canvas.clear();
    for (var i = 0; i < data.length; i++) {
        var circle;
        if (data[i].id != my_id) {
            circle = new fabric.Circle({
                left: data[i].position_x,
                top: data[i].position_y,
                fill: colors[i % colors.length],
                width: 10,
                height: 10,
                radius: 5
            });
        } else {
            circle = new fabric.Circle({
                left: data[i].position_x,
                top: data[i].position_y,
                fill: 'purple',
                width: 10,
                height: 10,
                radius: 5
            });
        }
        circle.set('selectable', false);
        canvas.add(circle);
    }
});

function doKeyDown(evt){
    switch (evt.keyCode) {
        case 38:  /* Up arrow was pressed */
            if (y - dy > 0){
                y -= dy;
            }
            break;
        case 40:  /* Down arrow was pressed */
            if (y + dy < HEIGHT){
                y += dy;
            }
            break;
        case 37:  /* Left arrow was pressed */
            if (x - dx > 0){
                x -= dx;
            }
            break;
        case 39:  /* Right arrow was pressed */
            if (x + dx < WIDTH){
                x += dx;
            }
            break;
    }
    var position = {
        position_x: x,
        position_y: y,
        id: my_id
    };
    dispatcher.trigger('update_circle', position);
}

init();
window.addEventListener('keydown',doKeyDown,true);
