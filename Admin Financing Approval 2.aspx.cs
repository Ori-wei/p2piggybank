using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm15 : System.Web.UI.Page
    {
        string[] args;
        string documentType;
        string fileName;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if(Session["appID"] != null)
                {
                    string appID = Session["appID"].ToString();
                    Debug.WriteLine(appID);
                    BindAppDetail1(appID);
                    BindAppDetail2(appID);
                }
                
            }
        }

        protected void BindAppDetail1(string appID)
        {
            //Retrieve Details
            AppSource1.SelectCommand = "SELECT appID, appDateTime, financingAmt, Duration FROM financingApplication WHERE appID = @AppID";
            AppSource1.SelectParameters.Clear();
            AppSource1.SelectParameters.Add("AppID", appID);

            //Set Client data as gridview data
            AppDetail1.DataBind();
        }

        protected void BindAppDetail2(string appID)
        {
            // Create a table to hold the decrypted data
            DataTable dt = new DataTable();
            dt.Columns.Add("financingPurpose");
            dt.Columns.Add("bankStmtApp");
            dt.Columns.Add("Liability");
            dt.Columns.Add("mgtAcc");

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT financingPurpose, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, bankStmt)) AS DecryptedbankStmt, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, Liability)) AS DecryptedLiability, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, mgtAcc)) AS DecryptedmgtAcc " +
                "FROM financingApplication WHERE appID = @appID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Passphrase", "FYPp2plendingsystem23!");
            cmd.Parameters.AddWithValue("@appID", appID);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    string financingPurpose = reader["financingPurpose"].ToString();
                    string DecryptedbankStmt = reader["DecryptedbankStmt"] != DBNull.Value ? reader["DecryptedbankStmt"].ToString() : null;
                    string DecryptedLiability = reader["DecryptedLiability"] != DBNull.Value ? reader["DecryptedLiability"].ToString() : null;
                    string DecryptedmgtAcc = reader["DecryptedmgtAcc"] != DBNull.Value ? reader["DecryptedmgtAcc"].ToString() : null;

                    DataRow dr = dt.NewRow();
                    dr["financingPurpose"] = financingPurpose;
                    dr["bankStmtApp"] = DecryptedbankStmt;
                    dr["Liability"] = DecryptedLiability;
                    dr["mgtAcc"] = DecryptedmgtAcc;

                    dt.Rows.Add(dr);
                }
            }

            AppDetail2.DataSource = dt;
            AppDetail2.DataBind();

            if (AppDetail2.Rows.Count > 0)
            {

                DataRowView dataRow = (DataRowView)AppDetail2.DataItem;

                LinkButton bankStmtButton = AppDetail2.FindControl("bankStmtApp") as LinkButton;
                LinkButton LiabilityButton = AppDetail2.FindControl("Liability") as LinkButton;
                LinkButton mgtAccButton = AppDetail2.FindControl("mgtAcc") as LinkButton;

                if (bankStmtButton != null)
                {

                    string DecryptedbankStmt = dataRow["bankStmtApp"].ToString();
                    bankStmtButton.CommandArgument = "bankStmtApp," + DecryptedbankStmt;
                }

                if (LiabilityButton != null)
                {
                    string DecryptedLiability = dataRow["Liability"].ToString();
                    LiabilityButton.CommandArgument = "Liability," + DecryptedLiability;
                }

                if (mgtAccButton != null)
                {
                    string DecryptedmgtAcc = dataRow["mgtAcc"].ToString();
                    mgtAccButton.CommandArgument = "mgtAcc," + DecryptedmgtAcc;
                }
            }
        }

        protected void DownloadFile(object sender, CommandEventArgs e)
        {
            LinkButton lnkButton = (LinkButton)sender;
            string argument = Convert.ToString(e.CommandArgument);

            args = argument.Split(',');
            documentType = args[0];
            fileName = args[1];

            //string documentType = lnkButton.CommandName;
            string folderPath = "";

            switch (documentType)
            {
                case "icDoc":
                    folderPath = Server.MapPath("~/Client/ICDocument/");
                    break;
                case "bizCert":
                    folderPath = Server.MapPath("~/Client/Borrower/Business Cert/");
                    break;
                case "utilityBill":
                    folderPath = Server.MapPath("~/Client/Borrower/Utility Bill/");
                    break;
                case "form9":
                    folderPath = Server.MapPath("~/Client/Borrower/Form 9/");
                    break;
                case "bankStmt":
                    folderPath = Server.MapPath("~/Client/Borrower/Bank Statement/");
                    break;
                case "bankStmtApp":
                    folderPath = Server.MapPath("~/Client/Borrower/Application/");
                    break;
                case "Liability":
                    folderPath = Server.MapPath("~/Client/Borrower/Application/");
                    break;
                case "mgtAcc":
                    folderPath = Server.MapPath("~/Client/Borrower/Application/");
                    break;
            }

            string filePath = folderPath + fileName;
            Debug.WriteLine("filePath: " + filePath);

            // Check if file exists on the server
            if (File.Exists(filePath))
            {
                Debug.WriteLine("filePath  exist: " + filePath);
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(fileName));
                Response.TransmitFile(filePath);
                Response.End();
            }
            else
            {
                // show an error message
                Debug.WriteLine("file not found: ");
                Response.Write("<script>alert('File not found.');</script>");
            }
        }

        protected void creditRatingDdl_SelectedIndexChanged(object sender, EventArgs e)
        {
            string creditRating = creditRatingDropdown.SelectedItem.ToString();

            switch (creditRating)
            {
                case "CREDIT A":
                    interestRateTxtbx.Text = "0.05";
                    break;
                case "CREDIT B":
                    interestRateTxtbx.Text = "0.09";
                    break;
                case "CREDIT C":
                    interestRateTxtbx.Text = "0.13";
                    break;
                default:
                    interestRateTxtbx.Text = "Invalid credit rating";
                    break;
            }
        }

        protected void Approve_Click(object sender, EventArgs e)
        {
            try
            {
                // SQL Connection
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                // Updaate financial app
                // Credit rating, interest rate, status
                string appID = Session["appID"].ToString();
                string creditRating = creditRatingDropdown.SelectedItem.ToString();
                string interestRate = interestRateTxtbx.Text;
                string status = "approved";
                DateTime approveDT = DateTime.Now;

                string query = "update financingApplication " +
                    "set creditRating = @creditRating, interestRate = @interestRate, status = @status, approvalDate = @approvalDate " +
                    "where appID = @appID";
                SqlCommand cmd1 = new SqlCommand(query, con);
                cmd1.Parameters.AddWithValue("@creditRating", creditRating);
                cmd1.Parameters.AddWithValue("@interestRate", interestRate);
                cmd1.Parameters.AddWithValue("@status", status);
                cmd1.Parameters.AddWithValue("@appID", appID);
                cmd1.Parameters.AddWithValue("@approvalDate", approveDT);
                cmd1.ExecuteNonQuery();

                IntegrityCheck checkApp = new IntegrityCheck();
                string app = checkApp.GetAppDetails(appID);
                string hashApp = IntegrityCheck.ComputeSha256Hash(app);
                Debug.WriteLine("The hash for " + app + " is " + hashApp);
                con.Close();

                TableName1.Value = "App";
                hash1.Value = hashApp;
                pkey1.Value = appID;
                callScript.Value = "reviewed";
            }
            catch
            {
                Response.Write("<script>alert('Unknown Error in Approving Application.');</script>");
            }
            
        }

        protected void Decline_Click(object sender, EventArgs e)
        {
            try
            {
                // SQL Connection
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                // Updaate financial app
                string appID = Session["appID"].ToString();
                string status = "declined";

                string query = "update financingApplication " +
                        "set status = @status " +
                        "where appID = @appID";
                SqlCommand cmd1 = new SqlCommand(query, con);
                cmd1.Parameters.AddWithValue("@status", status);
                cmd1.Parameters.AddWithValue("@appID", appID);
                cmd1.ExecuteNonQuery();

                IntegrityCheck checkApp = new IntegrityCheck();
                string app = checkApp.GetAppDetails(appID);
                string hashApp = IntegrityCheck.ComputeSha256Hash(app);
                Debug.WriteLine("The hash for " + app + " is " + hashApp);
                con.Close();

                TableName1.Value = "App";
                hash1.Value = hashApp;
                pkey1.Value = appID;
                callScript.Value = "reviewed";
            }
            catch
            {
                Response.Write("<script>alert('Unknown Error in Declining Application.');</script>");
            }
        }

        protected void Back_Click(object sender, EventArgs e)
        {
            Response.Redirect("Admin Financing Approval 1.aspx");
        }
    }
}