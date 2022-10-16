package com.liferay.uscities.service;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility;

/**
 * {
      "zip_code": 501,
      "latitude": 40.922326,
      "longitude": -72.637078,
      "city": "Holtsville",
      "state": "NY",
      "county": "Suffolk"
    },
 */
@JsonAutoDetect(fieldVisibility = Visibility.ANY)
public class CityDetail {
	
	public int zip_code;
	public double latitude;
	public double longitude;
	public String city;
	public String state;
	public String county;

}