package mlserver.remoteExecute;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

import io.swagger.client.ApiClient;
import io.swagger.client.ApiException;
import io.swagger.client.api.AuthenticationAPIsApi;
import io.swagger.client.api.SessionAPIsApi;
import io.swagger.client.api.SnapshotAPIsApi;
import io.swagger.client.model.AccessTokenResponse;
import io.swagger.client.model.CreateSessionRequest;
import io.swagger.client.model.CreateSessionRequest.RuntimeTypeEnum;
import io.swagger.client.model.CreateSessionResponse;
import io.swagger.client.model.CreateSnapshotRequest;
import io.swagger.client.model.CreateSnapshotResponse;
import io.swagger.client.model.ExecuteRequest;
import io.swagger.client.model.ExecuteResponse;
import io.swagger.client.model.LoginRequest;

import javax.swing.JComboBox;
import javax.swing.JButton;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JTextArea;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import javax.swing.JTextPane;
import javax.swing.ScrollPaneConstants;

import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.JScrollPane;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class RemoteExecuteApp {

	private JFrame frmMlsRemote;
	private JPasswordField password;
	private JTextField username;
	private JTextField mlsServer;
	private JComboBox environment;
	private JButton executeBtn;
	private JTextArea consoleOp;
	private JEditorPane code;
	JTextPane filePath;
	
	private String bearerToken = null;
	private String sessionId = null;
	private JButton btnSessionSnapshot;
	private JButton btnCopy;
	

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					RemoteExecuteApp window = new RemoteExecuteApp();
					window.frmMlsRemote.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public RemoteExecuteApp() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frmMlsRemote = new JFrame();
		frmMlsRemote.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosed(WindowEvent e) {
				CloseSession();
			}
		});
		frmMlsRemote.setFont(new Font("Dialog", Font.BOLD, 12));
		frmMlsRemote.setResizable(false);
		frmMlsRemote.setTitle("MLS 9.2.1 Remote Execution Java Client");
		frmMlsRemote.setBounds(100, 100, 763, 471);
		frmMlsRemote.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmMlsRemote.getContentPane().setLayout(null);
		
		JLabel lblUsername = new JLabel("USER NAME");
		lblUsername.setBounds(262, 13, 69, 14);
		frmMlsRemote.getContentPane().add(lblUsername);
		
		JLabel lblPassword = new JLabel("PASSWORD");
		lblPassword.setBounds(406, 13, 73, 14);
		frmMlsRemote.getContentPane().add(lblPassword);
		
		password = new JPasswordField();
		password.setBounds(480, 10, 74, 20);
		frmMlsRemote.getContentPane().add(password);
		
		username = new JTextField();
		username.setText("admin");
		username.setBounds(341, 10, 55, 20);
		frmMlsRemote.getContentPane().add(username);
		username.setColumns(10);
		
		environment = new JComboBox();
		environment.setModel(new DefaultComboBoxModel(new String[] {"R", "Python"}));
		environment.setBounds(564, 10, 62, 20);
		frmMlsRemote.getContentPane().add(environment);
		
		JButton loginBtn = new JButton("Submit");
		loginBtn.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				// Login to MLS Server
				if (login())
				{
					 code.setEditable(true);
					 code.setEnabled(true);
					 code.setText("library(RevoScaleR);\r\n" + 
					 		"rxLogitModel <- rxLogit(Kyphosis ~ Age + Number + Start, data=kyphosis);\r\n" + 
					 		"myData <- data.frame(Age=c(71), Number=c(3), Start=c(5));\r\n" + 
					 		"op1 <- rxPredict(rxLogitModel, myData)\r\n" + 
					 		"op1");
					 
					 consoleOp.setEnabled(true);
					 consoleOp.setText("");
					 
					 executeBtn.setEnabled(true);
					 
					 CreateSession();
				}
				
			}
		});
		loginBtn.setBounds(636, 9, 86, 23);
		frmMlsRemote.getContentPane().add(loginBtn);
		
		code = new JEditorPane();
		code.setBounds(10, 63, 628, 103);
		frmMlsRemote.getContentPane().add(code);
		
		executeBtn = new JButton("Run");
		executeBtn.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				String output = executeCode(code.getText());
				consoleOp.append("> " + code.getText().replaceAll("\n", "\n+ ") + "\n" + output);
				consoleOp.setCaretPosition(consoleOp.getText().length());
				code.setText("");
			}
		});
		executeBtn.setEnabled(false);
		executeBtn.setBounds(651, 143, 71, 23);
		frmMlsRemote.getContentPane().add(executeBtn);
		
		consoleOp = new JTextArea();
		consoleOp.setEditable(false);
		consoleOp.setLineWrap(true);
		consoleOp.setBounds(10, 202, 712, 183);
		frmMlsRemote.getContentPane().add(consoleOp);
		
		JLabel lblConsoleOutput = new JLabel("Console output:");
		lblConsoleOutput.setBounds(10, 177, 103, 14);
		frmMlsRemote.getContentPane().add(lblConsoleOutput);
		
		JLabel lblLoginToThe = new JLabel("LOGIN:");
		lblLoginToThe.setBounds(10, 13, 47, 14);
		frmMlsRemote.getContentPane().add(lblLoginToThe);
		
		JLabel lblNewLabel = new JLabel("Server:");
		lblNewLabel.setBounds(67, 13, 46, 14);
		frmMlsRemote.getContentPane().add(lblNewLabel);
		
		mlsServer = new JTextField();
		mlsServer.setText("http://127.0.0.1:12800");
		mlsServer.setBounds(123, 10, 129, 20);
		frmMlsRemote.getContentPane().add(mlsServer);
		mlsServer.setColumns(10);
		
		JLabel lblCode = new JLabel("Code:");
		lblCode.setBounds(10, 46, 46, 14);
		frmMlsRemote.getContentPane().add(lblCode);
		
		btnSessionSnapshot = new JButton("Get Snapshot Id");
		btnSessionSnapshot.setHorizontalAlignment(SwingConstants.LEFT);
		btnSessionSnapshot.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				DownloadSnapshot();
			}
		});
		btnSessionSnapshot.setBounds(10, 398, 159, 23);
		frmMlsRemote.getContentPane().add(btnSessionSnapshot);
		
		filePath = new JTextPane();
		filePath.setEditable(false);
		filePath.setBounds(179, 401, 462, 20);
		frmMlsRemote.getContentPane().add(filePath);
		
		btnCopy = new JButton("Copy");
		btnCopy.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				StringSelection stringSelection = new StringSelection(filePath.getText());
				Clipboard clpbrd = Toolkit.getDefaultToolkit().getSystemClipboard();
				clpbrd.setContents(stringSelection, null);
			}
		});
		btnCopy.setBounds(651, 398, 71, 23);
		frmMlsRemote.getContentPane().add(btnCopy);
		
		JScrollPane scrollPane = new JScrollPane(consoleOp);
		scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setBounds(10, 202, 712, 183);
		frmMlsRemote.getContentPane().add(scrollPane);
		
		JScrollPane scrollPane_1 = new JScrollPane(code);
		scrollPane_1.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane_1.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
		scrollPane_1.setBounds(10, 63, 628, 103);
		frmMlsRemote.getContentPane().add(scrollPane_1);
	}
	
	private void CloseSession()
	{
		if (sessionId != null)
		{
			SessionAPIsApi sessionApi = new SessionAPIsApi(getAuthenticatedClient());
			try {
				sessionApi.closeSession(sessionId);
			} catch (ApiException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	private void DownloadSnapshot()
	{
		if (sessionId != null)
		{
			SnapshotAPIsApi snapshotApi = new SnapshotAPIsApi(getAuthenticatedClient());
			CreateSnapshotRequest req = new CreateSnapshotRequest();
			req.setName(sessionId);
			try {
				CreateSnapshotResponse snapResponse = snapshotApi.createSnapshot(sessionId, req);
				filePath.setText(snapResponse.getSnapshotId());
			} catch (ApiException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	private Boolean login()
	{
		try {

			ApiClient apiClient = new ApiClient();
			apiClient.setBasePath(mlsServer.getText());
			AuthenticationAPIsApi authApi = new AuthenticationAPIsApi(apiClient);
			
			LoginRequest loginRequest = new LoginRequest();
			loginRequest.setUsername(username.getText());
			loginRequest.setPassword(password.getText());
		
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
			req.setRuntimeType(environment.getSelectedItem().toString().equals("R") ? RuntimeTypeEnum.R : RuntimeTypeEnum.PYTHON);
			CreateSessionResponse response = sessionApi.createSession(req);
			sessionId = response.getSessionId();
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private String executeCode(String code)
	{
		if (sessionId == null)
			CreateSession();
		
		ApiClient apiClient = getAuthenticatedClient();
		SessionAPIsApi sessionApi = new SessionAPIsApi(apiClient);
		
		ExecuteRequest executeRequest = new ExecuteRequest();
		executeRequest.setCode(code);
		
		try {
			ExecuteResponse response = sessionApi.executeCode(sessionId, executeRequest);
			if (!"".equals(response.getErrorMessage())) return response.getErrorMessage();
			return response.getConsoleOutput();
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.getMessage();
		}
	}
	
	private ApiClient getAuthenticatedClient()
	{
		if (bearerToken == null)
		{
			login();
		}
		ApiClient apiClient = new ApiClient();
		apiClient.setBasePath(mlsServer.getText());
		apiClient.addDefaultHeader("Authorization", "Bearer " + bearerToken);
		//apiClient.setApiKey();
		return apiClient;
	}
}
