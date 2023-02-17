const headers = {
	Authorization: 'Basic ' + btoa('test@liferay.com:test'),
	'Content-Type': 'application/json',
};

export function createApp({
	appDescription,
	appName,
	catalogId,
}: {
	appDescription: string;
	appName: string;
	catalogId: number;
}) {
	return fetch(
		'http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products',
		{
			body: JSON.stringify({
				active: true,
				catalogId,
				description: { en_US: appDescription },
				name: { en_US: appName },
				productType: 'simple',
			}),
			headers,
			method: 'POST',
		}
	);
}

export function createAttachment({
	body,
	externalReferenceCode,
}: {
	body: Object;
	externalReferenceCode: string;
}) {
	return fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products/by-externalReferenceCode/${externalReferenceCode}/attachments`,
		{
			body: JSON.stringify(body),
			headers,
			method: 'POST',
		}
	);
}

export function createImage({
	body,
	externalReferenceCode,
}: {
	body: Object;
	externalReferenceCode: string;
}) {
	return fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products/by-externalReferenceCode/${externalReferenceCode}/images`,
		{
			body: JSON.stringify(body),
			headers,
			method: 'POST',
		}
	);
}

export async function createProductSpecification({
	body,
	appId,
}: {
	body: Object;
	appId: string;
}) {
	const response = await fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products/${appId}/productSpecifications`,
		{
			body: JSON.stringify(body),
			headers,
			method: 'POST',
		}
	);
	return await response.json();
}

export async function createSpecification({ body }: { body: Object }) {
	const response = await fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/specifications`,
		{
			body: JSON.stringify(body),
			headers,
			method: 'POST',
		}
	);

	return await response.json();
}

export async function getCatalogs() {
	const response = await fetch(
		'http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/catalogs',
		{ headers, method: 'GET' }
	);

	return response.json();
}

export function patchAppByExternalReferenceCode({
	body,
	externalReferenceCode,
}: {
	body: Object;
	externalReferenceCode: string;
}) {
	return fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products/by-externalReferenceCode/${externalReferenceCode}/patchProductByExternalReferenceCode`,
		{
			body: JSON.stringify(body),
			headers,
			method: 'PATCH',
		}
	);
}
