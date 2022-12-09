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

package com.liferay.marketplace.publicsitenavigation.importer;

import java.io.File;

import java.net.URL;

import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;

import java.util.Arrays;

import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
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
		"public-site-navigation.oauth2.headless.server.client.id";

	public static final String CLIENT_SECRET_FILE_NAME =
		"public-site-navigation.oauth2.headless.server.client.secret";

	public static final String DXP_METADATA_PATH =
		"/etc/liferay/lxc/dxp-metadata/";

	public static final String EXTENSION_METADATA_PATH =
		"/etc/liferay/lxc/ext-init-metadata/";

	public static final String MAINDOMAIN_FILE_NAME =
		"com.liferay.lxc.dxp.mainDomain";

	public static final String OAUTH2_TOKEN_URI_FILE_NAME =
		"public-site-navigation.oauth2.token.uri";

	public static void main(String[] arguments) throws Exception {
		System.out.println("Starting public site navigation import");

		String liferayTargetURL = Files.readString(
			Path.of(DXP_METADATA_PATH, MAINDOMAIN_FILE_NAME));

		Main main = new Main(
			Files.readString(
				Path.of(EXTENSION_METADATA_PATH + CLIENT_ID_FILE_NAME)),
			Files.readString(
				Path.of(EXTENSION_METADATA_PATH + CLIENT_SECRET_FILE_NAME)),
			new URL("https://" + liferayTargetURL));

		main.uploadToLiferay();

		System.out.println("Ending public site navigation import");
	}

	public Main(
			String liferayTargetOAuthClientId,
			String liferayTargetOAuthClientSecret, URL liferayTargetURL)
		throws Exception {

		_liferayTargetOAuthClientId = liferayTargetOAuthClientId;
		_liferayTargetOAuthClientSecret = liferayTargetOAuthClientSecret;
		_liferayTargetURL = liferayTargetURL;

		_getTargetOAuthAuthorization();
	}

	public JSONObject uploadFragments() throws Exception {
		HttpPost httpPost = new HttpPost(
			_liferayTargetURL + "/c/portal/fragment/import_fragment_entries");

		File zipFile = new File("/fragments.zip");

		FileBody fileBody = new FileBody(zipFile, ContentType.DEFAULT_BINARY);

		MultipartEntityBuilder builder = MultipartEntityBuilder.create();

		builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
		builder.addPart("file", fileBody);
		builder.addPart(
			"groupId",
			new StringBody("20121", ContentType.MULTIPART_FORM_DATA));
		builder.addPart(
			"auth", new StringBody("oauth", ContentType.MULTIPART_FORM_DATA));

		httpPost.setEntity(builder.build());

		httpPost.setHeader("Authorization", _liferayTargetOAuthAuthorization);

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

			throw new Exception(
				"Could not import fragments: " + statusLine.getStatusCode() +
					statusLine.getReasonPhrase());
		}
	}

	public void uploadToLiferay() throws Exception {
		uploadFragments();
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

	private void _getTargetOAuthAuthorization() throws Exception {
		JSONObject targetOAuthorizationJSONObject =
			_getOAuthAuthorizationJSONObject(
				_liferayTargetURL, _liferayTargetOAuthClientId,
				_liferayTargetOAuthClientSecret);

		_liferayTargetOAuthExpirationTimeMillis =
			System.currentTimeMillis() +
				(targetOAuthorizationJSONObject.getLong("expires_in") * 1000);

		_liferayTargetOAuthAuthorization =
			targetOAuthorizationJSONObject.getString("token_type") + " " +
				targetOAuthorizationJSONObject.getString("access_token");
	}

	private String _liferayTargetOAuthAuthorization;
	private final String _liferayTargetOAuthClientId;
	private final String _liferayTargetOAuthClientSecret;
	private long _liferayTargetOAuthExpirationTimeMillis;
	private final URL _liferayTargetURL;

}