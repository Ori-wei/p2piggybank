using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.Diagnostics;
using System.IO;
using System.Web.Services;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm10 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string publicKey = Session["publicKey"].ToString();
            
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            if (Session["clientID"] == null)
            {
                // new user
                CreateProfileForm.Visible = true;
            }
            else
            {
                // existing user
                if (Session["lenderID"] == null)
                {
                    // existing user but new lender
                    CreateProfileForm.Visible = true;
                    fullName.Enabled = false;
                    ic.Enabled = false;
                    dob.Enabled = false;
                    gender.Enabled = false;
                    contactNo.Enabled = false;
                    icDocUpload.Enabled = false;

                    RequiredFieldValidator1.Enabled = false;
                    RequiredFieldValidator2.Enabled = false;
                    RequiredFieldValidator3.Enabled = false;
                    RequiredFieldValidator4.Enabled = false;
                    RequiredFieldValidator5.Enabled = false;
                }
                else
                {
                    Response.Redirect("35-Show User Profile.aspx");
                }
            }

            con.Close();

            if (!IsPostBack)
            {
                icDocUpload.Attributes["accept"] = ".pdf";
            }
        }

        protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string CheckICExists(string ic)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if the public key already exists
            string checkKeyQuery = "SELECT COUNT(*) FROM Client WHERE icNo = @ic";
            SqlCommand cmdCheck = new SqlCommand(checkKeyQuery, con);
            cmdCheck.Parameters.AddWithValue("@ic", ic);
            int exists = (int)cmdCheck.ExecuteScalar();

            if (exists != 0)
            {
                return "exists";
            }
            else
            {
                string yearPrefix = ic.Substring(0, 2);
                int year = int.Parse(yearPrefix);
                string century;

                // set century
                if (year >= 10 && year <= 99)
                {
                    century = "19";
                }
                else if (year >= 0 && year <= 6)
                {  // Assuming year prefix ranges from 00 to 06 for 2000 to 2006
                    century = "20";
                }
                else
                {
                    century = "invalid"; // Handle invalid year prefix
                }

                if (century != "invalid")
                {
                    string dob = ic.Substring(2, 2) + "-" + ic.Substring(4, 2) + "-" + century + yearPrefix;
                    return dob;
                }
            }

            return null;
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //public key
            string publicKey = Session["publicKey"].ToString();
            string clientID = "";

            Debug.WriteLine("============= check if ic exists ===================");
            // If ic does not exist, insert it
            if (Session["clientID"] == null)
            {
                Debug.WriteLine("============= client id ===================");
                // Create client id
                string query0 = "select count(*) from Client";
                SqlCommand cmd0 = new SqlCommand(query0, con);
                int totalClient = Convert.ToInt32(cmd0.ExecuteScalar().ToString());
                int clientNo = totalClient + 1;
                string num0 = clientNo.ToString();

                if (num0.Length == 1)
                {
                    clientID = "00" + num0;
                }
                else if (num0.Length == 2)
                {
                    clientID = "0" + num0;
                }
                else
                {
                    clientID = num0;
                }
                Debug.WriteLine("============= ic doc ===================");
                // IC Doc
                string folderpath = Server.MapPath("~/Client/ICDocument/");
                //Check whether directory exists
                if (!Directory.Exists(folderpath))
                {
                    //create the directory
                    Directory.CreateDirectory(folderpath);
                }
                //save file into the folderpath
                icDocUpload.SaveAs(folderpath + Path.GetFileName(icDocUpload.FileName));
                //save filepath into db
                string icDocPath = Path.GetFileName(icDocUpload.PostedFile.FileName);
                Debug.WriteLine("============= ic doc done ===================");

                Debug.WriteLine("============= save db ===================");
                // Insert into Client DB
                string query1 = "insert into Client (clientID, icNo, fullName, dob, gender, contactNo, icDoc, publicKey, status) " +
                "values (@clientID, @icNo, @fullName, @dob, @gender, @contactNo, @icDocPath, @publicKey, @status)";
                SqlCommand cmd1 = new SqlCommand(query1, con);
                cmd1.Parameters.AddWithValue("@clientID", "C" + clientID);
                cmd1.Parameters.AddWithValue("@icNo", ic.Text);
                cmd1.Parameters.AddWithValue("@fullName", fullName.Text);
                cmd1.Parameters.AddWithValue("@dob", dob.Text);
                cmd1.Parameters.AddWithValue("@gender", gender.SelectedItem.Text);
                cmd1.Parameters.AddWithValue("@contactNo", contactNo.Text);
                cmd1.Parameters.AddWithValue("@icDocPath", icDocPath);
                cmd1.Parameters.AddWithValue("@publicKey", publicKey);
                cmd1.Parameters.AddWithValue("@status", "pending");
                cmd1.ExecuteNonQuery();
                Debug.WriteLine("============= save db done ===================");

                // Create hash
                Debug.WriteLine("============= 34 - send client hash ===================");
                IntegrityCheck checkClient = new IntegrityCheck();
                string client = checkClient.GetClientDetails("C" + clientID);
                string hashClient = IntegrityCheck.ComputeSha256Hash(client);
                Debug.WriteLine("The hash for " + client + " is " + hashClient);
                TableName1.Value = "Client";
                hash1.Value = hashClient;
                pkey1.Value = "C" + clientID;

                // Encryption
                string Condition1 = "WHERE clientID = @clientID";
                Dictionary<string, object> parameters1 = new Dictionary<string, object>
                {
                    { "@clientID", "C" + clientID }
                };

                IntegrityCheck.EncryptColumn("Client", "icNo", Condition1, parameters1);
                IntegrityCheck.EncryptColumn("Client", "icDoc", Condition1, parameters1);

                Session["clientID"] = "C" + clientID;
            }

            Debug.WriteLine("============= create lender ===================");
            // Insert into Lender DB
            //create lender id
            string query2 = "select count(*) from Lender";
            SqlCommand cmd2 = new SqlCommand(query2, con);
            int totalLender = Convert.ToInt32(cmd2.ExecuteScalar().ToString());
            int lenderNo = totalLender + 1;
            string num = lenderNo.ToString();
            string lenderID;

            if (num.Length == 1)
            {
                lenderID = "00" + num;
            }
            else if (num.Length == 2)
            {
                lenderID = "0" + num;
            }
            else
            {
                lenderID = num;
            }

            // risk acknowledgement
            int acknowledgment = riskAck.Checked ? 1 : 0;

            Debug.WriteLine("============= define lender done ===================");

            // Only save to database if acknowledgment is 1
            if (acknowledgment == 1)
            {
                Debug.WriteLine("============= save lender ===================");
                string query3 = "insert into Lender (lenderID, annualIncome, riskTolerance, riskAck, clientID) " +
                    "values (@lid, @annualIncome, @riskTolerance, @riskAck, @clientID)";
                SqlCommand cmd3 = new SqlCommand(query3, con);
                cmd3.Parameters.AddWithValue("@lid", "L" + lenderID);
                cmd3.Parameters.AddWithValue("@annualIncome", annualIncome.SelectedItem.Text);
                cmd3.Parameters.AddWithValue("@riskTolerance", riskTolerance.SelectedItem.Text);
                cmd3.Parameters.AddWithValue("@riskAck", acknowledgment);
                cmd3.Parameters.AddWithValue("@clientID", "C" + clientID);
                cmd3.ExecuteNonQuery();

                // Create hash
                Debug.WriteLine("============= 34, send Lender hash ===================");
                IntegrityCheck checkLender = new IntegrityCheck();
                string lender = checkLender.GetLenderDetails("L" + lenderID);
                string hashLender = IntegrityCheck.ComputeSha256Hash(lender);
                Debug.WriteLine("The hash for " + lender + " is " + hashLender);
                TableName2.Value = "Lender";
                hash2.Value = hashLender;
                pkey2.Value = "L" + lenderID;

                string checkClientQuery = "SELECT status FROM Client WHERE clientID = @clientID";
                SqlCommand cmdCheck = new SqlCommand(checkClientQuery, con);
                cmdCheck.Parameters.AddWithValue("@clientID", clientID);
                string status1 = (string)cmdCheck.ExecuteScalar();

                if(status1 != "pending")
                {
                    string query4 = "update Client set status = 'pending' where clientID = @clientID";
                    SqlCommand cmd4 = new SqlCommand(query4, con);
                    cmd4.Parameters.AddWithValue("@clientID", "C" + clientID);
                    cmd4.ExecuteNonQuery();

                    Debug.WriteLine("============= 34 - send client hash 2===================");
                    IntegrityCheck checkClient = new IntegrityCheck();
                    string client = checkClient.GetClientDetails(ic.Text);
                    string hashClient = IntegrityCheck.ComputeSha256Hash(client);
                    Debug.WriteLine("The hash for " + client + " is " + hashClient);
                    TableName1.Value = "Client";
                    hash1.Value = hashClient;
                    pkey1.Value = "C" + clientID;
                }

                Debug.WriteLine("============= save lender done ===================");
            }

            con.Close();
            callScript.Value = "reviewed";
        }

        protected void backBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("1-Client Homepage.aspx");
        }
    }
}