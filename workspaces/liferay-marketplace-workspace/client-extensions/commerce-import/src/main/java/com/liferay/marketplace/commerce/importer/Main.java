/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.marketplace.commerce.importer;

import com.liferay.headless.admin.user.client.dto.v1_0.Account;
import com.liferay.headless.admin.user.client.dto.v1_0.AccountRole;
import com.liferay.headless.admin.user.client.dto.v1_0.Role;
import com.liferay.headless.admin.user.client.resource.v1_0.AccountResource;
import com.liferay.headless.admin.user.client.resource.v1_0.AccountRoleResource;
import com.liferay.headless.admin.user.client.resource.v1_0.RoleResource;
import com.liferay.headless.batch.engine.client.dto.v1_0.ImportTask;
import com.liferay.headless.batch.engine.client.resource.v1_0.ImportTaskResource;
import com.liferay.headless.commerce.admin.catalog.client.dto.v1_0.Catalog;
import com.liferay.headless.commerce.admin.catalog.client.dto.v1_0.Product;
import com.liferay.headless.commerce.admin.catalog.client.http.HttpInvoker;
import com.liferay.headless.commerce.admin.catalog.client.pagination.Page;
import com.liferay.headless.commerce.admin.catalog.client.pagination.Pagination;
import com.liferay.headless.commerce.admin.catalog.client.resource.v1_0.CatalogResource;
import com.liferay.headless.commerce.admin.catalog.client.resource.v1_0.ProductResource;
import com.liferay.petra.string.CharPool;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.util.HashMapBuilder;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;

import java.io.InputStream;

import java.net.URI;
import java.net.URL;

import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.http.HttpHost;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.client.utils.URIUtils;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * @author Allen Ziegenfus
 */
public class Main {

	public static final String CLIENT_ID_FILE_NAME =
		"commerce-import.oauth2.headless.server.client.id";

	public static final String CLIENT_SECRET_FILE_NAME =
		"commerce-import.oauth2.headless.server.client.secret";

	public static final String COMMERCE_IMPORT_METADATA_PATH =
		"/etc/liferay/lxc/ext-init-metadata/";

	public static final String DXP_METADATA_PATH =
		"/etc/liferay/lxc/dxp-metadata/";

	public static final String MAINDOMAIN_FILE_NAME =
		"com.liferay.lxc.dxp.mainDomain";

	public static final String OAUTH2_TOKEN_URI_FILE_NAME =
		"commerce-import.oauth2.token.uri";

	public static void main(String[] arguments) throws Exception {
		try {
			System.out.println("Starting commerce import");

			Properties mainProperties = new Properties();

			try (InputStream inputStream = Main.class.getResourceAsStream(
					"dependencies/main.properties")) {

				mainProperties.load(inputStream);
			}

			String liferayTargetDomain;
			URI liferayTargetURI;
			String targetOAuthClientId;
			String targetOAuthClientSecret;

			Path path = Path.of("/etc/liferay");

			if (Files.exists(path)) {
				try (Stream<Path> walk = Files.walk(path)) {
					List<Path> result = walk.filter(
						Files::isRegularFile
					).collect(
						Collectors.toList()
					);

					for (Path p : result) {
						System.out.println(p);
					}
				}

				liferayTargetDomain = Files.readString(
					Path.of(DXP_METADATA_PATH, MAINDOMAIN_FILE_NAME));

				liferayTargetURI = new URI("https://" + liferayTargetDomain);

				targetOAuthClientId = Files.readString(
					Path.of(
						COMMERCE_IMPORT_METADATA_PATH + CLIENT_ID_FILE_NAME));
				targetOAuthClientSecret = Files.readString(
					Path.of(
						COMMERCE_IMPORT_METADATA_PATH +
							CLIENT_SECRET_FILE_NAME));
			}
			else {
				liferayTargetURI = new URI(
					mainProperties.getProperty("liferay.target.url"));

				HttpHost liferayTargetHost = URIUtils.extractHost(
					liferayTargetURI);

				liferayTargetDomain = liferayTargetHost.getHostName();

				targetOAuthClientId = mainProperties.getProperty(
					"liferay.target.oauth.client.id");
				targetOAuthClientSecret = mainProperties.getProperty(
					"liferay.target.oauth.client.secret");
			}

			Main main = new Main(
				mainProperties.getProperty("liferay.source.oauth.client.id"),
				mainProperties.getProperty(
					"liferay.source.oauth.client.secret"),
				new URL(mainProperties.getProperty("liferay.source.url")),
				targetOAuthClientId, targetOAuthClientSecret,
				liferayTargetURI.toURL(), liferayTargetDomain);

			main.uploadToLiferay();

			System.out.println("Ending commerce import");
		}
		catch (Exception exception) {
			System.out.println(
				"Exception occurred: " + exception.getMessage() +
					Arrays.toString(exception.getStackTrace()));
		}
	}

