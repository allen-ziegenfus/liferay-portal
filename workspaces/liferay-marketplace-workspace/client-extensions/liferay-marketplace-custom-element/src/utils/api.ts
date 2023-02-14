const headers = {
	Authorization: 'Basic ' + btoa('test@liferay.com:test'),
	'Content-Type': 'application/json',
};

export function createApp({
	appDescription,
	appName,
}: {
	appDescription: string;
	appName: string;
}) {
	return fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products`,
		{
			body: JSON.stringify({
				active: true,
				catalogId: 43495,
				description: { en_US: appDescription },
				name: { en_US: appName },
				productType: 'simple',
			}),
			headers,
			method: 'POST',
		}
	);
}

export function submitAttachment({
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

export function submitImage({
	body,
	externalReferenceCode,
}: {
	body: Object;
	externalReferenceCode: string;
}) {
	return fetch(
		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products/by-externalReferenceCode/${externalReferenceCode}/images/by-url`,
		{
			body: JSON.stringify(body),
			headers,
			method: 'POST',
		}
	);
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

// export function putProductCategoriesTags({
// 	appDescription,
// 	appName,
// }: {
// 	appDescription: string;
// 	appName: string;
// }) {
// 	return fetch(
// 		`http://localhost:8080/o/headless-admin-taxonomy/v1.0/sites/${1}/keywords`,
// 		{
// 			body: JSON.stringify({
// 				active: true,
// 				catalogId: 40716,
// 				productType: 'simple',
// 			}),
// 			headers,
// 			method: 'POST',
// 		}
// 	);
// }

// export async function putProductSpecification({
// 	id,
// 	specificationKey,
// 	value,
// }: {
// 	id: string;
// 	specificationKey: string;
// 	value: LocalizedValue;
// }) {
// 	return await fetch(
// 		`http://localhost:8080/o/headless-commerce-admin-catalog/v1.0/products/sd/productSpecifications`,
// 		{
// 			body: JSON.stringify({
// 				id,
// 				specificationKey,
// 				value,
// 			}),
// 			headers,
// 			method: 'POST',
// 		}
// 	);
// }
