# DartTindie
Dart wrapper for Tindie Order API

## Features
 - Get all orders (last 30)
 - Get all shipped orders (last 30)
 - Get all unshipped orders (last 30)

## Getting started
```
flutter pub add darttindie
```

## Usage
Instantiate `Tindie` object with API key and username
```dart
final tindie = Tindie(
    apikey: 'api key',
    username: 'username',
);
```

Get last 30 orders
```dart
tindie.getOrders();
```

Get last 30 unshipped orders
```dart
tindie.getOrders(shipped: false);
```
