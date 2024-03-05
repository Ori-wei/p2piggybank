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

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm5 : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["publicKey"] != null)
            {
                string publicKey = Session["publicKey"].ToString();
            }

            if (!IsPostBack)
            {
                bizCert.Attributes["accept"] = ".pdf";
                utilityBill.Attributes["accept"] = ".pdf";
                form9.Attributes["accept"] = ".pdf";
                bankStmt.Attributes["accept"] = ".pdf";
                icDoc.Attributes["accept"] = ".pdf";
            }
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Save Button pressed");
            

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = "";

            // check if is new user
            if (Session["clientID"] == null){
                // Insert into 3-Client DB
                // 3-Client Info

                // Create clientID
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
                
                string icNo = Session["icNo"].ToString();
                string fullName = Session["fullName"].ToString();
                string dob = Session["dob"].ToString();
                string gender = Session["gender"].ToString();
                string contactNo = Session["contactNo"].ToString();
                string publicKey = Session["publicKey"].ToString();

                // IC Doc
                string folderpath = Server.MapPath("~/Client/ICDocument/");
                //Check whether directory exists
                if (!Directory.Exists(folderpath))
                {
                    //create the directory
                    Directory.CreateDirectory(folderpath);
                }
                //save file into the folderpath
                icDoc.SaveAs(folderpath + Path.GetFileName(icDoc.FileName));
                //save filepath into db
                string icDocPath = Path.GetFileName(icDoc.PostedFile.FileName);

                Debug.WriteLine("=================Page 32, Print Client Data====================");
                Debug.WriteLine("clientID:" + "C" + clientID);
                Debug.WriteLine("icNo:" + icNo);
                Debug.WriteLine("fullName:" + fullName);
                Debug.WriteLine("dob:" + dob);
                Debug.WriteLine("gender:" + gender);
                Debug.WriteLine("contactNo:" + contactNo);
                Debug.WriteLine("icDocPath:" + icDocPath);
                Debug.WriteLine("publicKey:" + publicKey);
                Debug.WriteLine("=================Page 32, Done Print Client Data====================");
                Debug.WriteLine("=================Page 32, Save Client Data====================");

                string query1 = "insert into Client (clientID, icNo, fullName, dob, gender, contactNo, icDoc, publicKey, status) " +
            "values (@clientID, @icNo, @fullName, @dob, @gender, @contactNo, @icDocPath, @publicKey, @status)";
                SqlCommand cmd1 = new SqlCommand(query1, con);
                cmd1.Parameters.AddWithValue("@clientID", "C" + clientID);
                cmd1.Parameters.AddWithValue("@icNo", icNo);
                cmd1.Parameters.AddWithValue("@fullName", fullName);
                cmd1.Parameters.AddWithValue("@dob", dob);
                cmd1.Parameters.AddWithValue("@gender", gender);
                cmd1.Parameters.AddWithValue("@contactNo", contactNo);
                cmd1.Parameters.AddWithValue("@icDocPath", icDocPath);
                cmd1.Parameters.AddWithValue("@publicKey", publicKey);
                cmd1.Parameters.AddWithValue("@status", "pending");
                cmd1.ExecuteNonQuery();
                Debug.WriteLine("=================Page 32, Done Save Client Data====================");

                // Encryption
                string Condition1 = "WHERE clientID = @clientID";
                Dictionary<string, object> parameters1 = new Dictionary<string, object>
                {
                    { "@clientID", "C" + clientID }
                };

                IntegrityCheck.EncryptColumn("Client", "icNo", Condition1, parameters1);
                IntegrityCheck.EncryptColumn("Client", "icDoc", Condition1, parameters1);

                // Create hash
                IntegrityCheck checkClient = new IntegrityCheck();
                string client = checkClient.GetClientDetails("C" + clientID);
                string hashClient = IntegrityCheck.ComputeSha256Hash(client);
                Debug.WriteLine("The hash for " + client + " is " + hashClient);
                TableName1.Value = "Client";
                hash1.Value = hashClient;
                pkey1.Value = "C" + clientID;

                Session["clientID"] = "C" + clientID;
            }

            Debug.WriteLine("=================Page 5, Save Borrower Data====================");

            // Insert into 4-Borrower Info
            // 4-Borrower Info
            string borrowerID = Session["borrowerID"].ToString();
            string bizName = Session["bizName"].ToString();
            string bizRegNo = Session["bizRegNo"].ToString();
            string bizAdd = Session["bizAdd"].ToString();
            string bizContact = Session["bizContact"].ToString();
            string bizIndustry = Session["bizIndustry"].ToString();
            string entityType = Session["entityType"].ToString();

            // Insert into 5-Borrower Docs
            // bizCert
            string bizCert_folderpath = Server.MapPath("~/Client/Borrower/Business Cert/");
            //Check whether directory exists
            if (!Directory.Exists(bizCert_folderpath))
            {
                //create the directory
                Directory.CreateDirectory(bizCert_folderpath);
            }
            //save file into the folderpath
            bizCert.SaveAs(bizCert_folderpath + Path.GetFileName(bizCert.FileName));
            //save filepath into db
            string bizCertPath = Path.GetFileName(bizCert.PostedFile.FileName);

            // Utility Bill
            string bill_folderpath = Server.MapPath("~/Client/Borrower/Utility Bill/");
            //Check whether directory exists
            if (!Directory.Exists(bill_folderpath))
            {
                //create the directory
                Directory.CreateDirectory(bill_folderpath);
            }
            //save file into the folderpath
            utilityBill.SaveAs(bill_folderpath + Path.GetFileName(utilityBill.FileName));
            //save filepath into db
            string billPath = Path.GetFileName(utilityBill.PostedFile.FileName);

            // Form 9
            string form9_folderpath = Server.MapPath("~/Client/Borrower/Form 9/");
            //Check whether directory exists
            if (!Directory.Exists(form9_folderpath))
            {
                //create the directory
                Directory.CreateDirectory(form9_folderpath);
            }
            //save file into the folderpath
            form9.SaveAs(form9_folderpath + Path.GetFileName(form9.FileName));
            //save filepath into db
            string form9Path = Path.GetFileName(form9.PostedFile.FileName);

            // Bank Statement
            string bs_folderpath = Server.MapPath("~/Client/Borrower/Bank Statement/");
            //Check whether directory exists
            if (!Directory.Exists(bs_folderpath))
            {
                //create the directory
                Directory.CreateDirectory(bs_folderpath);
            }
            //save file into the folderpath
            bankStmt.SaveAs(bs_folderpath + Path.GetFileName(bankStmt.FileName));
            //save filepath into db
            string bsPath =  Path.GetFileName(bankStmt.PostedFile.FileName);


            string query2 = "insert into Borrower (borrowerID, bizName, bizRegNo, bizAdd, bizContact, bizIndustry, entityType, bizCert, utilityBill, form9, bankStmt, clientID) " +
                "values (@bid, @bizName, @bizRegNo, @bizAdd, @bizContact, @bizIndustry, @entityType, @bizCert, @utilityBill, @form9, @bankStmt, @clientID)";
            SqlCommand cmd2 = new SqlCommand(query2, con);
            cmd2.Parameters.AddWithValue("@bid", borrowerID);
            cmd2.Parameters.AddWithValue("@bizName", bizName);
            cmd2.Parameters.AddWithValue("@bizRegNo", bizRegNo);
            cmd2.Parameters.AddWithValue("@bizAdd", bizAdd);
            cmd2.Parameters.AddWithValue("@bizContact", bizContact);
            cmd2.Parameters.AddWithValue("@bizIndustry", bizIndustry);
            cmd2.Parameters.AddWithValue("@entityType", entityType);
            cmd2.Parameters.AddWithValue("@bizCert", bizCertPath);
            cmd2.Parameters.AddWithValue("@utilityBill", billPath);
            cmd2.Parameters.AddWithValue("@form9", form9Path);
            cmd2.Parameters.AddWithValue("@bankStmt", bsPath);
            cmd2.Parameters.AddWithValue("@clientID", "C" + clientID);
            cmd2.ExecuteNonQuery();

            Debug.WriteLine("bizCertPath:" + bizCertPath);
            Debug.WriteLine("billPath:" + billPath);
            Debug.WriteLine("form9Path:" + form9Path);
            Debug.WriteLine("bsPath:" + bsPath);

            // Encryption
            string borrowerCondition = "WHERE borrowerID = @borrowerID";
            Dictionary<string, object> parameters2 = new Dictionary<string, object>
                {
                    { "@borrowerID", borrowerID }
                };

            IntegrityCheck.EncryptColumn("Borrower", "bizCert", borrowerCondition, parameters2);
            IntegrityCheck.EncryptColumn("Borrower", "utilityBill", borrowerCondition, parameters2);
            IntegrityCheck.EncryptColumn("Borrower", "form9", borrowerCondition, parameters2);
            IntegrityCheck.EncryptColumn("Borrower", "bankStmt", borrowerCondition, parameters2);

            IntegrityCheck checkBorrower = new IntegrityCheck();
            string borrower = checkBorrower.GetBorrowerDetails(borrowerID);
            string hashBorrower = IntegrityCheck.ComputeSha256Hash(borrower);
            Debug.WriteLine("The hash for " + borrower + " is " + hashBorrower);
            TableName2.Value = "Borrower";
            hash2.Value = hashBorrower;
            pkey2.Value = borrowerID;

            string checkClientQuery = "SELECT status FROM Client WHERE clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(checkClientQuery, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string status1 = (string)cmdCheck.ExecuteScalar();

            if (status1 != "pending")
            {
                string query4 = "update Client set status = 'pending' where clientID = @clientID";
                SqlCommand cmd4 = new SqlCommand(query4, con);
                cmd4.Parameters.AddWithValue("@clientID", "C" + clientID);
                cmd4.ExecuteNonQuery();

                // Create hash
                IntegrityCheck checkClient = new IntegrityCheck();
                string client = checkClient.GetClientDetails("C" + clientID);
                string hashClient = IntegrityCheck.ComputeSha256Hash(client);
                Debug.WriteLine("The hash for " + client + " is " + hashClient);
                TableName1.Value = "Client";
                hash1.Value = hashClient;
                pkey1.Value = "C" + clientID;
            }

            con.Close();
            callScript.Value = "reviewed";
        }

        protected void backBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("31-Borrower_Lender My Profile 2.aspx");
        }
    }
}