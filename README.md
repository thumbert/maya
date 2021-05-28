# Maya

A modern commodity pricing user interface

## Getting Started

To build: ```flutter build web```

Start a python server ```python -m http.server 9000```
or ```python -m SimpleHTTPServer 9000```

Navigate to ```http://localhost:9000/build/web/#```


## For integration testing

Need to install ChromeDriver first (version 89, needs to match your Chrome) 
and start it ```./chromedriver --port=4444```

Then in the root of your project do
```
flutter drive --driver=test_driver/app.dart --browser-name=chrome --release
```
(not working yet, boo)