using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm8 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["publicKey"] != null)
            {
                string publicKey = Session["publicKey"].ToString();
            }

            bankStmtApp.Attributes["accept"] = ".pdf";
            liability.Attributes["accept"] = ".pdf";
            mgtAcc.Attributes["accept"] = ".pdf";
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                // 1-Application Info
                // Application ID
                string query = "select count(*) from financingApplication";
                SqlCommand cmd = new SqlCommand(query, con);
                int totalApp = Convert.ToInt32(cmd.ExecuteScalar().ToString());
                int appNo = totalApp + 1;
                string num = appNo.ToString();
                string AID;

                if (num.Length == 1)
                {
                    AID = "00" + num;
                }
                else if (num.Length == 2)
                {
                    AID = "0" + num;
                }
                else
                {
                    AID = num;
                }
                
                // Application Datetime
                DateTime appDT = DateTime.Now;
                
                // Other Info
                string financingAmt = Session["financingAmt"].ToString();
                string noteDuration = Session["noteDuration"].ToString();
                string financingPurpose = Session["financingPurpose"].ToString();
                string status = "pending";
                string clientID = Session["clientID"].ToString();

                // Retrieve borrowerID
                string getBID = "SELECT borrowerID FROM Borrower WHERE clientID = @clientID";
                SqlCommand cmdID = new SqlCommand(getBID, con);
                cmdID.Parameters.AddWithValue("@clientID", clientID);
                string borrowerID = (string)cmdID.ExecuteScalar();

                // 2-Application Doc
                // Bank Statement
                string stmt_folderpath = Server.MapPath("~/Client/Borrower/Application/");
                //Check whether directory exists
                if (!Directory.Exists(stmt_folderpath))
                {
                    //create the directory
                    Directory.CreateDirectory(stmt_folderpath);
                }
                //save file into the folderpath
                bankStmtApp.SaveAs(stmt_folderpath + Path.GetFileName(bankStmtApp.FileName));
                //save filepath into db
                string bankStmtPath = Path.GetFileName(bankStmtApp.PostedFile.FileName);

                // Liability
                string liability_folderpath = Server.MapPath("~/Client/Borrower/Application/");
                //Check whether directory exists
                if (!Directory.Exists(liability_folderpath))
                {
                    //create the directory
                    Directory.CreateDirectory(liability_folderpath);
                }
                //save file into the folderpath
                liability.SaveAs(liability_folderpath + Path.GetFileName(liability.FileName));
                //save filepath into db
                string liabilityPath = Path.GetFileName(liability.PostedFile.FileName);

                // Management Accouont
                string mgtAcc_folderpath = Server.MapPath("~/Client/Borrower/Application/");
                //Check whether directory exists
                if (!Directory.Exists(mgtAcc_folderpath))
                {
                    //create the directory
                    Directory.CreateDirectory(mgtAcc_folderpath);
                }
                //save file into the folderpath
                mgtAcc.SaveAs(mgtAcc_folderpath + Path.GetFileName(mgtAcc.FileName));
                //save filepath into db
                string mgtAccPath = Path.GetFileName(mgtAcc.PostedFile.FileName);

                Debug.WriteLine("==============Print Application Info==================");
                Debug.WriteLine("A" + AID);
                Debug.WriteLine(appDT);
                Debug.WriteLine(financingAmt);
                Debug.WriteLine(noteDuration);
                Debug.WriteLine(financingPurpose);
                Debug.WriteLine(borrowerID);
                Debug.WriteLine(bankStmtPath);
                Debug.WriteLine(liabilityPath);
                Debug.WriteLine(mgtAccPath);

                Debug.WriteLine("==============Save Application Info==================");

                string query1 = "insert into financingApplication (appID, appDateTime, financingAmt, Duration, financingPurpose, borrowerID, bankStmt, Liability, mgtAcc, status)" +
                    "values (@AID, @appDT, @financingAmt, @noteDuration, @financingPurpose, @borrowerID, @bankStmt, @Liability, @mgtAcc, @status)";
                SqlCommand cmd1 = new SqlCommand(query1, con);
                cmd1.Parameters.AddWithValue("@AID", "A" + AID);
                cmd1.Parameters.AddWithValue("@appDT", appDT);
                cmd1.Parameters.AddWithValue("@financingAmt", financingAmt);
                cmd1.Parameters.AddWithValue("@noteDuration", noteDuration);
                cmd1.Parameters.AddWithValue("@financingPurpose", financingPurpose);
                cmd1.Parameters.AddWithValue("@borrowerID", borrowerID);
                cmd1.Parameters.AddWithValue("@bankStmt", bankStmtPath);
                cmd1.Parameters.AddWithValue("@liability", liabilityPath);
                cmd1.Parameters.AddWithValue("@mgtAcc", mgtAccPath);
                cmd1.Parameters.AddWithValue("@status", status);
                cmd1.ExecuteNonQuery();

                // Create hash
                IntegrityCheck checkApp = new IntegrityCheck();
                string app = checkApp.GetAppDetails("A" + AID);
                string hashApp = IntegrityCheck.ComputeSha256Hash(app);
                Debug.WriteLine("The hash for " + app + " is " + hashApp);
                TableName1.Value = "App";
                hash1.Value = hashApp;
                pkey1.Value = "A" + AID;

                // Encryption
                string appCondition = "WHERE appID = @appID";
                Dictionary<string, object> parameters = new Dictionary<string, object>
                {
                    { "@appID", "A" + AID }
                };
                IntegrityCheck.EncryptColumn("financingApplication", "bankStmt", appCondition, parameters);
                IntegrityCheck.EncryptColumn("financingApplication", "Liability", appCondition, parameters);
                IntegrityCheck.EncryptColumn("financingApplication", "mgtAcc", appCondition, parameters);

                Debug.WriteLine("==============Done Application Info==================");

                con.Close();
                callScript.Value = "reviewed";
            }
            catch
            {
                Debug.WriteLine("Unknown Error.");
            }
        }

        protected void backBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("4-Borrower Apply for Financing.aspx");
        }
    }
}