	public Main(
			String liferaySourceOAuthClientId,
			String liferaySourceOAuthClientSecret, URL liferaySourceURL,
			String liferayTargetOAuthClientId,
			String liferayTargetOAuthClientSecret, URL liferayTargetURL,
			String liferayTargetMainDomain)
		throws Exception {

		_liferaySourceOAuthClientId = liferaySourceOAuthClientId;
		_liferaySourceOAuthClientSecret = liferaySourceOAuthClientSecret;
		_liferaySourceURL = liferaySourceURL;
		_liferayTargetOAuthClientId = liferayTargetOAuthClientId;
		_liferayTargetOAuthClientSecret = liferayTargetOAuthClientSecret;
		_liferayTargetURL = liferayTargetURL;
		_liferayTargetMainDomain = liferayTargetMainDomain;

		_initSourceResourceBuilders(_getSourceOAuthAuthorization());
		_initTargetResourceBuilders(_getTargetOAuthAuthorization());
	}

	public void uploadToLiferay() throws Exception {
		Page<Catalog> catalogsPage = _targetCatalogResource.getCatalogsPage(
			"Liferay", null, Pagination.of(1, 2), null);

		System.out.println(
			"Found " + catalogsPage.getTotalCount() +
				" Liferay catalogs in target system.");

		JSONObject companyJSONObject = _getCompanyByWebIdJSONObject(
			_liferayTargetMainDomain);

		long companyId = companyJSONObject.getLong("companyId");

		List<Catalog> sourceCatalogs = _getCatalogs(_sourceCatalogResource);

		System.out.println(
			"Found " + sourceCatalogs.size() + " catalogs in source system.");

		sourceCatalogs.removeIf(
			catalog -> Objects.equals(catalog.getName(), "Master"));

		for (Catalog sourceCatalog : sourceCatalogs) {
			if (Validator.isNull(sourceCatalog.getExternalReferenceCode())) {
				sourceCatalog.setExternalReferenceCode(
					"LRDCOM-" + sourceCatalog.getId());
			}
		}

		System.out.println("Importing catalogs into target system.");

		_checkBatchImportTask(
			_targetCatalogResource.postCatalogBatchHttpResponse(
				null, sourceCatalogs));

		List<Catalog> targetCatalogs = _getCatalogs(_targetCatalogResource);

		targetCatalogs.removeIf(
			catalog -> Objects.equals(catalog.getName(), "Master"));

		Map<Long, String> catalogExternalReferenceCodes = new HashMap<>();

		for (Catalog catalog : sourceCatalogs) {
			if (Validator.isNotNull(catalog.getExternalReferenceCode())) {
				catalogExternalReferenceCodes.put(
					catalog.getId(), catalog.getExternalReferenceCode());
			}
		}

		com.liferay.headless.admin.user.client.pagination.Page<Role> rolesPage =
			_targetRoleResource.getRolesPage(
				new Integer[] {1}, StringPool.BLANK,
				com.liferay.headless.admin.user.client.pagination.Pagination.of(
					1, 1000));

		Map<String, Role> rolesMap = new HashMap<>();
		Collection<Role> roles = rolesPage.getItems();

		for (Role role : roles) {
			rolesMap.put(role.getName(), role);
		}

		List<Account> accounts = _getAccounts();
		Map<String, Account> accountsMap = new HashMap<>();

		for (Account account : accounts) {
			accountsMap.put(account.getExternalReferenceCode(), account);
		}

		Map<String, Long> catalogIds = new HashMap<>();

		for (Catalog targetCatalog : targetCatalogs) {
			if (Validator.isNotNull(targetCatalog.getExternalReferenceCode())) {
				catalogIds.put(
					targetCatalog.getExternalReferenceCode(),
					targetCatalog.getId());

				_createCatalogRole(companyId, targetCatalog, rolesMap);
				_createCatalogAccount(targetCatalog, accountsMap);
			}
		}

		_importProducts(catalogIds, catalogExternalReferenceCodes);
	}

