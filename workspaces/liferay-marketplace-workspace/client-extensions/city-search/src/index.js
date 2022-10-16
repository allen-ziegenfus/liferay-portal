import React from 'react';
import ReactDOM from 'react-dom';

import HelloWorld from './routes/hello-world/pages/HelloWorld';
import './common/styles/index.scss';
import api from './common/services/liferay/api';
import { Liferay } from './common/services/liferay/liferay';
import CitySearch from './common/components/CitySearch';

const App = ({ oAuth2Client }) => {
	return (
		<div>
			<HelloWorld />
			{Liferay.ThemeDisplay.isSignedIn() &&
				<div>
					<CitySearch oAuth2Client={oAuth2Client} />
				</div>
			}
		</div>
	);
};

class WebComponent extends HTMLElement {
	constructor() {
		super();

		this.oAuth2Client = Liferay.OAuth2Client.FromUserAgentApplication('uscities');
	}

	connectedCallback() {
		ReactDOM.render(
			<App oAuth2Client={this.oAuth2Client} />,
			this
		);

		if (Liferay.ThemeDisplay.isSignedIn()) {
			api(
				'o/headless-admin-user/v1.0/my-user-account'
			).then(res => {
				let nameEls = document.getElementsByClassName('hello-world-name');
				if (nameEls.length > 0){
					if (res.givenName) {
						nameEls[0].innerHTML = res.givenName;
					}
				}
			});
		}
	}
}

const ELEMENT_ID = 'city-search';

if (!customElements.get(ELEMENT_ID)) {
	customElements.define(ELEMENT_ID, WebComponent);
}
