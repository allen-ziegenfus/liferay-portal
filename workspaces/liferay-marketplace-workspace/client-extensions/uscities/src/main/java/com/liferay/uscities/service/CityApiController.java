package com.liferay.uscities.service;


import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping(value = "/city")
public class CityApiController {

	@Resource
	@Qualifier("mainDomain")
	String mainDomain;

	private List<CityDetail> _cityDetails;

	public CityApiController() throws IOException {
		_cityDetails = Arrays.asList(new ObjectMapper().readValue(CityApiController.class.getResourceAsStream("/USCities.json"), CityDetail[].class));
	}

	private static final Logger logger = LoggerFactory.getLogger(CityApiController.class);

	@ExceptionHandler(value = IOException.class)
    public ResponseEntity<String> handleResponseException(IOException ioException) {
		logger.error(ioException.getMessage());
        return new ResponseEntity<String>("Response exception: " + ioException.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }
	
	@GetMapping(value = "/search")
	public ResponseEntity<List<CityDetail>> search(@RequestParam(required = false) String city, @RequestParam(required=false) String state, @RequestParam(required=false) String zipcode) throws IOException {

		List<CityDetail> results = _cityDetails.stream().filter(detail -> {
			if (city == null || city.isEmpty())
				return true;
			else
				return Objects.equals(detail.city, city);
		}).filter(detail -> {
			if (state == null || state.isEmpty())
				return true;
			else
				return Objects.equals(detail.state, state);
		}).filter(detail -> {
			if (zipcode == null || zipcode.isEmpty())
				return true;
			else
				return Objects.equals(detail.zip_code, Integer.parseInt(zipcode));
		}).collect(Collectors.toList());
		
		return new ResponseEntity<List<CityDetail>>(results, HttpStatus.OK);
	}

}