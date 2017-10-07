package com.amazonaws.lambda.demo;

import java.math.BigDecimal;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import io.swagger.client.ApiClient;
import io.swagger.client.ApiException;
import io.swagger.client.api.RainServiceApi;
import io.swagger.client.api.UserApi;
import io.swagger.client.model.AccessTokenResponse;
import io.swagger.client.model.InputParameters;
import io.swagger.client.model.LoginRequest;
import io.swagger.client.model.OutputParameters;
import io.swagger.client.model.WebServiceResult;


public class LambdaFunctionHandler implements RequestHandler<Object, String> {

    @Override
    public String handleRequest(Object input, Context context) {
        context.getLogger().log("Input: " + input);
        return GetPrediction();
    }
    
    public static String GetPrediction()
    {
    	try
		{
			// Use auto-generated LoginRequest class to prepare Login request
			LoginRequest loginRequest = new LoginRequest();
			loginRequest.setUsername("admin");
			loginRequest.setPassword("Pa$$w0rd");

			// Create apiClient client using Server URI
			ApiClient apiClient = new ApiClient();
			apiClient.setBasePath("http://[Your_Server_Ip]:12800");
			UserApi api = new UserApi(apiClient);

			// Login with server and add the Bearer token to apiClient, that will be included
			// in headers for every request.
			AccessTokenResponse response = api.login(loginRequest);
			String bearerToken = response.getAccessToken();
			apiClient.setApiKey("Bearer " + bearerToken);

			// Instantiate instance of your WebService.
			RainServiceApi serviceClient = new RainServiceApi(apiClient);

			// Prepare input parameters for the web service.
			InputParameters parameters = new InputParameters();
			parameters.setZipcode(new BigDecimal(98052));

			// Call web service and get the output from the execution result.
			WebServiceResult result = serviceClient.consumeWebService(parameters);
			if (! result.getSuccess() || 
					(result.getErrorMessage() != null && result.getErrorMessage().length() > 0))
			{
				return "Something went wrong.... The error message is: " + result.getErrorMessage();
			}
			else 
			{
				OutputParameters outputs = result.getOutputParameters();
				BigDecimal score = (BigDecimal) outputs.getPred();

				String out = "There is " + score.toString() + " percent chance of rain today in your zipcode.";
				System.out.println(out);
				return out;
			}
		} catch (ApiException e) {
			e.printStackTrace();
			return "Something went wrong... " + e.getMessage();
		}
    }

}
