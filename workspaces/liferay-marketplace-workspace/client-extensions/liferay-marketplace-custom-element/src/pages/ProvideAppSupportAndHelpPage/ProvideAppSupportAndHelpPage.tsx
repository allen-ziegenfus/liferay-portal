import { Header } from '../../components/Header/Header';
import { Input } from '../../components/Input/Input';
import { NewAppPageFooterButtons } from '../../components/NewAppPageFooterButtons/NewAppPageFooterButtons';
import { Section } from '../../components/Section/Section';
import { useAppContext } from '../../manage-app-state/AppManageState';
import { TYPES } from '../../manage-app-state/actionTypes';
import './ProvideAppSupportAndHelpPage.scss';

interface ProvideAppSupportAndHelpPageProps {
	onClickBack: () => void;
	onClickContinue: () => void;
}

export function ProvideAppSupportAndHelpPage({
	onClickBack,
	onClickContinue,
}: ProvideAppSupportAndHelpPageProps) {
	const [_, dispatch] = useAppContext();

	return (
		<div className='provide-app-support-and-help-page-container'>
			<div className='provide-app-support-and-help-page-header'>
				<Header
					title='Provide app support and help'
					description='Inform the support and help references. This will impact how users will experience this app’s customer support and learning.'
				/>
			</div>

			<Section
				label='App Support and help'
				tooltip='More info'
				tooltipText='More Info'
			>
				<Input
					label='Support URL'
					placeholder='http:// Enter app name'
					required
				/>

				<Input
					label='Publisher website URL'
					placeholder='http:// Enter app name'
				/>

				<Input
					label='App usage terms (EULA) URL'
					placeholder='http:// Enter app name'
				/>

				<Input
					label='App documentation URL'
					placeholder='http:// Enter app name'
				/>

				<Input
					label='App installation and uninstallation guide URL'
					placeholder='http:// Enter app name'
				/>
			</Section>

			<NewAppPageFooterButtons
				showBackButton={true}
				onClickBack={() => onClickBack()}
				onClickContinue={() => {
					dispatch({
						type: TYPES.SUBMIT_APP_SUPPORT,
					});

					onClickContinue();
				}}
			/>
		</div>
	);
}
