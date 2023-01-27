<#include "${templatesPath}/SVG">

<div class="home-cards">
	<#if entries?has_content>
		<#list entries as navigationEntry>
			<#assign
				customFields = navigationEntry.getExpandoAttributes()!{}
				navItemIconId = customFields["SVG Sprite Map ID"]
			/>

			<div class="my-1">
				<a class="align-items-center d-flex product-card" href="${navigationEntry.getURL()}">
					<svg class="icon">
						<use xlink:href="#${navItemIconId}"></use>
					</svg>

					<h5 class="title">
						${navigationEntry.getName()}
					</h5>
				</a>
			</div>
		</#list>
	</#if>
</div>