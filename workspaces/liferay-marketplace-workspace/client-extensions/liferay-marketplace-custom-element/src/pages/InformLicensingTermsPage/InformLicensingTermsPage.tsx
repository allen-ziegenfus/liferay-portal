import {useState} from 'react';
import {Header} from '../../components/Header/Header';
import {RadioCard} from '../../components/RadioCard/RadioCard';
import {Section} from '../../components/Section/Section';

import scheduleIcon from '../../assets/icons/schedule-icon.svg';
import pendingActionsIcon from '../../assets/icons/pending-actions-icon.svg';
import cancelIcon from '../../assets/icons/cancel-icon.svg';
import taskCheckedIcon from '../../assets/icons/task-checked-icon.svg';

import './InformLicensingTermsPage.scss';
import {NewAppPageFooterButtons} from '../../components/NewAppPageFooterButtons/NewAppPageFooterButtons';

interface InformLicensingTermsPageProps {
	onClickBack: () => void;
	onClickContinue: () => void;
}

export function InformLicensingTermsPage({
	onClickBack,
	onClickContinue,
}: InformLicensingTermsPageProps) {
	const [appLicense, setAppLicense] = useState(true);
	const [dayTrial, setDayTrial] = useState(false);

	return (
		<div className="informing-licensing-terms-page-container">
			<Header
				description="Define the licensing approach for your app. This will impact users' licensing renew experience."
				title="Inform licensing terms"
			/>

			<Section
				label="App License"
				required
				tooltip="More Info"
				tooltipText="More Info"
			>
				<div className="informing-licensing-terms-page-app-license-container">
					<RadioCard
						description="The app is offered in the Marketplace with no charge."
						selected={appLicense}
						onChange={() => {}}
						title="Perpetual License"
						tooltip="More Info"
						icon={scheduleIcon}
					/>

					<RadioCard
						description="License must be renewed annually."
						selected={appLicense}
						title="Non-perpetual license"
						tooltip="More Info"
						onChange={() => {}}
						icon={pendingActionsIcon}
					/>
				</div>
			</Section>

			<Section
				label="30-day Trial"
				tooltip="More Info"
				tooltipText="More Info"
				required
			>
				<div className="informing-licensing-terms-page-day-trial-container">
					<RadioCard
						description="Offer a 30-day free trial for this app"
						title="Yes"
						icon={taskCheckedIcon}
						selected={dayTrial}
						onChange={() => {}}
						tooltip="More Info"
					/>

					<RadioCard
						description="Do not offer a 30-day free trial"
						title="No"
						icon={cancelIcon}
						selected={dayTrial}
						onChange={() => {}}
						tooltip="More Info"
					/>
				</div>
			</Section>

			<NewAppPageFooterButtons
				onClickBack={() => onClickBack()}
				onClickContinue={() => onClickContinue()}
				showBackButton
			/>
		</div>
	);
}
