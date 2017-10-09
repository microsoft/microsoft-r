package com.mlsdemo.chatbot;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JEditorPane;
import javax.swing.JTextPane;
import javax.swing.ScrollPaneConstants;

import io.swagger.client.ApiClient;
import io.swagger.client.ApiException;
import io.swagger.client.api.AuthenticationAPIsApi;
import io.swagger.client.api.SessionAPIsApi;
import io.swagger.client.model.AccessTokenResponse;
import io.swagger.client.model.CreateSessionRequest;
import io.swagger.client.model.CreateSessionRequest.RuntimeTypeEnum;
import io.swagger.client.model.CreateSessionResponse;
import io.swagger.client.model.ExecuteRequest;
import io.swagger.client.model.ExecuteResponse;
import io.swagger.client.model.LoginRequest;
import io.swagger.client.model.WorkspaceObject;

import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class ChatClient {

	private JFrame frame;
	private JEditorPane inputMsg;
	private JTextPane chatPane;
	
	private static final String mlserver = "http://[Your-Server-IP]:12800";
	private static final String username = "admin";
	private static final String password = "Pa$$w0rd";
	private static final String snapshotId = "your-snapshot-GUID";
	
	private String bearerToken = null;
	private String sessionId = null;
	private String chats = "";

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					ChatClient window = new ChatClient();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public ChatClient() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent arg0) {
				CloseSession();
			}
		});
		frame.setBounds(100, 100, 641, 437);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		chatPane = new JTextPane();
		chatPane.setEditable(false);
		chatPane.setBounds(10, 11, 414, 207);
		frame.getContentPane().add(chatPane);
		
		JButton btnSend = new JButton("Guess");
		btnSend.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
			}
		});
		btnSend.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				if (sessionId != null)
				{
					SendTextAndReceiveBotResponse();
				}
			}
		});
		btnSend.setBounds(522, 364, 93, 23);
		frame.getContentPane().add(btnSend);
		
		inputMsg = new JEditorPane();
		inputMsg.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent arg0) {
				if (arg0.getKeyCode() == KeyEvent.VK_ENTER)
				{
					if (sessionId != null)
					{
						SendTextAndReceiveBotResponse();
					}
				}
			}
		});
		inputMsg.setBounds(10, 367, 502, 20);
		frame.getContentPane().add(inputMsg);
		
		JScrollPane scrollPane = new JScrollPane(chatPane);
		scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setBounds(10, 11, 605, 342);
		frame.getContentPane().add(scrollPane);
		frame.getRootPane().setDefaultButton(btnSend);
		
		if (login()) CreateSession();
		if (sessionId == null)
			chatPane.setText(("Comething went wrong..."));
		else {
			chats += GetWelcomeMessage();
			chatPane.setText(chats);
		}
	}
	
	private void SendTextAndReceiveBotResponse()
	{
		String input = inputMsg.getText().trim();
		Matcher matcher = Pattern.compile("\\d+").matcher(input);
		matcher.find();
		int num = Integer.valueOf(matcher.group());
		
		chats += ("ME: " + input + "\n");
		String reply = GuessExecution(num);
		chats += ("BOT: " + reply + "\n");
		if (NumberIsGuessed(reply))
		{
			chats += GetWelcomeMessage();
		}
		chatPane.setText(chats);
		chatPane.setCaretPosition(chats.length());
		inputMsg.setText("");
	}
	
	private String GetWelcomeMessage()
	{
		return "\n===============================================================================\n" +
				"BOT: Welcome to the MLS Demo Chat Bot. I have a number between 1-100. Can you try to guess it?\n" +
				"==============================================================================\n";
	}
	
	private Boolean NumberIsGuessed(String response)
	{
		return response.contains("guessed");
	}
	
	private Boolean login()
	{
		try {

			ApiClient apiClient = new ApiClient();
			apiClient.setBasePath(mlserver);
			AuthenticationAPIsApi authApi = new AuthenticationAPIsApi(apiClient);
			
			LoginRequest loginRequest = new LoginRequest();
			loginRequest.setUsername(username);
			loginRequest.setPassword(password);
		
			AccessTokenResponse response = authApi.login(loginRequest);
			bearerToken = response.getAccessToken();
			return true;

		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
			return false;
		}
	}
	
	private void CreateSession()
	{
		ApiClient apiClient = getAuthenticatedClient();
		
		SessionAPIsApi sessionApi = new SessionAPIsApi(apiClient);
		try {
			CreateSessionRequest req = new CreateSessionRequest();
			req.setRuntimeType(RuntimeTypeEnum.R);
			req.setSnapshotId(snapshotId);
			CreateSessionResponse response = sessionApi.createSession(req);
			sessionId = response.getSessionId();
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private ApiClient getAuthenticatedClient()
	{
		if (bearerToken == null)
		{
			login();
		}
		ApiClient apiClient = new ApiClient();
		apiClient.setBasePath(mlserver);
		apiClient.addDefaultHeader("Authorization", "Bearer " + bearerToken);
		apiClient.getHttpClient().setConnectTimeout(120, TimeUnit.SECONDS);
		apiClient.getHttpClient().setReadTimeout(120, TimeUnit.SECONDS);
		apiClient.getHttpClient().setWriteTimeout(120,  TimeUnit.SECONDS);
		return apiClient;
	}
	
	private String GuessExecution(int number)
	{
		SessionAPIsApi sessionApi = new SessionAPIsApi(getAuthenticatedClient());
		ExecuteRequest req = new ExecuteRequest();
		req.setCode("res <- guess(mynum);");
		
		WorkspaceObject inputObj = new WorkspaceObject();
		inputObj.setName("mynum");
		inputObj.setValue(number);
		
		
		ArrayList<WorkspaceObject> inputs = new ArrayList<WorkspaceObject>();
		inputs.add(inputObj);
		ArrayList<String> outputs = new ArrayList<String>();
		outputs.add("res");
		
		req.setInputParameters(inputs);
		req.setOutputParameters(outputs);
		try {
			ExecuteResponse response = sessionApi.executeCode(sessionId, req);
			WorkspaceObject op = response.getOutputParameters().get(0);
			return ((ArrayList<String>)op.getValue()).get(0).toString();
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "Error: " + e.getMessage();
		}
	}
	
	private void CloseSession()
	{
		if (sessionId != null)
		{
			try {
				
				SessionAPIsApi sessionApi = new SessionAPIsApi(getAuthenticatedClient());
				sessionApi.closeSession(sessionId);
				
			} catch (ApiException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
