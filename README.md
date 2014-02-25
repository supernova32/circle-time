# Circle Time

This small Rails application is intended as a small test of websockets & real-time
communication between different clients.

Once you start the application, and open it in a web browser you will see a small
purple circle. This is you. You can use your keyboard arrows to move the circle
around. If another person opens the same URL, you will immediately see them on your
browser as a circle with a different color. Every movement is broadcasted to all connected
clients.

It is based upon the great `websocket-rails` gem and uses Fabric.JS to simplify the
drawing of each circle in the canvas.

In order to run the application, you need to install `MongoDB`, since all the record
keeping is done with `Mongoid`.