	private JSONObject _addRole(
			String className, long classPK, String name, String title,
			String description, int type, String subtype)
		throws Exception {

		HttpPost httpPost = new HttpPost(
			_liferayTargetURL + "/api/jsonws/role");

		httpPost.setHeader("Authorization", _getTargetOAuthAuthorization());
		httpPost.setHeader("Accept", "application/json; charset=UTF-8");
		httpPost.setHeader("Content-Type", "application/json; charset=UTF-8");
		httpPost.setHeader("User-Agent", Main.class.getName());

		JSONObject dataJSONObject = new JSONObject();

		dataJSONObject.put("id", 123);
		dataJSONObject.put("jsonrpc", "2.0");
		dataJSONObject.put("method", "add-role");
		dataJSONObject.put(
			"params",
			HashMapBuilder.<String, Object>put(
				"className", className
			).put(
				"classPK", classPK
			).put(
				"descriptionMap",
				new JSONObject(
					HashMapBuilder.put(
						"en-US", description
					).build()
				).toString()
			).put(
				"name", name
			).put(
				"subtype", subtype
			).put(
				"titleMap",
				new JSONObject(
					HashMapBuilder.put(
						"en-US", title
					).build()
				).toString()
			).put(
				"type", type
			).build());

		httpPost.setEntity(
			new StringEntity(dataJSONObject.toString(), "UTF-8"));

		HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();

		try (CloseableHttpClient closeableHttpClient =
				httpClientBuilder.build()) {

			CloseableHttpResponse closeableHttpResponse =
				closeableHttpClient.execute(httpPost);

			StatusLine statusLine = closeableHttpResponse.getStatusLine();

			if (statusLine.getStatusCode() == HttpStatus.SC_OK) {
				JSONObject responseJSONObject = new JSONObject(
					EntityUtils.toString(
						closeableHttpResponse.getEntity(),
						Charset.defaultCharset()));

				if (responseJSONObject.has("error")) {
					throw new Exception(
						"Error while adding role: " +
							responseJSONObject.get("error"));
				}

				return responseJSONObject.getJSONObject("result");
			}

			throw new Exception(
				"Error while adding role: " + statusLine.getStatusCode() +
					statusLine.getReasonPhrase());
		}
	}

	private boolean _checkBatchImportTask(HttpInvoker.HttpResponse httpResponse)
		throws Exception {

		JSONObject responseJSONObject = new JSONObject(
			httpResponse.getContent());

		if ((httpResponse.getStatusCode() / 100) != 2) {
			System.out.println(
				"Unable to process HTTP response content: " +
					responseJSONObject);

			return false;
		}

		System.out.println("HTTP response content: " + responseJSONObject);
		System.out.println(
			"HTTP response message: " + httpResponse.getMessage());

		String executeStatus = "INITIAL";
		ImportTask importTask;

		do {
			importTask =
				_targetImportTaskResource.getImportTaskByExternalReferenceCode(
					responseJSONObject.getString("externalReferenceCode"));

			executeStatus = importTask.getExecuteStatusAsString();

			long expirationDelta =
				_liferayTargetOAuthExpirationTimeMillis -
					System.currentTimeMillis();

			if ((expirationDelta - 10000) < 0) {
				_initTargetResourceBuilders(_getTargetOAuthAuthorization());
			}

			System.out.println("Execute Status: " + executeStatus);
			Thread.sleep(2000);
		}
		while (!_isImportTaskFinished(executeStatus));

		System.out.println(importTask.getErrorMessage());

		return true;
	}

	private void _createCatalogAccount(
			Catalog catalog, Map<String, Account> accountsMap)
		throws Exception {

		if (accountsMap.containsKey(catalog.getExternalReferenceCode())) {
			return;
		}

		System.out.println(
			"Account for catalog does not exist, creating... " +
				catalog.getName());

		Account account = new Account();

		account.setName(catalog.getName());

		account = _targetAccountResource.putAccountByExternalReferenceCode(
			catalog.getExternalReferenceCode(), account);

		AccountRole adminAccountRole = new AccountRole();

		adminAccountRole.setName(catalog.getName() + " Admin");
		adminAccountRole.setDisplayName(adminAccountRole.getName());

		_targetAccountRoleResource.postAccountAccountRole(
			account.getId(), adminAccountRole);

		AccountRole appManagerAccountRole = new AccountRole();

		appManagerAccountRole.setName(catalog.getName() + " App Manager");
		appManagerAccountRole.setDisplayName(appManagerAccountRole.getName());

		_targetAccountRoleResource.postAccountAccountRole(
			account.getId(), appManagerAccountRole);
	}

