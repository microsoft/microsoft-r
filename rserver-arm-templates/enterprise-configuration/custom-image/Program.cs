using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;

namespace ConsoleApplication
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
            var cert = new X509Certificate2("merged.pfx");
            store.Open(OpenFlags.ReadWrite);
            store.Add(cert);
        }
    }
}
