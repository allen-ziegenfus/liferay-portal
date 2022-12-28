import React from 'react';

import ClayButton, {ClayButtonWithIcon} from '@clayui/button';
import {ClayInput} from '@clayui/form';
import ClayLayout from '@clayui/layout';
import getIconSpriteMap from './getIconSpriteMap';

function Search({handleClearSearch, handleKeyPress, searchTerm, totalCount}) {
	return (
        <>
            <ClayLayout.Row justify="between">
                <ClayLayout.Col size={3}>
                    <ClayInput.Group>
                        <ClayInput.GroupItem>
                            <ClayInput
                                aria-label="Search"
                                className="form-control input-group-inset input-group-inset-after"
                                id="searchInput"
                                onKeyUp={handleKeyPress}
                                placeholder="Search"
                                type="text"
                            />
                            <ClayInput.GroupInsetItem after tag="span">
                                {searchTerm &&
                                    <ClayButtonWithIcon
                                        aria-label="Close search"
                                        displayType="unstyled"
                                        onClick={handleClearSearch}
                                        spritemap={getIconSpriteMap()}
                                        symbol="times"
                                    />
                                }
                                {!searchTerm &&
                                    <ClayButtonWithIcon
                                        aria-label="Search"
                                        displayType="unstyled"
                                        onClick={handleKeyPress}
                                        spritemap={getIconSpriteMap()}
                                        symbol="search"
                                        type="submit"
                                    />
                                }
                            </ClayInput.GroupInsetItem>
                        </ClayInput.GroupItem>
                    </ClayInput.Group>
                </ClayLayout.Col>

                <ClayLayout.Col>
                    <ClayLayout.Row justify="end">
                        <ClayButton
                            aria-label="Add"
                            className="nav-btn nav-btn-monospaced py-3 px-3"
                            displayType="primary"
                        >
                            New App
                        </ClayButton>
                    </ClayLayout.Row>
                </ClayLayout.Col>
            </ClayLayout.Row>

            {searchTerm && 
                <div className="search-results">
                    {totalCount} results for "{searchTerm}"
                </div>            
            }
        </>
	);
}

export default Search;