	private void _createCatalogRole(
			long companyId, Catalog catalog, Map<String, Role> rolesMap)
		throws Exception {

		String roleName = catalog.getName() + " App Editor";

		roleName = StringUtil.replace(
			roleName, new char[] {CharPool.COMMA, CharPool.STAR},
			new char[] {CharPool.SPACE, CharPool.SPACE});

		if (rolesMap.containsKey(roleName)) {
			return;
		}

		System.out.println("Creating catalog role " + roleName);

		JSONObject roleJSONObject = _addRole(
			"com.liferay.portal.kernel.model.Role", 0, roleName, roleName,
			"This role can be assigned to an account user to give them " +
				"permission to add/submit an app to the Marketplace on " +
					"behalf of this account.",
			1, StringPool.BLANK);

		long roleId = roleJSONObject.getLong("classPK");

		rolesMap.put(roleName, new Role());

		_setIndividualResourcePermissions(
			0, companyId, "com.liferay.commerce.product.model.CommerceCatalog",
			String.valueOf(catalog.getId()), roleId,
			new String[] {"DELETE", "PERMISSIONS", "UPDATE", "VIEW"});
	}

	private List<Account> _getAccounts() throws Exception {
		int page = 1;
		List<Account> accounts = new ArrayList<>();
		boolean fetchedAllItems = false;

		while (!fetchedAllItems) {
			com.liferay.headless.admin.user.client.pagination.Page<Account>
				accountsPage = _targetAccountResource.getAccountsPage(
					StringPool.BLANK, StringPool.BLANK,
					com.liferay.headless.admin.user.client.pagination.
						Pagination.of(page, 100),
					StringPool.BLANK);

			accounts.addAll(accountsPage.getItems());

			if (accountsPage.getLastPage() == page) {
				fetchedAllItems = true;
			}

			page++;
		}

		return accounts;
	}

	private List<Catalog> _getCatalogs(CatalogResource catalogResource)
		throws Exception {

		int page = 1;
		List<Catalog> catalogs = new ArrayList<>();
		boolean fetchedAllItems = false;

		while (!fetchedAllItems) {
			Page<Catalog> catalogsPage = catalogResource.getCatalogsPage(
				StringPool.BLANK, StringPool.BLANK, Pagination.of(page, 100),
				StringPool.BLANK);

			catalogs.addAll(catalogsPage.getItems());

			if (catalogsPage.getLastPage() == page) {
				fetchedAllItems = true;
			}

			page++;
		}

		return catalogs;
	}

	private JSONObject _getCompanyByWebIdJSONObject(String webId)
		throws Exception {

		HttpGet httpGet = new HttpGet(
			_liferayTargetURL + "/api/jsonws/company/get-company-by-web-id");

		httpGet.setHeader("Authorization", _getTargetOAuthAuthorization());
		httpGet.setHeader("Accept", "application/json");
		httpGet.setHeader("Content-Type", "application/json");
		httpGet.setHeader("User-Agent", Main.class.getName());

		URI uri = new URIBuilder(
			httpGet.getURI()
		).addParameter(
			"webId", webId
		).build();

		httpGet.setURI(uri);

		HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();

		try (CloseableHttpClient closeableHttpClient =
				httpClientBuilder.build()) {

			CloseableHttpResponse closeableHttpResponse =
				closeableHttpClient.execute(httpGet);

			StatusLine statusLine = closeableHttpResponse.getStatusLine();

			if (statusLine.getStatusCode() == HttpStatus.SC_OK) {
				return new JSONObject(
					EntityUtils.toString(
						closeableHttpResponse.getEntity(),
						Charset.defaultCharset()));
			}

			throw new Exception(
				"Could not get companyId: " + statusLine.getStatusCode() +
					statusLine.getReasonPhrase());
		}
	}

	private JSONObject _getOAuthAuthorizationJSONObject(
			URL liferayURL, String liferayOAuthClientId,
			String liferayOAuthClientSecret)
		throws Exception {

		HttpPost httpPost = new HttpPost(liferayURL + "/o/oauth2/token");

		httpPost.setEntity(
			new UrlEncodedFormEntity(
				Arrays.asList(
					new BasicNameValuePair("client_id", liferayOAuthClientId),
					new BasicNameValuePair(
						"client_secret", liferayOAuthClientSecret),
					new BasicNameValuePair(
						"grant_type", "client_credentials"))));
		httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded");

		HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();

		try (CloseableHttpClient closeableHttpClient =
				httpClientBuilder.build()) {

			CloseableHttpResponse closeableHttpResponse =
				closeableHttpClient.execute(httpPost);

			StatusLine statusLine = closeableHttpResponse.getStatusLine();

			if (statusLine.getStatusCode() == HttpStatus.SC_OK) {
				return new JSONObject(
					EntityUtils.toString(
						closeableHttpResponse.getEntity(),
						Charset.defaultCharset()));
			}

			throw new Exception("Unable to get OAuth authorization");
		}
	}

