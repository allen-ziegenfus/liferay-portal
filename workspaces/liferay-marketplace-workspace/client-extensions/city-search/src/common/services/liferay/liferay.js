const Liferay = window.Liferay || {
	ThemeDisplay: {
		getCompanyGroupId: () => 0,
		getPathContext: () => "",
		getPortalURL: () => "",
		getScopeGroupId: () => 0,
		getSiteGroupId: () => 0,
		isSignedIn: () => false,
	},
	authToken: "",
	OAuth2: {
		getAuthorizeURL: () => "",
		getBuiltInRedirectURL: () => "",
		getIntrospectURL: () => "",
		getTokenURL: () => "",
		getUserAgentApplication: (serviceName) => {}
	},
	OAuth2Client: {
		FromUserAgentApplication: (userAgentApplicationId) => {return new Liferay.OAuth2Client();},
		fetch: (url, options = {}) => {}
	}
};

export { Liferay };