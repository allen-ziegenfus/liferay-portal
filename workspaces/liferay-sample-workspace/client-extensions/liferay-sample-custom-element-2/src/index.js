import React from 'react';
import {createRoot} from 'react-dom/client';

import Comic from './common/components/Comic';
import DadJoke from './common/components/DadJoke';
import api from './common/services/liferay/api';
import {Liferay} from './common/services/liferay/liferay';
import HelloBar from './routes/hello-bar/pages/HelloBar';
import HelloFoo from './routes/hello-foo/pages/HelloFoo';
import HelloWorld from './routes/hello-world/pages/HelloWorld';

import './common/styles/index.scss';

const App = ({oAuth2Client1, oAuth2Client2, route}) => {
	if (route === 'hello-bar') {
		return <HelloBar />;
	}

	if (route === 'hello-foo') {
		return <HelloFoo />;
	}

	return (
		<div>
			<HelloWorld />

			{Liferay.ThemeDisplay.isSignedIn() && (
				<div>
					<DadJoke oAuth2Client={oAuth2Client1} />
					<hr/>
					<Comic oAuth2Client={oAuth2Client2} />
				</div>
			)}

		</div>
	);
};

class WebComponent extends HTMLElement {
	constructor() {
		super();

		try {
			this.oAuth2Client1 = Liferay.OAuth2Client.FromUserAgentApplication(
				'liferay-sample-oauth-application-user-agent'
			);
		}
		catch (error) {
			console.log("Unable to get user agent application");
		}

		try {
			this.oAuth2Client2 = Liferay.OAuth2Client.FromUserAgentApplication(
				'liferay-sample-node-oauth-application-user-agent'
			);
		}
		catch (error) {
			console.log('Unable to get node user agent application');
		}
	}

	connectedCallback() {
		createRoot(this).render(
			<App
				oAuth2Client1={this.oAuth2Client1}
				oAuth2Client2={this.oAuth2Client2}
				route={this.getAttribute('route')}
			/>,
			this
		);

		if (Liferay.ThemeDisplay.isSignedIn()) {
			api('o/headless-admin-user/v1.0/my-user-account')
				.then((response) => response.json())
				.then((response) => {
					if (response.givenName) {
						const nameElements = document.getElementsByClassName(
							'hello-world-name'
						);

						if (nameElements.length) {
							nameElements[0].innerHTML = response.givenName;
						}
					}
				});
		}
	}
}

const ELEMENT_ID = 'liferay-sample-custom-element-2';

if (!customElements.get(ELEMENT_ID)) {
	customElements.define(ELEMENT_ID, WebComponent);
}
