import ClayForm, {ClayInput} from '@clayui/form';

import {FieldBase} from '../FieldBase';

import './LicensePriceCard.scss';
import unitedStatesIcon from '../../assets/icons/united-states.svg';

interface LicensePriceCard {
	price: string;
	currency:
		| string
		| string
		| {
				symbol: string;
				name: string;
		  };
}

export function LicensePriceCard({currency, price}: LicensePriceCard) {
	return (
		<div className="license-card-container">
			<ClayForm.Group>
				<div className="license-card-quantity">
					<FieldBase
						children={undefined}
						label="Quantity"
						required
						tooltip="Quantity info"
					/>

					<ClayInput.Group>
						<ClayInput.GroupItem>
							<div className="license-card-input-title">
								<span>From</span>
							</div>

							<ClayInput placeholder="1" type="text" />
						</ClayInput.GroupItem>

						<ClayInput.GroupItem>
							<div className="license-card-input-title">
								<span>To</span>
							</div>

							<ClayInput placeholder="-" type="text" />
						</ClayInput.GroupItem>
					</ClayInput.Group>
				</div>

				<div className="license-card-price">
					<FieldBase
						children={undefined}
						label="Price"
						required
						tooltip="Price info"
					/>

					<ClayInput.Group>
						<ClayInput.GroupItem prepend shrink>
							<ClayInput.GroupText>
								<img
										className="license-card-price-icon"
										src={unitedStatesIcon}
									/>
								USD
							</ClayInput.GroupText>
						</ClayInput.GroupItem>

						<ClayInput.GroupItem
							append
							className="license-card-price-currency-input"
						>
							<ClayInput placeholder="$100" type="text" />
						</ClayInput.GroupItem>

						<ClayInput.GroupItem>
							<div className="license-card-input-title license-card-input-title-total">
								<span>Total</span>
							</div>

							<ClayInput placeholder="$100" type="text" />
						</ClayInput.GroupItem>
					</ClayInput.Group>
				</div>
			</ClayForm.Group>
		</div>
	);
}
