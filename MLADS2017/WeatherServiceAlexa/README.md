This is the source ecode for aws lambda function with Java 8 client to access weather service, which is used by Alexa skill that was demoed during MLADS 2017 on Dec 7th.

Follow below steps to get started with the project:

1. Open eclipse and import a 'maven' project
2. Select ".\alexaDemo\WeatherServiceAwsLambda" as project root location
3. Once imported, change the server-ip, server-port, username and password in LambdaFunctionHandler.java class to match your server details
4. Save changes, right lcick on project and select 'Run as Maven Install'
5. Maven install command will generate the complete JAR for you under 'target' folder, that you can use with your AWS Lambda and Alexa skills.

For more details, refer to the blog:
https://blogs.msdn.microsoft.com/mlserver/2017/10/09/amazons-aws-lamba-and-alexa-skill-with-microsoft-machine-learning-server-operationalization/
