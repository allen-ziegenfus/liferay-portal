import { useState } from 'react';

import aCoLibraries from '../../assets/images/a&co-libraries.svg';
import { Header } from '../../components/Header/Header';
import { NewAppPageFooterButtons } from '../../components/NewAppPageFooterButtons/NewAppPageFooterButtons';
import { Section } from '../../components/Section/Section';
import { Checkbox } from '../../components/Checkbox/Checkbox';
import { useAppContext } from '../../manage-app-state/AppManageState';
import { TYPES } from '../../manage-app-state/actionTypes';
import { CardSection } from './CardSection';
import { initialReviewAndSubmitAppPageItems } from './ReviewAndSubmitAppPageUtil';
import './ReviewAndSubmitAppPage.scss';

interface ReviewAndSubmitAppPageProps {
	onClickBack: () => void;
	onClickContinue: () => void;
	readonly?: boolean;
}

export function ReviewAndSubmitAppPage({
	readonly = false,
	onClickBack,
	onClickContinue,
}: ReviewAndSubmitAppPageProps) {
	const [_, dispatch] = useAppContext();
	const [checked, setChecked] = useState(false);

	return (
		<div className='review-and-submit-app-page-container'>
			{!readonly && (
				<div className='review-and-submit-app-page-header'>
					<Header
						title='Review and submit app'
						description='Please, review before submitting. Once sent, you will not be able to edit any information until this submission is completely reviewed by Liferay.'
					/>
				</div>
			)}

			<Section
				disabled={readonly}
				label={!readonly ? 'App Submission' : ''}
				required
				tooltip={!readonly ? 'More info' : ''}
				tooltipText={!readonly ? 'More Info' : ''}
			>
				<div className='review-and-submit-app-page-card-container'>
					{!readonly && (
						<div className='review-and-submit-app-page-card-header'>
							<div className='review-and-submit-app-page-card-header-left-content'>
								<div className='review-and-submit-app-page-card-header-icon-container'>
									<img
										src={aCoLibraries}
										alt='Document Icon'
									/>
								</div>

								<div className='review-and-submit-app-page-card-header-title'>
									<span className='review-and-submit-app-page-card-header-title-text'>
										A&Co Libraries
									</span>
									<span className='review-and-submit-app-page-card-header-title-version'>
										v0.0.1
									</span>
								</div>
							</div>
						</div>
					)}

					<div className='review-and-submit-app-page-card-body'>
						<CardSection
							localized
							enableEdit={!readonly}
							paragraph='Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id dolor id nibh ultricies vehicula ut id elit. Curabitur blandit tempus porttitor.'
							required
							sectionName='Description'
						/>

						{initialReviewAndSubmitAppPageItems.map((item) => {
							return (
								<CardSection
									build={item.section === 'Build'}
									cardDescription={item.description}
									cardInfo={item.cardInfos}
									cardLink={item.section === 'Support & Help'}
									cardTags={item.cardTags}
									cardTitle={item.title}
									cardView={
										item.section === 'Pricing' ||
										item.section === 'Licensing'
									}
									description={item.description}
									enableEdit={!readonly}
									files={item.files}
									icon={item.icon}
									required
									sectionName={item.section}
									storefront={item.section === 'Storefront'}
									tags={item.tags}
									title={
										item.section === 'Build'
											? item.fileName
											: item.title
									}
									version={item.version}
								/>
							);
						})}
					</div>
				</div>
			</Section>

			{!readonly && (
				<div className='review-and-submit-app-page-agreement'>
					<Checkbox
						checked={checked}
						onChange={() => {
							setChecked(!checked);
						}}
					></Checkbox>
					<span>
						<span className='review-and-submit-app-page-agreement-highlight'>
							{'Attention: this cannot be undone. '}
						</span>
						I am aware I cannot edit any data or information
						regarding this app submission until Liferay completes
						its review process and I agree with the Liferay
						Marketplace <a href='#'>terms</a> and{' '}
						<a href='#'>privacy</a>
					</span>
				</div>
			)}

			{!readonly && (
				<NewAppPageFooterButtons
					continueButtonText='Submit App'
					disableContinueButton={!checked}
					showBackButton={true}
					onClickBack={() => onClickBack()}
					onClickContinue={() => {
						dispatch({
							type: TYPES.SUBMIT_APP,
						});

						onClickContinue();
					}}
				/>
			)}
		</div>
	);
}
