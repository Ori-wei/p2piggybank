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
    /// Summary description for Test
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]

    public class Test : System.Web.Services.WebService
    {
        [WebMethod(EnableSession = true)]
        public void SetSessionPublicKey(string publicKey)
        {
            // Here, you should be able to set the session variable
            Session["publicKey"] = publicKey;
            Debug.WriteLine("Set session pk on Test.asmx: " + Session["publicKey"]);

            InsertPublicKeyIfNew(publicKey);
            checkClientIC(publicKey);
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

        private void checkClientIC(string publicKey)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if the client already exists
            string checkClientQuery = "SELECT clientID FROM Client WHERE publicKey = @publicKey";
            SqlCommand cmdCheck = new SqlCommand(checkClientQuery, con);
            cmdCheck.Parameters.AddWithValue("@publicKey", publicKey);
            string clientID = (string)cmdCheck.ExecuteScalar();

            // If it exists, set session
            if (clientID != null)
            {
                Session["clientID"] = clientID;

                //Retrieve lenderid
                string query2 = "SELECT lenderID FROM Lender WHERE clientID = @clientID";
                SqlCommand cmd2 = new SqlCommand(query2, con);
                cmd2.Parameters.AddWithValue("@clientID", clientID);
                string lenderID = (string)cmd2.ExecuteScalar();

                if (lenderID != null)
                {
                    Session["lenderID"] = lenderID;
                }
                else
                {
                    Session["lenderID"] = null;
                }

                //Retrieve borrowerid
                string query3 = "SELECT borrowerID FROM Borrower WHERE clientID = @clientID";
                SqlCommand cmd3 = new SqlCommand(query3, con);
                cmd3.Parameters.AddWithValue("@clientID", clientID);
                string borrowerID = (string)cmd3.ExecuteScalar();

                if (borrowerID != null)
                {
                    Session["borrowerID"] = borrowerID;
                }
                else
                {
                    Session["borrowerID"] = null;
                }
            }
            else
            {
                Session["clientID"] = null;
            }

            Debug.WriteLine("Set borrower id session on Test: " + Session["borrowerID"]);
            Debug.WriteLine("Set lender id session on Test: " + Session["lenderID"]);

            con.Close();
            Debug.WriteLine(Session["clientID"]);
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
