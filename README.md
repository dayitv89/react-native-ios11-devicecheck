# react-native-ios11-devicecheck (RNIOS11DeviceCheck)

React Native implementation for Apple iOS 11 DeviceCheck DCDevice API. Except iOS platform always comes on `Promise.reject('Other than iOS platform not supported')`

![](https://img.shields.io/badge/pod_RNIOS11DeviceCheck-v0.0.3-green.svg?style=flat)
![](https://img.shields.io/badge/npm_react--native--ios11--devicecheck-v0.0.3-green.svg?style=flat)

# Uses:

- webservice request on server comes from apple devices.
- App device token using device check is ephemeral, but that token is useful to identify the device uniqueness such as per device per app one offer scenario. If device formatted, keychain wipe or any hack won't effect on this case. Safe to check per device identification.

# Installation: (npm)

`$ npm i --save react-native-ios11-devicecheck`

# Implemtation (iOS Only using cocoapods, no need to do anything on android):

`pod 'RNIOS11DeviceCheck', :path => '../node_modules/react-native-ios11-devicecheck/ios'`

Try inside javascript code: `index.js`

```javascript
import React from 'react';
import { View } from 'react-native';
import RNIOS11DeviceCheck from 'react-native-ios11-devicecheck';

export default class App extends React.Component {
	componentDidMount = () => {
		RNIOS11DeviceCheck
			.getToken()
			.then(console.warn)
			.catch(console.warn);
	};

	render = () => <View style={{ flex: 1, backgroundColor: 'white' />;
}
```

# [DeviceCheck Sample](https://github.com/dayitv89/DCDeviceCheck)

DeviceCheck is a new iOS 11 API that gives you access to two bits of data per-device, per-developer that your associated server can use in its business logic. Here's a fully working sample.

# Apple Docs:

iOS docs:
<https://developer.apple.com/documentation/devicecheck>

Server side docs:
<https://developer.apple.com/documentation/devicecheck/accessing_and_modifying_the_per_device_data>

WWDC 2017 - Session 702 - Privacy and Your Apps:
<https://developer.apple.com/videos/play/wwdc2017/702/?time=1444>
