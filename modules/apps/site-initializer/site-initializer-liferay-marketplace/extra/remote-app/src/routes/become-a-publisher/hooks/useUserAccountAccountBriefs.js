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

 import {useEffect, useState} from 'react';
 import {getUserAccountAccountBriefs} from '../services/UserAccountAccountBriefs';
 
 export function useUserAccountAccountBriefs() {
	 const [userAccountAccountBriefs, setUserAccountAccountBriefs] = useState([]);
	 const [loading, setLoading] = useState(true);
	 const [error, setError] = useState();
 
	 const _getUserAccountAccountBriefs = async () => {
		 try {
			 const response = await getUserAccountAccountBriefs();
 
			 setUserAccountAccountBriefs(response);
		 }
		 catch (error) {
			console.log(error);
			 setError(error);
		 }
		 setLoading(false);
	 };
 
	 useEffect(() => {
		_getUserAccountAccountBriefs();
		 // eslint-disable-next-line react-hooks/exhaustive-deps
	 }, []);
 
	 return {
		 error,
		 loading,
		 userAccountAccountBriefs,
	 };
 }
 