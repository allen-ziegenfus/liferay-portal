/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.gradle.plugins.workspace.task;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.fasterxml.jackson.dataformat.yaml.YAMLGenerator;

import com.liferay.gradle.plugins.workspace.internal.client.extension.ClientExtensionDescriptor;
import com.liferay.gradle.plugins.workspace.internal.util.FileUtil;

import java.io.File;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import java.util.LinkedHashMap;
import java.util.Map;

import org.gradle.api.DefaultTask;
import org.gradle.api.GradleException;
import org.gradle.api.Project;
import org.gradle.api.file.Directory;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.file.ProjectLayout;
import org.gradle.api.file.RegularFile;
import org.gradle.api.file.RegularFileProperty;
import org.gradle.api.model.ObjectFactory;
import org.gradle.api.provider.Property;
import org.gradle.api.tasks.Input;
import org.gradle.api.tasks.InputFile;
import org.gradle.api.tasks.Internal;
import org.gradle.api.tasks.Optional;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.TaskAction;
import org.gradle.api.tasks.TaskOutputs;

import org.yaml.snakeyaml.DumperOptions;

/**
 * @author Gregory Amerson
 */
public class CreateClientExtensionDescriptorTask extends DefaultTask {

	public CreateClientExtensionDescriptorTask() {
		Project project = getProject();

		ObjectFactory objectFactory = project.getObjects();

		_clientExtensionConfigFile = objectFactory.fileProperty();
		_dockerfile = objectFactory.fileProperty();
		_image = objectFactory.property(String.class);
		_imageDigestFile = objectFactory.fileProperty();
		_lcpJsonFile = objectFactory.fileProperty();
		_outputDir = objectFactory.directoryProperty();

		ProjectLayout projectLayout = project.getLayout();

		DirectoryProperty buildDirectoryProperty =
			projectLayout.getBuildDirectory();

		_outputDir.convention(
			buildDirectoryProperty.dir("client-extension-descriptor"));

		TaskOutputs taskOutputs = getOutputs();

		taskOutputs.upToDateWhen(task -> false);
	}

	@TaskAction
	public void createClientExtensionDescriptor() throws Exception {
		if (!_image.isPresent()) {
			throw new GradleException(
				"Set the liferay.workspace.client.extension.registry " +
					"property and a version to publish \"" +
						getProject().getName() + "\"");
		}

		String baseImage = ClientExtensionDescriptor.getBaseImage(
			FileUtil.read(_getFile(_dockerfile)));

		String imageDigest = null;
		String imageRepository = null;
		String imageTag = null;

		if (!ClientExtensionDescriptor.isConfigurationOnly(baseImage)) {
			String image = _image.get();

			imageRepository = ClientExtensionDescriptor.getRepository(image);

			String imageDigestFileText = FileUtil.read(
				_getFile(_imageDigestFile));

			imageDigest = imageDigestFileText.trim();

			imageTag = image.substring(imageRepository.length() + 1);
		}

		File outputDir = _getFile(_outputDir);

		getProject().delete(outputDir);

		outputDir.mkdirs();

		_yamlObjectMapper.writeValue(
			new File(outputDir, "client-extension.yaml"),
			ClientExtensionDescriptor.derive(
				baseImage, _readJSON(_clientExtensionConfigFile), imageDigest,
				imageRepository, imageTag, _readJSON(_lcpJsonFile)));

		Files.write(
			new File(
				outputDir, "Dockerfile"
			).toPath(),
			"FROM scratch\n\nCOPY client-extension.yaml /\n".getBytes(
				StandardCharsets.UTF_8));
	}

	@InputFile
	public RegularFileProperty getClientExtensionConfigFile() {
		return _clientExtensionConfigFile;
	}

	@InputFile
	public RegularFileProperty getDockerfile() {
		return _dockerfile;
	}

	@Input
	@Optional
	public Property<String> getImage() {
		return _image;
	}

	@Internal
	public RegularFileProperty getImageDigestFile() {
		return _imageDigestFile;
	}

	@Internal
	public RegularFileProperty getLcpJsonFile() {
		return _lcpJsonFile;
	}

	@OutputDirectory
	public DirectoryProperty getOutputDir() {
		return _outputDir;
	}

	private File _getFile(DirectoryProperty directoryProperty) {
		Directory directory = directoryProperty.get();

		return directory.getAsFile();
	}

	private File _getFile(RegularFileProperty regularFileProperty) {
		RegularFile regularFile = regularFileProperty.get();

		return regularFile.getAsFile();
	}

	private Map<String, Object> _readJSON(
			RegularFileProperty regularFileProperty)
		throws Exception {

		File file = _getFile(regularFileProperty);

		if (!file.exists()) {
			return new LinkedHashMap<>();
		}

		return _objectMapper.readValue(
			file,
			new TypeReference<LinkedHashMap<String, Object>>() {
			});
	}

	private static final ObjectMapper _objectMapper = new ObjectMapper();
	private static final ObjectMapper _yamlObjectMapper;

	static {
		DumperOptions dumperOptions = new DumperOptions();

		dumperOptions.setMaxSimpleKeyLength(1024);

		_yamlObjectMapper = new ObjectMapper(
			YAMLFactory.builder(
			).disable(
				YAMLGenerator.Feature.WRITE_DOC_START_MARKER
			).dumperOptions(
				dumperOptions
			).build());
	}

	private final RegularFileProperty _clientExtensionConfigFile;
	private final RegularFileProperty _dockerfile;
	private final Property<String> _image;
	private final RegularFileProperty _imageDigestFile;
	private final RegularFileProperty _lcpJsonFile;
	private final DirectoryProperty _outputDir;

}