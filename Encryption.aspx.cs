using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm23 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void encrypt_Click(object sender, EventArgs e)
        {
            string publicKey = "bcd";
            string publicKeyCondition = "WHERE publicKey = @publicKey";
            Dictionary<string, object> parameters = new Dictionary<string, object>
            {
                { "@publicKey", publicKey }
            };
            IntegrityCheck.EncryptColumn("Client", "icNo", publicKeyCondition, parameters);
        }

        public void decrypt_Click(object sender, EventArgs e)
        {
            string publicKey = "bcd";
            string publicKeyCondition = " publicKey = @publicKey";
            Dictionary<string, object> parameters = new Dictionary<string, object>
            {
                { "@publicKey", publicKey }
            };
            string ic = IntegrityCheck.DecryptColumn("Client", "icNo", publicKeyCondition, parameters);
            Debug.WriteLine("hi decrypted IC: " + ic);
        }
    }
}