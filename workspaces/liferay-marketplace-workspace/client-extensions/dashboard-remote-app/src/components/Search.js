/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

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
