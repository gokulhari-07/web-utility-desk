/* 
🧩 What is JS Interop?

JS interop (JavaScript interoperability) simply means:

Dart code and JavaScript code can call each other and share data.

Because Flutter Web apps run inside a browser, and the browser’s native language is JavaScript, JS interop acts as the “bridge” that connects:

Dart (Flutter code)

JavaScript running in the browser

So instead of using platform channels (which are only for Android/iOS), Flutter Web uses JavaScript interop to communicate with the underlying browser or external JS libraries.

📦 Why does Flutter Web need JS Interop?

Because Flutter Web is compiled into JavaScript, but:

You might want to use browser APIs that Dart doesn't provide
Example: localStorage, clipboard, fullscreen API, geolocation

You might want to use existing JS libraries
Example: Google Maps JS API, Chart.js, Firebase JS SDK

You might want to write your own JS functions for custom logic

JS interop allows all of this.

🔍 Real-world meaning (simple analogy)

Imagine:

Dart is one person

JavaScript is another

They speak different languages

JS interop is a translator between them.

Dart can say:
→ “Please call that JavaScript function and return the result.”

JavaScript can say:
→ “Hey Dart, run this function when I tell you.”

🧠 How does it technically work?

When you write Flutter Web code:

Dart gets compiled to JavaScript

Your external JS file also runs in the browser

The dart:js_interop API links the two worlds using annotations & bindings

Dart example:

@JS('greetFromJS')
external String greetFromJS();


This tells Flutter:

"When I call greetFromJS(), actually call the JS function named greetFromJS."

🧭 In simple words:
JS interop = the way Flutter Web talks to JavaScript (the browser’s native language).
*/


import 'dart:js_interop';

@JS('greetFromJs') //@JS('functionName') tells Dart which JS function to call.
external String greetFromJsDartFn(); //external means the function exists outside Dart (in JS).

@JS("addNumbers")
external int addNumbersDartFn(int a, int b);

