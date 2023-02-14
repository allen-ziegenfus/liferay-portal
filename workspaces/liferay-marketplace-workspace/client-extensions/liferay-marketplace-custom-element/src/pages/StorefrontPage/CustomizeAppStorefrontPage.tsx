import { filesize } from 'filesize';
import { uniqueId } from 'lodash';
import { useState } from 'react';

import { DropzoneUpload } from '../../components/DropzoneUpload/DropzoneUpload';
import { FileList, UploadedFile } from '../../components/FileList/FileList';
import { Header } from '../../components/Header/Header';
import { NewAppPageFooterButtons } from '../../components/NewAppPageFooterButtons/NewAppPageFooterButtons';
import { Section } from '../../components/Section/Section';
import { useAppContext } from '../../manage-app-state/AppManageState';
import { TYPES } from '../../manage-app-state/actionTypes';
import './CustomizeAppStorefrontPage.scss';

const acceptFileTypes = {
	'image/*': ['.png', '.svg', '.jpg'],
};

interface CustomizeAppStorefrontPageProps {
	onClickBack: () => void;
	onClickContinue: () => void;
}

export function CustomizeAppStorefrontPage({
	onClickBack,
	onClickContinue,
}: CustomizeAppStorefrontPageProps) {
	const [_, dispatch] = useAppContext();

	const [uploadedFiles, setUploadedFiles] = useState<UploadedFile[]>([]);

	const updateFile = (id: string, data: UploadedFile) => {
		const newUploadedFiles = uploadedFiles.map((uploadedFile) => {
			if (uploadedFile.id === id) {
				return {
					...uploadedFile,
					...data,
				};
			}

			return uploadedFile;
		});

		setUploadedFiles(newUploadedFiles);
	};

	const processUpload = (uploadedFile: UploadedFile) => {
		const data = new FormData();

		data.append('file', uploadedFile.file, uploadedFile.fileName);

		// api.post().then().catch()...
	};

	const handleUpload = (files: File[]) => {
		if (uploadedFiles.length < 5) {
			const newUploadedFiles: UploadedFile[] = files.map((file) => ({
				file,
				id: uniqueId(),
				fileName: file.name,
				readableSize: filesize(file.size),
				preview: URL.createObjectURL(file),
				progress: 0,
				uploaded: true,
				error: false,
			}));

			setUploadedFiles([...uploadedFiles, ...newUploadedFiles]);

			// await api.post();
			//processUpload();
		}
	};

	const handleDelete = (id: string) => {
		// await api.delete()

		setUploadedFiles(
			uploadedFiles.filter((uploadedFile) => uploadedFile.id !== id)
		);
	};

	return (
		<div className='storefront-page-container'>
			<Header
				title='Customize app storefront'
				description='Design the storefront for your app. This will set the information displayed on ths app’s page.'
			/>

			<Section
				required
				label='App Storefront'
				tooltip='More Info'
				tooltipText='More Info'
			>
				<div className='storefront-page-info-container'>
					<span className='storefront-page-info-text'>
						Add up to 5 images
					</span>

					{!!uploadedFiles.length && (
						<button
							className='storefront-page-info-button'
							onClick={() => setUploadedFiles([])}
						>
							Remove all
						</button>
					)}
				</div>

				<FileList
					onDelete={handleDelete}
					type='image'
					uploadedFiles={uploadedFiles}
				/>

				<DropzoneUpload
					acceptFileTypes={acceptFileTypes}
					buttonText='Select a file'
					description='Only gif, jpg, png are allowed. Max file size is 5MB '
					maxFiles={5}
					maxSize={5000000}
					multiple={true}
					onHandleUpload={handleUpload}
					title='Drag and drop to upload or'
				/>
			</Section>

			<NewAppPageFooterButtons
				onClickBack={() => onClickBack()}
				onClickContinue={() => {
					dispatch({
						type: TYPES.SUBMIT_APP_STOREFRONT,
					});

					onClickContinue();
				}}
			/>
		</div>
	);
}
