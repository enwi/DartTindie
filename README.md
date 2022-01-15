[![Discord](https://img.shields.io/discord/781219798931603527.svg?label=enwi&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/YxVyJWX62h)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/enwi/darttindie?label=release)](https://github.com/enwi/darttindie/releases)

# DartTindie
Dart wrapper for Tindie Order API

> Note: Never publish your Tindie API Key! It is a secret and should remain one!

## Features
 - Get all orders (last 20)
 - Get all shipped orders (last 20)
 - Get all unshipped orders (last 20)

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
