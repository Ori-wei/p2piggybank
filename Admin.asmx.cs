using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    /// <summary>
    /// Summary description for Admin1
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Admin1 : System.Web.Services.WebService
    {
        [WebMethod(EnableSession = true)]
        public void SetSessionPublicKey(string publicKey)
        {
            // Here, you should be able to set the session variable
            Session["publicKey"] = publicKey;
            Debug.WriteLine("Set session pk on Test.asmx: " + Session["publicKey"]);

            InsertPublicKeyIfNew(publicKey);
            checkAdmin(publicKey);
        }

        private void InsertPublicKeyIfNew(string publicKey)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if the public key already exists
            string checkKeyQuery = "SELECT COUNT(*) FROM Person WHERE publicKey = @PublicKey";
            SqlCommand cmdCheck = new SqlCommand(checkKeyQuery, con);
            cmdCheck.Parameters.AddWithValue("@PublicKey", publicKey);
            int exists = (int)cmdCheck.ExecuteScalar();

            // If it does not exist, insert it
            if (exists == 0)
            {
                string insertKeyQuery = "INSERT INTO Person (publicKey) VALUES (@PublicKey)";
                SqlCommand cmd2 = new SqlCommand(insertKeyQuery, con);
                cmd2.Parameters.AddWithValue("@PublicKey", publicKey);
                cmd2.ExecuteNonQuery();
            }

            con.Close();
        }

        private void checkAdmin(string publicKey)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if the public key already exists
            string checkadmin = "SELECT adminID FROM Admin WHERE publicKey = @PublicKey";
            SqlCommand cmdCheck = new SqlCommand(checkadmin, con);
            cmdCheck.Parameters.AddWithValue("@PublicKey", publicKey);
            string adminID = (string)cmdCheck.ExecuteScalar();

            // If it exists, set session
            if (adminID != null)
            {
                Session["adminID"] = adminID;
            }

            Debug.WriteLine(Session["adminID"]);
        }
    }
}
