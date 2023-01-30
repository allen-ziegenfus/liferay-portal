<div class="home-resources">
	<#if entries?has_content>
		<#list entries as navigationEntry>
			<#assign
				customFields = navigationEntry.getExpandoAttributes()!{}
				navItemIconId = customFields["SVG Sprite Map ID"]
			/>

			<div class="my-1 resource-container">
				<a class="align-items-center d-flex flex-column resource" href="${navigationEntry.getURL()}">
					<div class="circles">
						<@clay["icon"] symbol="${navItemIconId}" />
					</div>

					<h6 class="title">
						${navigationEntry.getName()}
					</h6>
				</a>
			</div>
		</#list>
	</#if>
</div>