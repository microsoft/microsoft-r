namespace ValidateSetup
{
    using Models;
    using System.Collections;
    using System.Collections.Generic;
    using System.IO;
    using System.Threading;
    using System.Threading.Tasks;

    public static partial class ConsumeServiceExtension
    {
        
        public static WebServiceResult ManualTransmission(this ConsumeService operations, string name, string version, InputParameters webServiceParameters)
        {
            return operations.ManualTransmissionAsync(name, version, webServiceParameters).GetAwaiter().GetResult();
        }

        public static async Task<WebServiceResult> ManualTransmissionAsync(this ConsumeService operations, string name, string version, InputParameters webServiceParameters, CancellationToken cancellationToken = default(CancellationToken))
        {
            using (var _result = await operations.ManualTransmissionWithHttpMessagesAsync(name, version, webServiceParameters, null, cancellationToken).ConfigureAwait(false))
            {
                return _result.Body;
            }
        }

        public static ValidateRealTimeService.Models.WebServiceResult KyphosisService(this ConsumeService operations, string name, string version, ValidateRealTimeService.Models.InputParameters webServiceParameters)
        {
            return operations.KyphosisServiceAsync(name, version, webServiceParameters).GetAwaiter().GetResult();
        }

        public static async Task<ValidateRealTimeService.Models.WebServiceResult> KyphosisServiceAsync(this ConsumeService operations, string name, string version, ValidateRealTimeService.Models.InputParameters webServiceParameters, CancellationToken cancellationToken = default(CancellationToken))
        {
            using (var _result = await operations.KyphosisServiceWithHttpMessagesAsync(name, version, webServiceParameters, null, cancellationToken).ConfigureAwait(false))
            {
                return _result.Body;
            }
        }
    }
}
