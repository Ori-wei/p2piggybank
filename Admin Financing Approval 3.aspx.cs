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
    public partial class WebForm24 : System.Web.UI.Page
    {
        string[] args;
        string documentType;
        string fileName;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string borrowerID = "";
                string lenderID = "";

                Debug.WriteLine("Test bind start");
                string clientID = Session["clientID"].ToString();
                BindAppDetail1(clientID);
                BindAppDetail2(clientID);

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                if (Session["borrowerID"] != null)
                {
                    borrowerID = Session["borrowerID"].ToString();
                    BindAppDetail3(borrowerID);
                    BindAppDetail4(borrowerID);
                    borrowerTitle.Visible = true;
                    detailContainer1.Visible = true;
                }
                else
                {
                    borrowerTitle.Visible = false;
                    detailContainer1.Visible = false;
                }

                if (Session["lenderID"] != null)
                {
                    lenderID = Session["lenderID"].ToString();
                    BindAppDetail5(lenderID);
                    BindAppDetail6(lenderID);
                    lenderTitle.Visible = true;
                    detailContainer2.Visible = true;
                }
                else
                {
                    lenderTitle.Visible = false;
                    detailContainer2.Visible = false;
                }

                Debug.WriteLine("ID on Admin bgv 2");
                Debug.WriteLine(clientID);
                Debug.WriteLine(borrowerID);
                Debug.WriteLine(lenderID);

                var statusCell = AppDetail2.Rows[3].Cells[1];
                Debug.WriteLine("Check status: " + statusCell.Text.Trim());
            }
        }

        protected void AppDetail2_DataBound(object sender, EventArgs e)
        {
            Debug.WriteLine("Check if dataBound hit ");

        }

        protected void BindAppDetail1(string clientID)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("icNo");
            dt.Columns.Add("fullName");
            dt.Columns.Add("DoB");
            dt.Columns.Add("Gender");

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //Retrieve Details
            string query = "SELECT CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, icNo)) AS DecryptedIcNo, " +
                "fullName, DoB, Gender FROM Client WHERE clientID = @clientID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Passphrase", "FYPp2plendingsystem23!");
            cmd.Parameters.AddWithValue("@clientID", clientID);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    string decryptedIcNo = reader["DecryptedIcNo"] != DBNull.Value ? reader["DecryptedIcNo"].ToString() : null;
                    string fullName = reader["fullName"].ToString();
                    string DoB = reader["DoB"].ToString();
                    string Gender = reader["Gender"].ToString();

                    DataRow dr = dt.NewRow();
                    dr["icNo"] = decryptedIcNo; // Add the decrypted IC No to the DataRow
                    dr["fullName"] = fullName;
                    dr["DoB"] = DoB;
                    dr["Gender"] = Gender;

                    dt.Rows.Add(dr);
                }
            }

            // Set the decrypted data as GridView data
            AppDetail1.DataSource = dt;
            AppDetail1.DataBind();
        }

        protected void BindAppDetail2(string clientID)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("contactNo");
            dt.Columns.Add("icDoc");
            dt.Columns.Add("publicKey");
            dt.Columns.Add("status");

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //Retrieve Details
            string query = "SELECT contactNo, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, icDoc)) AS DecryptedIcDoc, " +
                "publicKey, status FROM Client WHERE clientID = @clientID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Passphrase", "FYPp2plendingsystem23!");
            cmd.Parameters.AddWithValue("@clientID", clientID);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    string contactNo = reader["contactNo"].ToString();
                    string decryptedIcDoc = reader["decryptedIcDoc"] != DBNull.Value ? reader["decryptedIcDoc"].ToString() : null;
                    string publicKey = reader["publicKey"].ToString();
                    string status = reader["status"].ToString();

                    DataRow dr = dt.NewRow();
                    dr["contactNo"] = contactNo; // Add the decrypted IC No to the DataRow
                    dr["icDoc"] = decryptedIcDoc;
                    dr["publicKey"] = publicKey;
                    dr["status"] = status;

                    dt.Rows.Add(dr);
                }
            }

            //Set Client data as gridview data
            AppDetail2.DataSource = dt;
            AppDetail2.DataBind();

            if (AppDetail2.Rows.Count > 0)
            {
                DataRowView dataRow = (DataRowView)AppDetail2.DataItem;
                LinkButton icDocButton = AppDetail2.FindControl("icDoc") as LinkButton;
                if (icDocButton != null)
                {

                    string DecryptedBizCert = dataRow["icDoc"].ToString();
                    icDocButton.CommandArgument = "icDoc," + DecryptedBizCert;
                }
            }
        }

        protected void BindAppDetail3(string borrowerID)
        {
            //Retrieve Details
            AppSource3.SelectCommand = "SELECT borrowerID, bizName, bizRegNo, bizAdd, bizContact, bizIndustry FROM Borrower WHERE borrowerID = @borrowerID";
            AppSource3.SelectParameters.Clear();
            AppSource3.SelectParameters.Add("borrowerID", borrowerID);

            //Set Client data as gridview data
            AppDetail3.DataBind();
        }

        protected void BindAppDetail4(string borrowerID)
        {
            // Create a table to hold the decrypted data
            DataTable dt = new DataTable();
            dt.Columns.Add("entityType");
            dt.Columns.Add("bizCert");
            dt.Columns.Add("utilityBill");
            dt.Columns.Add("form9");
            dt.Columns.Add("bankStmt");

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT entityType, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, bizCert)) AS DecryptedbizCert, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, utilityBill)) AS DecryptedutilityBill, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, form9)) AS Decryptedform9, " +
                "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, bankStmt)) AS DecryptedbankStmt " +
                "FROM Borrower WHERE borrowerID = @borrowerID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Passphrase", "FYPp2plendingsystem23!");
            cmd.Parameters.AddWithValue("@borrowerID", borrowerID);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    string entityType = reader["entityType"].ToString();
                    string DecryptedbizCert = reader["DecryptedbizCert"] != DBNull.Value ? reader["DecryptedbizCert"].ToString() : null;
                    string DecryptedutilityBill = reader["DecryptedutilityBill"] != DBNull.Value ? reader["DecryptedutilityBill"].ToString() : null;
                    string Decryptedform9 = reader["Decryptedform9"] != DBNull.Value ? reader["Decryptedform9"].ToString() : null;
                    string DecryptedbankStmt = reader["DecryptedbankStmt"] != DBNull.Value ? reader["DecryptedbankStmt"].ToString() : null;

                    DataRow dr = dt.NewRow();
                    dr["entityType"] = entityType;
                    dr["bizCert"] = DecryptedbizCert;
                    dr["utilityBill"] = DecryptedutilityBill;
                    dr["form9"] = Decryptedform9;
                    dr["bankStmt"] = DecryptedbankStmt;

                    dt.Rows.Add(dr);
                }
            }

            AppDetail4.DataSource = dt;
            AppDetail4.DataBind();

            if (AppDetail4.Rows.Count > 0)
            {

                DataRowView dataRow = (DataRowView)AppDetail4.DataItem;

                LinkButton bizCertButton = AppDetail4.FindControl("bizCert") as LinkButton;
                LinkButton utilityBillButton = AppDetail4.FindControl("utilityBill") as LinkButton;
                LinkButton form9Button = AppDetail4.FindControl("form9") as LinkButton;
                LinkButton bankStmtButton = AppDetail4.FindControl("bankStmt") as LinkButton;

                if (bizCertButton != null)
                {

                    string DecryptedBizCert = dataRow["bizCert"].ToString();
                    bizCertButton.CommandArgument = "bizCert," + DecryptedBizCert;
                }

                if (utilityBillButton != null)
                {
                    string DecryptedutilityBill = dataRow["utilityBill"].ToString();
                    utilityBillButton.CommandArgument = "utilityBill," + DecryptedutilityBill;
                }

                if (form9Button != null)
                {
                    string Decryptedform9 = dataRow["form9"].ToString();
                    form9Button.CommandArgument = "form9," + Decryptedform9;
                }

                if (bankStmtButton != null)
                {
                    string DecryptedbankStmt = dataRow["bankStmt"].ToString();
                    bankStmtButton.CommandArgument = "bankStmt," + DecryptedbankStmt;
                }

            }
        }

        protected void BindAppDetail5(string lenderID)
        {
            //Retrieve Details
            AppSource5.SelectCommand = "SELECT lenderID, annualIncome FROM Lender WHERE lenderID = @lenderID";
            AppSource5.SelectParameters.Clear();
            AppSource5.SelectParameters.Add("lenderID", lenderID);

            //Set Client data as gridview data
            AppDetail5.DataBind();
        }

        protected void BindAppDetail6(string lenderID)
        {
            //Retrieve Details
            AppSource6.SelectCommand = "SELECT riskTolerance, riskAck FROM Lender WHERE lenderID = @lenderID";
            AppSource6.SelectParameters.Clear();
            AppSource6.SelectParameters.Add("lenderID", lenderID);

            //Set Client data as gridview data
            AppDetail6.DataBind();
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

        protected void Back_Click(object sender, EventArgs e)
        {
            Response.Redirect("Admin Financing Approval 1.aspx");
        }
    }
}