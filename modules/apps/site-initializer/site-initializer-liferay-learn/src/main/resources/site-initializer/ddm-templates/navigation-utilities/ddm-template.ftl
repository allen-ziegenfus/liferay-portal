<ul class="adt-navigation">
	<#if entries?has_content>
		<#list entries as navPrimaryItem>
			<li class="adt-nav-item w-100">
				<div class="adt-nav-text d-flex focusable" tabindex="3">
					<span class="adt-nav-title text-truncate">
						${navPrimaryItem.getName()}
					</span>
					<span class="adt-nav-caret-bottom-icon align-self-center">
						<svg class="lexicon-icon lexicon-icon-caret-bottom" role="presentation" viewBox="0 0 512 512"><use xlink:href="/o/admin-theme/images/clay/icons.svg#caret-bottom"></use></svg>
					</span>
					<span class="adt-nav-caret-top-icon align-self-center">
						<svg class="lexicon-icon lexicon-icon-caret-top" role="presentation" viewBox="0 0 512 512"><use xlink:href="/o/admin-theme/images/clay/icons.svg#caret-top"></use></svg>
					</span>
				</div>
				<@render_navigation_dropdown navPrimaryItem />
			</li>
		</#list>
	</#if>
</ul>

<#macro render_navigation_dropdown
	navPrimaryItem
>
	<div class="adt-submenu">
		<div class="adt-submenu-outer-wrapper">
			<div class="adt-submenu-inner-wrapper">
				<#list navPrimaryItem.getChildren() as navSecondaryItem>
					<#assign
						secondaryCustomFields = (expandoHelper.getLocalizedExpandoValues(navSecondaryItem.getExpandoAttributes(), locale))!{}
						backgroundColor = secondaryCustomFields["Submenu Background"]!""
						childColumns = secondaryCustomFields["Submenu Child Columns"]!""
						columnSpan = secondaryCustomFields["Submenu Column Span"]!""
					/>

					<#if childColumns?has_content>
						<#assign childColumns = (columnSpan?number/childColumns?number)?floor?string />
					</#if>

					<#if columnSpan?has_content>
						<#assign columnSpan = "_" + columnSpan + "-section-span" />
					</#if>

					<ul class="adt-submenu-section ${backgroundColor} ${columnSpan}">
						<li class="adt-submenu-header color-neutral-8 font-size-small-caps">${navSecondaryItem.getName()}</li>

						<#list navSecondaryItem.getChildren() as navTertiaryItem>
							<#assign
								values = (expandoHelper.getLocalizedExpandoValues(navTertiaryItem.getExpandoAttributes(), locale))!{}
								descriptionText = values["Menu Item Description"]!""
								imageURL = values["Menu Item Image URL"]!""
								menuItemType = values["Menu Item Type"]!""
								preheaderText = values["Menu Item Preheader"]!""
							/>

							<li class="adt-submenu-item-content ${menuItemType?lower_case}-type grid-column-span-${childColumns}">
								<a class="adt-submenu-item-link" href="${navTertiaryItem.getURL()}" tabindex="3">
									<#if stringUtil.equals(menuItemType, "Image") && imageURL?has_content>
										<img class="adt-submenu-item-image" loading="lazy" src="${imageURL}" />
									</#if>

									<div class="adt-submenu-item-text">
										<#if stringUtil.equals(menuItemType, "Image") && preheaderText?has_content>
											<div class="adt-submenu-item-preheader color-neutral-3 font-weight-semi-bold">${preheaderText}</div>
										</#if>

										<#if stringUtil.equals(menuItemType, "Image")>
											<div class="adt-submenu-item-title font-size-paragraph-small font-weight-semi-bold">${navTertiaryItem.getName()}</div>
										<#else>
											<div class="adt-submenu-item-title font-size-paragraph-base font-weight-semi-bold">${navTertiaryItem.getName()}</div>
										</#if>

										<#if (menuItemType == '' || stringUtil.equals(menuItemType, "Text")) && descriptionText?has_content>
											<div class="adt-submenu-item-description color-neutral-2 font-size-paragraph-xsmall">${descriptionText}</div>
										</#if>
									</div>
								</a>
							</li>
						</#list>
					</ul>
				</#list>
			</div>
		</div>
	</div>
</#macro>