	private String _getSourceOAuthAuthorization() throws Exception {
		JSONObject sourceOAuthorizationJSONObject =
			_getOAuthAuthorizationJSONObject(
				_liferaySourceURL, _liferaySourceOAuthClientId,
				_liferaySourceOAuthClientSecret);

		_liferaySourceOAuthExpirationTimeMillis =
			System.currentTimeMillis() +
				(sourceOAuthorizationJSONObject.getLong("expires_in") * 1000);

		return sourceOAuthorizationJSONObject.getString("token_type") + " " +
			sourceOAuthorizationJSONObject.getString("access_token");
	}

	private String _getTargetOAuthAuthorization() throws Exception {
		JSONObject targetOAuthorizationJSONObject =
			_getOAuthAuthorizationJSONObject(
				_liferayTargetURL, _liferayTargetOAuthClientId,
				_liferayTargetOAuthClientSecret);

		_liferayTargetOAuthExpirationTimeMillis =
			System.currentTimeMillis() +
				(targetOAuthorizationJSONObject.getLong("expires_in") * 1000);

		return targetOAuthorizationJSONObject.getString("token_type") + " " +
			targetOAuthorizationJSONObject.getString("access_token");
	}

	private void _importProducts(
			Map<String, Long> catalogIds,
			Map<Long, String> catalogExternalReferenceCodes)
		throws Exception {

		System.out.println("Querying products from source system.");

		long expirationDelta =
			_liferaySourceOAuthExpirationTimeMillis -
				System.currentTimeMillis();

		if ((expirationDelta - 10000) < 0) {
			_initSourceResourceBuilders(_getSourceOAuthAuthorization());
		}

		Page<Product> sourceProductsPage =
			_sourceProductResource.getProductsPage(
				null, null, Pagination.of(1, 1000), null);

		Collection<Product> products = sourceProductsPage.getItems();

		System.out.println(
			"Found " + sourceProductsPage.getTotalCount() +
				" products in source system.");

		List<Product> productsToPost = new ArrayList<>();

		for (Product product : products) {
			Product newProduct = new Product();

			newProduct.setName(product.getName());
			newProduct.setCatalogId(
				catalogIds.get(
					catalogExternalReferenceCodes.get(product.getCatalogId())));
			newProduct.setProductType(product.getProductType());
			newProduct.setExternalReferenceCode(
				product.getExternalReferenceCode());
			newProduct.setDescription(product.getDescription());
			//	newProduct.setCustomFields(product.getCustomFields());
			newProduct.setImages(product.getImages());

			if (newProduct.getCatalogId() == null) {
				System.out.println(
					"Could not find catalog for" + product.getName());
			}
			else {
				productsToPost.add(newProduct);
			}
		}

		System.out.println("Importing products into target system");

		_checkBatchImportTask(
			_targetProductResource.postProductBatchHttpResponse(
				null, productsToPost));
	}

	private void _initSourceResourceBuilders(String authorization)
		throws Exception {

		System.out.println("Setting up resource builder for source system");

		CatalogResource.Builder catalogResourceBuilder =
			CatalogResource.builder();

		_sourceCatalogResource = catalogResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferaySourceURL.getHost(), _liferaySourceURL.getPort(),
			_liferaySourceURL.getProtocol()
		).build();

		ProductResource.Builder productResourceBuilder =
			ProductResource.builder();

