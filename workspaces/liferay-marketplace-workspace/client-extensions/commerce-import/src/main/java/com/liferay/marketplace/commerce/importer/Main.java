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

import com.liferay.headless.batch.engine.client.dto.v1_0.ImportTask;
import com.liferay.headless.batch.engine.client.resource.v1_0.ImportTaskResource;
import com.liferay.headless.commerce.admin.catalog.client.dto.v1_0.Catalog;
import com.liferay.headless.commerce.admin.catalog.client.dto.v1_0.Product;
import com.liferay.headless.commerce.admin.catalog.client.http.HttpInvoker;
import com.liferay.headless.commerce.admin.catalog.client.pagination.Page;
import com.liferay.headless.commerce.admin.catalog.client.pagination.Pagination;
import com.liferay.headless.commerce.admin.catalog.client.resource.v1_0.CatalogResource;
import com.liferay.headless.commerce.admin.catalog.client.resource.v1_0.ProductResource;
import com.liferay.portal.kernel.util.Validator;

import java.io.InputStream;

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

import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

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
		System.out.println("Starting commerce import");

		Properties mainProperties = new Properties();

		try (InputStream inputStream = Main.class.getResourceAsStream(
				"dependencies/main.properties")) {

			mainProperties.load(inputStream);
		}

		String liferayTargetURL = Files.readString(
			Path.of(DXP_METADATA_PATH, MAINDOMAIN_FILE_NAME));

		Main main = new Main(
			mainProperties.getProperty("liferay.oauth.client.id"),
			mainProperties.getProperty("liferay.oauth.client.secret"),
			new URL(mainProperties.getProperty("liferay.url")),
			Files.readString(
				Path.of(COMMERCE_IMPORT_METADATA_PATH + CLIENT_ID_FILE_NAME)),
			Files.readString(
				Path.of(
					COMMERCE_IMPORT_METADATA_PATH + CLIENT_SECRET_FILE_NAME)),
			new URL("https://" + liferayTargetURL));

		main.uploadToLiferay();

		System.out.println("Ending commerce import");
	}

	public Main(
			String liferaySourceOAuthClientId,
			String liferaySourceOAuthClientSecret, URL liferaySourceURL,
			String liferayTargetOAuthClientId,
			String liferayTargetOAuthClientSecret, URL liferayTargetURL)
		throws Exception {

		_liferaySourceOAuthClientId = liferaySourceOAuthClientId;
		_liferaySourceOAuthClientSecret = liferaySourceOAuthClientSecret;
		_liferaySourceURL = liferaySourceURL;
		_liferayTargetOAuthClientId = liferayTargetOAuthClientId;
		_liferayTargetOAuthClientSecret = liferayTargetOAuthClientSecret;
		_liferayTargetURL = liferayTargetURL;

		_initSourceResourceBuilders(_getSourceOAuthAuthorization());
		_initTargetResourceBuilders(_getTargetOAuthAuthorization());
	}

	public void uploadToLiferay() throws Exception {
		Page<Catalog> catalogsPage = _targetCatalogResource.getCatalogsPage(
			"Liferay", null, Pagination.of(1, 2), null);

		System.out.println(
			"Found " + catalogsPage.getTotalCount() +
				" Liferay catalogs in target system.");

		if (catalogsPage.getTotalCount() > 0) {
			System.out.println("Exiting since Liferay catalog exists.");

			return;
		}

		Page<Catalog> sourceCatalogsPage =
			_sourceCatalogResource.getCatalogsPage(
				null, null, Pagination.of(1, 1000), null);

		Collection<Catalog> sourceCatalogs = sourceCatalogsPage.getItems();

		System.out.println(
			"Found " + sourceCatalogsPage.getTotalCount() +
				" catalogs in source system.");

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

		_checkBatchImportTask(
			_targetCatalogResource.postCatalogBatchHttpResponse(
				null, sourceCatalogs));

		Page<Catalog> targetCatalogsPage =
			_targetCatalogResource.getCatalogsPage(
				null, null, Pagination.of(1, 1000), null);

		Map<Long, String> catalogIdToERCLookup = new HashMap<>();

		for (Catalog catalog : sourceCatalogsPage.getItems()) {
			if (Validator.isNotNull(catalog.getExternalReferenceCode())) {
				catalogIdToERCLookup.put(
					catalog.getId(), catalog.getExternalReferenceCode());
			}
		}

		Map<String, Long> catalogERCToIdLookup = new HashMap<>();

		for (Catalog catalog : targetCatalogsPage.getItems()) {
			if (Validator.isNotNull(catalog.getExternalReferenceCode())) {
				catalogERCToIdLookup.put(
					catalog.getExternalReferenceCode(), catalog.getId());
			}
		}

		List<Product> productsToPost = new ArrayList<>();

		for (Product product : products) {
			Product newProduct = new Product();

			newProduct.setName(product.getName());
			newProduct.setCatalogId(
				catalogERCToIdLookup.get(
					catalogIdToERCLookup.get(product.getCatalogId())));
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

		_checkBatchImportTask(
			_targetProductResource.postProductBatchHttpResponse(
				null, productsToPost));
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
	}

	private boolean _isImportTaskFinished(String executeStatus) {
		if (Objects.equals(executeStatus, "COMPLETED") ||
			Objects.equals(executeStatus, "FAILED") ||
			Objects.equals(executeStatus, "NOT_FOUND")) {

			return true;
		}

		return false;
	}

	private final String _liferaySourceOAuthClientId;
	private final String _liferaySourceOAuthClientSecret;
	private long _liferaySourceOAuthExpirationTimeMillis;
	private final URL _liferaySourceURL;
	private final String _liferayTargetOAuthClientId;
	private final String _liferayTargetOAuthClientSecret;
	private long _liferayTargetOAuthExpirationTimeMillis;
	private final URL _liferayTargetURL;
	private CatalogResource _sourceCatalogResource;
	private ProductResource _sourceProductResource;
	private CatalogResource _targetCatalogResource;
	private ImportTaskResource _targetImportTaskResource;
	private ProductResource _targetProductResource;

}