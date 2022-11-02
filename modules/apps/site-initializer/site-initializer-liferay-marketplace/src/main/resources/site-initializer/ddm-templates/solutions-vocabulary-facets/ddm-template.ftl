<style>
.solutions-vocab-facet {
	border-radius: 10px;
}

.solutions-vocab-facet .panel a {
	padding: 1rem;
}

.solutions-vocab-facet .collapse-icon .collapse-icon-closed .lexicon-icon,
.solutions-vocab-facet .collapse-icon .collapse-icon-open .lexicon-icon {
	margin-top: 0.3rem;
}

.solutions-vocab-facet .panel-body {
	padding: 0.5rem 1rem 1rem;
}

.solutions-vocab-facet .list-unstyled {
	margin-bottom: 0;
}
</style>

<#assign
	VOCABULARY_IDS = {
	  "Category": ["449603954", [449603965, 449603971, 449603959, 449603977, 449603983, 449603956, 449603986, 449603980, 449603968, 449603974, 449603962]],
	  "Tag": ["449603955", [449854803, 449854800, 449854764, 449854727, 449854712, 449854797, 449854718, 449854794, 449854694, 449854706, 449854767, 449854776, 449854709, 449875575, 449854752, 449854770, 449854697, 449874752, 449854782, 449854758, 449854721, 449854779, 449854730, 449854749, 449854703, 449854739, 449854791, 449854736, 449854755, 449854785, 449919456, 449854746, 449875956, 449919453, 449854806, 450005681, 449854788, 450005684, 449854715, 449875607, 450005678, 449854724, 449854700, 449813792]]
	}
/>

<#macro getVocabularyFacet
	categoryIds
	vocabIdString
	vocabName
>
	<#assign
		vocabId = vocabIdString?number
		vocabName = languageUtil.get(locale, vocabName)
	/>

	<#if entries?has_content>
		<@liferay_ui["panel-container"]
			cssClass="solutions-vocab-facet bg-white border-radius-xlarge my-2"
			extended=true
			id="${namespace + 'facetAssetCategoriesPanelContainer' + vocabId}"
			markupView="lexicon"
			persistState=true
		>
			<@liferay_ui.panel
				collapsible=true
				cssClass="font-size-paragraph-small font-weight-semi-bold search-facet"
				extended=!browserSniffer.isMobile(request)
				id="${namespace + 'facetAssetCategoriesPanel' + vocabId}"
				markupView="lexicon"
				persistState=true
				title="${vocabName?upper_case}"
			>
				<ul class="list-unstyled">
					<#list entries?sort_by("displayName") as entry>
						<#if categoryIds?seq_contains(entry.getAssetCategoryId())>
							<li class="color-neutral-2 facet-value py-1">
								<div class="custom-checkbox custom-control">
									<label class="facet-checkbox-label" for="${namespace}_term_${entry.getAssetCategoryId()}">
										<input
											${(entry.isSelected())?then("checked","")}
											class="custom-control-input facet-term"
											data-term-id="${entry.getAssetCategoryId()}"
											disabled
											id="${namespace}_term_${entry.getAssetCategoryId()}"
											name="${namespace}_term_${entry.getAssetCategoryId()}"
											onChange="Liferay.Search.FacetUtil.changeSelection(event);"
											type="checkbox"
										/>

										<span class="custom-control-label font-size-paragraph-small term-name ${(entry.isSelected())?then('facet-term-selected', 'facet-term-unselected')}" style="line-height: normal;">
											<span class="custom-control-label-text">${htmlUtil.escape(entry.getDisplayName())}</span>
										</span>
									</label>
								</div>
							</li>
						</#if>
					</#list>
				</ul>
			</@>
		</@>
	</#if>
</#macro>

<#list VOCABULARY_IDS as VOCABULARY_NAME, VOCABULARY_ID_CATEGORIES>
<@getVocabularyFacet
	categoryIds=VOCABULARY_ID_CATEGORIES[1]
	vocabIdString="${VOCABULARY_ID_CATEGORIES[0]}"
	vocabName="${VOCABULARY_NAME}"
/>
</#list>