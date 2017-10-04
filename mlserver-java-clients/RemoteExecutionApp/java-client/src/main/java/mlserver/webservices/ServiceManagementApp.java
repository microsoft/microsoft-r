package mlserver.webservices;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JTextArea;
import javax.swing.SwingConstants;

import io.swagger.annotations.ApiResponse;
import io.swagger.client.ApiClient;
import io.swagger.client.ApiException;
import io.swagger.client.api.AuthenticationAPIsApi;
import io.swagger.client.api.ServiceConsumptionAPIsApi;
import io.swagger.client.api.ServicesManagementAPIsApi;
import io.swagger.client.model.AccessTokenResponse;
import io.swagger.client.model.CreateSessionRequest.RuntimeTypeEnum;
import io.swagger.client.model.LoginRequest;
import io.swagger.client.model.ParameterDefinition;
import io.swagger.client.model.PublishWebServiceRequest;
import io.swagger.client.model.SwaggerJsonResponse;
import io.swagger.client.model.WebService;

import java.awt.Font;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.swing.JScrollPane;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class ServiceManagementApp {

	private JFrame frame;
	private JPasswordField password;
	private JTextField username;
	private JTextField mlsServer;
	private JTextField serviceName;
	private JTextField serviceVersion;
	private JTextField snapshotFile;
	private JTextField serviceAlias;
	private JTextField serviceDescription;
	private JButton btnPublishService;
	private JTextArea code;
	private JComboBox comboBox;
	private JTextArea serviceInputs, serviceOutputs;
	private JTextArea publishedServices;

	private String bearerToken;
	private JLabel publishStatus;
	private JButton btnDeleteAllServices;
	private JButton btnGetServiceSwagger;
	 
	
	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					ServiceManagementApp window = new ServiceManagementApp();
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
	public ServiceManagementApp() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosed(WindowEvent arg0) {
			}
		});
		frame.setBounds(100, 100, 790, 465);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		JButton button = new JButton("Submit");
		button.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				if (login())
				{
					btnPublishService.setEnabled(true);
					btnGetServiceSwagger.setEnabled(true);
					String allservices = GetAllServices();
					publishedServices.setText(allservices);
					btnDeleteAllServices.setEnabled(true);
					
					serviceAlias.setText("ScoreRxLogit");
					serviceDescription.setText("Test rxLogit web service");
					serviceInputs.setText("data=data.frame");
					serviceOutputs.setText("score=data.frame");
					serviceVersion.setText("1.0");
					serviceName.setText("rxLogitService");
					code.setText("score <- rxPredict(rxLogitModel, data)");
				}
			}
		});
		button.setBounds(650, 11, 86, 23);
		frame.getContentPane().add(button);
		
		comboBox = new JComboBox();
		comboBox.setModel(new DefaultComboBoxModel(new String[] {"R", "Python"}));
		comboBox.setBounds(578, 12, 62, 20);
		frame.getContentPane().add(comboBox);
		
		password = new JPasswordField();
		password.setBounds(494, 12, 74, 20);
		frame.getContentPane().add(password);
		
		JLabel label = new JLabel("PASSWORD");
		label.setBounds(420, 15, 73, 14);
		frame.getContentPane().add(label);
		
		username = new JTextField();
		username.setText("admin");
		username.setColumns(10);
		username.setBounds(355, 12, 55, 20);
		frame.getContentPane().add(username);
		
		JLabel label_1 = new JLabel("USER NAME");
		label_1.setBounds(276, 15, 69, 14);
		frame.getContentPane().add(label_1);
		
		JLabel lblLogin = new JLabel("LOGIN to MLS Server");
		lblLogin.setBounds(10, 15, 131, 14);
		frame.getContentPane().add(lblLogin);
		
		mlsServer = new JTextField();
		mlsServer.setText("http://127.0.0.1:12800");
		mlsServer.setBounds(128, 12, 138, 20);
		frame.getContentPane().add(mlsServer);
		mlsServer.setColumns(10);
		
		JLabel lblInitcode = new JLabel("Service Name:");
		lblInitcode.setBounds(21, 81, 89, 14);
		frame.getContentPane().add(lblInitcode);
		
		JLabel lblCode = new JLabel("Service Code:");
		lblCode.setVerticalAlignment(SwingConstants.TOP);
		lblCode.setBounds(21, 145, 97, 39);
		frame.getContentPane().add(lblCode);
		
		code = new JTextArea();
		code.setLineWrap(true);
		code.setBounds(131, 140, 239, 39);
		frame.getContentPane().add(code);
		
		serviceName = new JTextField();
		serviceName.setBounds(131, 78, 239, 20);
		frame.getContentPane().add(serviceName);
		serviceName.setColumns(10);
		
		JLabel lblServiceVersion = new JLabel("Service Version:");
		lblServiceVersion.setBounds(21, 113, 89, 14);
		frame.getContentPane().add(lblServiceVersion);
		
		serviceVersion = new JTextField();
		serviceVersion.setColumns(10);
		serviceVersion.setBounds(131, 109, 239, 20);
		frame.getContentPane().add(serviceVersion);
		
		JLabel lblSnapshotFile = new JLabel("Snapshot ID:");
		lblSnapshotFile.setBounds(21, 197, 89, 14);
		frame.getContentPane().add(lblSnapshotFile);
		
		snapshotFile = new JTextField();
		snapshotFile.setColumns(10);
		snapshotFile.setBounds(131, 193, 239, 20);
		frame.getContentPane().add(snapshotFile);
		
		JLabel lblServiceAlias = new JLabel("Service Alias:");
		lblServiceAlias.setBounds(21, 230, 107, 14);
		frame.getContentPane().add(lblServiceAlias);
		
		serviceAlias = new JTextField();
		serviceAlias.setColumns(10);
		serviceAlias.setBounds(131, 226, 239, 20);
		frame.getContentPane().add(serviceAlias);
		
		JLabel lblServiceDescription = new JLabel("Service Description:");
		lblServiceDescription.setBounds(21, 264, 107, 14);
		frame.getContentPane().add(lblServiceDescription);
		
		serviceDescription = new JTextField();
		serviceDescription.setColumns(10);
		serviceDescription.setBounds(131, 260, 239, 20);
		frame.getContentPane().add(serviceDescription);
		
		serviceInputs = new JTextArea();
		serviceInputs.setLineWrap(true);
		serviceInputs.setBounds(131, 292, 239, 39);
		frame.getContentPane().add(serviceInputs);
		
		JLabel lblServiceInputs = new JLabel("Service Inputs:");
		lblServiceInputs.setVerticalAlignment(SwingConstants.TOP);
		lblServiceInputs.setBounds(21, 295, 97, 23);
		frame.getContentPane().add(lblServiceInputs);
		
		JLabel lblServiceOutputs = new JLabel("Service Outputs:");
		lblServiceOutputs.setVerticalAlignment(SwingConstants.TOP);
		lblServiceOutputs.setBounds(21, 345, 97, 23);
		frame.getContentPane().add(lblServiceOutputs);
		
		serviceOutputs = new JTextArea();
		serviceOutputs.setLineWrap(true);
		serviceOutputs.setBounds(131, 342, 239, 39);
		frame.getContentPane().add(serviceOutputs);
		
		btnPublishService = new JButton("Publish Service");
		btnPublishService.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				PublishService();
			}
		});
		btnPublishService.setEnabled(false);
		btnPublishService.setBounds(21, 392, 160, 23);
		frame.getContentPane().add(btnPublishService);
		
		JLabel lblPublishService = new JLabel("PUBLISH SERVICE");
		lblPublishService.setFont(new Font("Tahoma", Font.BOLD | Font.ITALIC, 14));
		lblPublishService.setBounds(21, 56, 191, 14);
		frame.getContentPane().add(lblPublishService);
		
		JLabel lblExecuteService = new JLabel("PUBLISHED SERVICES");
		lblExecuteService.setFont(new Font("Tahoma", Font.BOLD | Font.ITALIC, 14));
		lblExecuteService.setBounds(403, 58, 191, 14);
		frame.getContentPane().add(lblExecuteService);
		
		publishStatus = new JLabel("");
		publishStatus.setBounds(406, 392, 330, 23);
		frame.getContentPane().add(publishStatus);
		
		publishedServices = new JTextArea();
		publishedServices.setLineWrap(true);
		publishedServices.setEditable(false);
		publishedServices.setBounds(406, 84, 330, 263);
		frame.getContentPane().add(publishedServices);
		
		btnDeleteAllServices = new JButton("Delete All Services");
		btnDeleteAllServices.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				DeleteAllServices();
			}
		});
		btnDeleteAllServices.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		btnDeleteAllServices.setEnabled(false);
		btnDeleteAllServices.setBounds(403, 358, 333, 23);
		frame.getContentPane().add(btnDeleteAllServices);
		
		btnGetServiceSwagger = new JButton("Get Service Swagger");
		btnGetServiceSwagger.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				CopySwaggerToClipboard();
			}
		});
		btnGetServiceSwagger.setEnabled(false);
		btnGetServiceSwagger.setBounds(210, 392, 160, 23);
		frame.getContentPane().add(btnGetServiceSwagger);
	}
	
	private void CopySwaggerToClipboard()
	{
		ServicesManagementAPIsApi servicesApi = new ServicesManagementAPIsApi(getAuthenticatedClient());
		try {
			List<WebService> webServices = servicesApi.getWebServiceVersion(serviceName.getText(), serviceVersion.getText());
			if (webServices.size() > 0)
			{
				ServiceConsumptionAPIsApi consumeApis = new ServiceConsumptionAPIsApi(getAuthenticatedClient());
				io.swagger.client.ApiResponse<String> response = consumeApis.getWebServiceSwaggerWithHttpInfo(webServices.get(0).getName(), webServices.get(0).getVersion());
								
				StringSelection stringSelection = new StringSelection(response.getData().toString());
				Clipboard clpbrd = Toolkit.getDefaultToolkit().getSystemClipboard();
				clpbrd.setContents(stringSelection, null);
				
				publishStatus.setText("Copied to clipboard");
			}
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void DeleteAllServices()
	{
		ServicesManagementAPIsApi servicesApi = new ServicesManagementAPIsApi(getAuthenticatedClient());
		List<WebService> services;
		try {
			services = servicesApi.getAllWebServices();
			for (WebService webService : services) {
				servicesApi.deleteWebServiceVersion(webService.getName(), webService.getVersion());
			}
			
			publishedServices.setText(GetAllServices());
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
	
	private void PublishService()
	{
		ServicesManagementAPIsApi svcApi = new ServicesManagementAPIsApi(getAuthenticatedClient());
		PublishWebServiceRequest req = new PublishWebServiceRequest();
		req.setCode(code.getText());
		req.setDescription(serviceDescription.getText());
		req.setOperationId(serviceAlias.getText());
		req.setRuntimeType((comboBox.getSelectedItem().toString().equals("R") ? PublishWebServiceRequest.RuntimeTypeEnum.R : PublishWebServiceRequest.RuntimeTypeEnum.PYTHON));
		req.setInputParameterDefinitions(GetParameterTypes(serviceInputs.getText()));
		req.setOutputParameterDefinitions(GetParameterTypes(serviceOutputs.getText()));
		if (snapshotFile.getText().length() > 0)
			req.setSnapshotId(snapshotFile.getText());
		try {
			svcApi.publishWebServiceVersion(serviceName.getText(), serviceVersion.getText(), req);
			publishStatus.setText("Publish " + serviceName.getText() + " successful!");
			publishedServices.setText(GetAllServices());
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			publishStatus.setText("Publish Failed! " + e.getMessage());
		}
	}
	
	private String GetAllServices()
	{
		String services = "";
		
		ServicesManagementAPIsApi svcApi = new ServicesManagementAPIsApi(getAuthenticatedClient());
		try {
			List<WebService> svcs = svcApi.getAllWebServices();
			for (WebService webService : svcs) {
				services += (webService.getName() + "," + webService.getVersion() + '\n');
			}
		} catch (ApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return services;
	}
	
	private String ExecuteService()
	{
		
		return "";
	}
	
	private ApiClient getAuthenticatedClient()
	{
		ApiClient apiClient = new ApiClient();
		apiClient.setBasePath(mlsServer.getText());
		apiClient.addDefaultHeader("Authorization", "Bearer " + bearerToken);
		return apiClient;
	}
	
	private List<ParameterDefinition> GetParameterTypes(String parameterInfo)
	{
		List<ParameterDefinition> params = new ArrayList<ParameterDefinition>();
		
		String[] parameters = parameterInfo.split(", ");
		for (String param : parameters) {
			String[] info = param.split("=");
			ParameterDefinition paramDef = new ParameterDefinition();
			paramDef.setName(info[0]);
			paramDef.setType(ParameterDefinition.TypeEnum.fromValue(info[1]));
			
			params.add(paramDef);
		}
		
		return params;
	}
}
