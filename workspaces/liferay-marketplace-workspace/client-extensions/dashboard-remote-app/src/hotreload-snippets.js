/*
module.exports = function(app) {
  app.use(
    //'/web/guest/home',
	['!bundle.js'],
    createProxyMiddleware({
		//pathFilter: "!bundle.js",
      target: 'https://dxp.lfr.dev',
      changeOrigin: true,
	  secure: false
	  ssl: {
		key: fs.readFileSync('~/.lcectl/sources/localdev/k8s/tls/rootCA.pem', "utf-8"),
		cert: fs.readFileSync('~/.lcectl/sources/localdev/k8s/tls/rootCA.pem', "utf-8")
	  
    })
  );
};
*/

"start2": "yarn config set cafile ~/.lcectl/sources/localdev/k8s/tls/rootCA.pem && HTTPS=true SSL_CRT_FILE=~/.lcectl/sources/localdev/k8s/tls/lfr.dev.crt SSL_KEY_FILE=~/.lcectl/sources/localdev/k8s/tls/lfr.dev.key  react-scripts start",