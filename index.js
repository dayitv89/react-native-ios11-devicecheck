//
// Copyright © 2017-Present, Gaurav D. Sharma
// All rights reserved.
//
'use strict';

import { NativeModules, Platform } from 'react-native';
const bridge = NativeModules.RNIOS11DeviceCheck;

const getToken = (): Promise => {
	if (Platform.OS === 'ios') {
		return new Promise((resolve, reject) =>
			bridge
				.getToken()
				.then(resolve)
				.catch(reject)
		);
	}
	return Promise.reject('Other than iOS platform not supported');
};

module.exports = {
	getToken
};
