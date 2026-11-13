/**
 * SPDX-FileCopyrightText: (c) 2026 Liferay, Inc. https://liferay.com
 * SPDX-License-Identifier: LGPL-2.1-or-later OR LicenseRef-Liferay-DXP-EULA-2.0.0-2023-06
 */

package com.liferay.gradle.plugins.workspace.task;

import com.bmuschko.gradle.docker.tasks.image.DockerPushImage;

import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.command.InspectImageCmd;
import com.github.dockerjava.api.command.InspectImageResponse;

import com.liferay.gradle.plugins.workspace.internal.client.extension.ClientExtensionDescriptor;

import java.io.File;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.gradle.api.GradleException;
import org.gradle.api.Project;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.file.ProjectLayout;
import org.gradle.api.file.RegularFile;
import org.gradle.api.file.RegularFileProperty;
import org.gradle.api.model.ObjectFactory;
import org.gradle.api.provider.SetProperty;
import org.gradle.api.tasks.OutputFile;
import org.gradle.api.tasks.TaskOutputs;

/**
 * @author Gregory Amerson
 */
public class PushClientExtensionImageTask extends DockerPushImage {

	public PushClientExtensionImageTask() {
		Project project = getProject();

		ObjectFactory objectFactory = project.getObjects();

		_imageDigestFile = objectFactory.fileProperty();

		ProjectLayout projectLayout = project.getLayout();

		DirectoryProperty buildDirectoryProperty =
			projectLayout.getBuildDirectory();

		_imageDigestFile.convention(
			buildDirectoryProperty.file("client-extension-image/digest"));

		TaskOutputs taskOutputs = getOutputs();

		taskOutputs.upToDateWhen(task -> false);
	}

	@OutputFile
	public RegularFileProperty getImageDigestFile() {
		return _imageDigestFile;
	}

	@Override
	public void runRemoteCommand() throws Exception {
		SetProperty<String> imagesSetProperty = getImages();

		Set<String> images = imagesSetProperty.get();

		if (images.isEmpty()) {
			throw new GradleException(
				"Set the liferay.workspace.client.extension.registry " +
					"property and a version to publish \"" +
						getProject().getName() + "\"");
		}

		super.runRemoteCommand();

		Iterator<String> iterator = images.iterator();

		String image = iterator.next();

		String digest = _getDigest(
			image, ClientExtensionDescriptor.getRepository(image));

		RegularFile regularFile = _imageDigestFile.get();

		File file = regularFile.getAsFile();

		File parentFile = file.getParentFile();

		parentFile.mkdirs();

		Files.write(file.toPath(), digest.getBytes(StandardCharsets.UTF_8));
	}

	private String _getDigest(String image, String imageRepository) {
		DockerClient dockerClient = getDockerClient();

		InspectImageCmd inspectImageCmd = dockerClient.inspectImageCmd(image);

		InspectImageResponse inspectImageResponse = inspectImageCmd.exec();

		List<String> repoDigests = inspectImageResponse.getRepoDigests();

		if (repoDigests != null) {
			for (String repoDigest : repoDigests) {
				if (repoDigest.startsWith(imageRepository + "@")) {
					return repoDigest.substring(imageRepository.length() + 1);
				}
			}
		}

		throw new GradleException(
			"Unable to find the digest of \"" + image + "\" after pushing it");
	}

	private final RegularFileProperty _imageDigestFile;

}