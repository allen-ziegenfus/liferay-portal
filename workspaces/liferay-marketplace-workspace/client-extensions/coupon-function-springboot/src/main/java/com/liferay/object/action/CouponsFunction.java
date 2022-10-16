package com.liferay.object.action;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RequestMapping(value = "/coupons")
@RestController
public class CouponsFunction {

  @Qualifier("mainDomain")
  @Resource
  private String _mainDomain;

  @PostMapping(
      consumes = MediaType.APPLICATION_JSON_VALUE,
      produces = MediaType.APPLICATION_JSON_VALUE,
      value = "/issued")
  public ResponseEntity<String> create(
      @AuthenticationPrincipal Jwt jwt,
      @RequestBody String json)
    throws JsonMappingException, JsonProcessingException {

    System.out.println("JWT ID: " + jwt.getId());
    System.out.println("JWT SUBJECT: " + jwt.getSubject());
    System.out.println("JWT CLAIMS: " + jwt.getClaims());

    ObjectMapper objectMapper = new ObjectMapper();
    JsonNode jsonNode = objectMapper.readTree(json);

    JsonNode objectEntry = jsonNode.get("objectEntry");
    String objectEntryName = objectEntry.get("values").get("code").asText();
    String statusByUserName = objectEntry.get("statusByUserName").asText();

    String status = "not issued";

    try {
      status = jsonNode.get("objectEntry").get("values").get("issued").asText();
    }
    catch (Throwable t) {}

    String updatedDate = "";

    try {
      updatedDate = jsonNode.get("objectEntry").get("modifiedDate").asText();
    }
    catch (Throwable t) {
      try {
        updatedDate = jsonNode.get("objectEntry").get("createDate").asText();
      }
      catch (Throwable t2) {}
    }

    String msg = String.format("The status coupon '%s' change to '%s' by '%s' at '%s'", objectEntryName, status, statusByUserName, updatedDate);
    System.out.println(msg);
    return new ResponseEntity<>(msg, HttpStatus.CREATED);
  }

}
