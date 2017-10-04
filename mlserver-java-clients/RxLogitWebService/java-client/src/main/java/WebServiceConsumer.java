import java.util.HashMap;

import io.swagger.client.ApiClient;
import io.swagger.client.ApiException;
import io.swagger.client.api.*;
import io.swagger.client.model.AccessTokenResponse;
import io.swagger.client.model.InputParameters;
import io.swagger.client.model.LoginRequest;
import io.swagger.client.model.OutputParameters;
import io.swagger.client.model.WebServiceResult;

public class WebServiceConsumer {

	public static void main(String[] args) {
		try
		{
			
			// Use auto-generated LoginRequest class to prepare Login request
			// You can enter default admin credentials OR LDAP credentials if configured
			// on the server. Here, we will use default "admin" user.
			LoginRequest loginRequest = new LoginRequest();
			loginRequest.setUsername("admin");
			loginRequest.setPassword("Your_Password");

			// Create apiClient client using Server URI
			// Here, we are using Machine Learning server on LOCALHOST:12800
			ApiClient apiClient = new ApiClient();
			apiClient.setBasePath("http://127.0.0.1:12800");
			UserApi api = new UserApi(apiClient);

			// Add the Bearer token to apiClient, that will be included
			// in headers for every request.
			AccessTokenResponse response = api.login(loginRequest);
			String bearerToken = response.getAccessToken();
			apiClient.setApiKey("Bearer " + bearerToken);

			// Instantiate instance of your WebService.
			RxLogitServiceApi serviceClient = new RxLogitServiceApi(apiClient);

			// A data.frame in R is a HashMap of <string, object> in Java
			HashMap<String, Object> dataframe = new HashMap<String, Object>();
			dataframe.put("Age", new int[]{ 71 });
			dataframe.put("Number", new int[] { 3 });
			dataframe.put("Start", new int[] { 5 });
			
			// Prepare input parameters for the web service.
			InputParameters parameters = new InputParameters();
			parameters.setData(dataframe);

			// Call web service and get the output from the execution result.
			WebServiceResult result = serviceClient.scoreRxLogit(parameters);
			OutputParameters outputs = result.getOutputParameters();
			Object score = outputs.getScore();

			System.out.println(score.toString());

		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