		_sourceProductResource = productResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferaySourceURL.getHost(), _liferaySourceURL.getPort(),
			_liferaySourceURL.getProtocol()
		).build();
	}

	private void _initTargetResourceBuilders(String authorization)
		throws Exception {

		System.out.println("Setting up resource builder for target system");

		CatalogResource.Builder catalogResourceBuilder =
			CatalogResource.builder();

		_targetCatalogResource = catalogResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferayTargetURL.getHost(), _liferayTargetURL.getPort(),
			_liferayTargetURL.getProtocol()
		).build();

		ProductResource.Builder productResourceBuilder =
			ProductResource.builder();

		_targetProductResource = productResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferayTargetURL.getHost(), _liferayTargetURL.getPort(),
			_liferayTargetURL.getProtocol()
		).build();

		ImportTaskResource.Builder importTaskResourceBuilder =
			ImportTaskResource.builder();

		_targetImportTaskResource = importTaskResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferayTargetURL.getHost(), _liferayTargetURL.getPort(),
			_liferayTargetURL.getProtocol()
		).build();

		RoleResource.Builder roleResourceBuilder = RoleResource.builder();

		_targetRoleResource = roleResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferayTargetURL.getHost(), _liferayTargetURL.getPort(),
			_liferayTargetURL.getProtocol()
		).build();

		AccountResource.Builder accountResourceBuilder =
			AccountResource.builder();

		_targetAccountResource = accountResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferayTargetURL.getHost(), _liferayTargetURL.getPort(),
			_liferayTargetURL.getProtocol()
		).build();

		AccountRoleResource.Builder accountRoleResourceBuilder =
			AccountRoleResource.builder();

		_targetAccountRoleResource = accountRoleResourceBuilder.header(
			"Authorization", authorization
		).endpoint(
			_liferayTargetURL.getHost(), _liferayTargetURL.getPort(),
			_liferayTargetURL.getProtocol()
		).build();
	}

	private boolean _isImportTaskFinished(String executeStatus) {
		if (Objects.equals(executeStatus, "COMPLETED") ||
			Objects.equals(executeStatus, "FAILED") ||
			Objects.equals(executeStatus, "NOT_FOUND")) {

			return true;
		}

		return false;
	}

	private JSONObject _setIndividualResourcePermissions(
			long groupId, long companyId, String name, String primKey,
			long roleId, String[] actionIds)
		throws Exception {

		HttpPost httpPost = new HttpPost(
			_liferayTargetURL + "/api/jsonws/resourcepermission");

		httpPost.setHeader("Authorization", _getTargetOAuthAuthorization());
		httpPost.setHeader("Accept", "application/json");
		httpPost.setHeader("Content-Type", "application/json");
		httpPost.setHeader("User-Agent", Main.class.getName());

		JSONObject dataJSONObject = new JSONObject();

		dataJSONObject.put("id", 123);
		dataJSONObject.put("jsonrpc", "2.0");
		dataJSONObject.put("method", "set-individual-resource-permissions");
		dataJSONObject.put(
			"params",
			HashMapBuilder.<String, Object>put(
				"actionIds",
				new JSONArray(
					actionIds
				).toString()
			).put(
				"companyId", companyId
			).put(
				"groupId", groupId
			).put(
				"name", name
			).put(
				"primKey", primKey
			).put(
				"roleId", roleId
			).build());

		httpPost.setEntity(new StringEntity(dataJSONObject.toString()));

		HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();

		try (CloseableHttpClient closeableHttpClient =
				httpClientBuilder.build()) {

			CloseableHttpResponse closeableHttpResponse =
				closeableHttpClient.execute(httpPost);

			StatusLine statusLine = closeableHttpResponse.getStatusLine();

			if (statusLine.getStatusCode() == HttpStatus.SC_OK) {
				JSONObject responseJSONObject = new JSONObject(
					EntityUtils.toString(
						closeableHttpResponse.getEntity(),
						Charset.defaultCharset()));

				if (responseJSONObject.has("error")) {
					throw new Exception(
						"Error while setting individual resource " +
							"permissions: " + responseJSONObject.get("error"));
				}

				return responseJSONObject;
			}

			throw new Exception(
				"Error while setting individual resource permissions: " +
					statusLine.getStatusCode() + statusLine.getReasonPhrase());
		}
	}

	private final String _liferaySourceOAuthClientId;
	private final String _liferaySourceOAuthClientSecret;
	private long _liferaySourceOAuthExpirationTimeMillis;
	private final URL _liferaySourceURL;
	private final String _liferayTargetMainDomain;
	private final String _liferayTargetOAuthClientId;
	private final String _liferayTargetOAuthClientSecret;
	private long _liferayTargetOAuthExpirationTimeMillis;
	private final URL _liferayTargetURL;
	private CatalogResource _sourceCatalogResource;
	private ProductResource _sourceProductResource;
	private AccountResource _targetAccountResource;
	private AccountRoleResource _targetAccountRoleResource;
	private CatalogResource _targetCatalogResource;
	private ImportTaskResource _targetImportTaskResource;
	private ProductResource _targetProductResource;
	private RoleResource _targetRoleResource;

}