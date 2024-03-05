using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm17 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string appID = Session["appID"].ToString();
                Debug.WriteLine(appID);
                BindAppDetail1(appID);
                BindAppDetail2(appID);

                // SQL Connection
                string status = "";
                string signature = "";
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();
                string query1 = "SELECT status, signature FROM financingApplication WHERE appID = @appID";
                SqlCommand cmd1 = new SqlCommand(query1, con);
                cmd1.Parameters.AddWithValue("@appID", appID);
                using (SqlDataReader reader = cmd1.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        status = (string)reader["status"];
                        signature = reader.IsDBNull(reader.GetOrdinal("signature")) ? null : (string)reader["signature"];
                    }
                }

                if (status == "accepted" || status == "rejected")
                {
                    Accept.Visible = false;
                    Reject.Visible = false;
                    Label3.Text = "Your Decision: " + status;
                    appSignature.Text = "Your Signature: " + signature;
                }
                else
                {
                    Accept.Visible = true;
                    Reject.Visible = true;
                    Label3.Text = "Your Decision: ";
                }

                //loan Duration, interestRate, financingAmt
                int loanDuration = 0;
                decimal interestRate = 0;
                decimal financingAmount = 0;
                string query = "select Duration, interestRate, financingAmt from financingApplication where appID = @AppID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@AppID", appID);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        loanDuration = (int)reader["Duration"];
                        interestRate = (decimal)reader["interestRate"];
                        financingAmount = (decimal)reader["financingAmt"];
                    }
                }

                //repaymentAmt
                decimal repaymentAmt = CalculateRepaymentAmount(interestRate, financingAmount);

                hidden_financingAmt.Value = financingAmount.ToString();
                hidden_interestRate.Value = interestRate.ToString();
                hidden_Duration.Value = loanDuration.ToString();
                hidden_repaymentAmt.Value = repaymentAmt.ToString();

                Debug.WriteLine("Duration in hidden field (string):" + hidden_Duration.Value);

                IntegrityCheck ic = new IntegrityCheck();
                string appRecord = ic.GetAppDetails(appID);
                hidden_appRecord.Value = appRecord;
            }

        }

        protected void BindAppDetail1(string appID)
        {
            //Retrieve Details
            AppSource1.SelectCommand = "SELECT appID, appDateTime, financingAmt, Duration, financingPurpose FROM financingApplication WHERE appID = @AppID";
            AppSource1.SelectParameters.Clear();
            AppSource1.SelectParameters.Add("AppID", appID);

            //Set Client data as gridview data
            AppDetail1.DataBind();
        }

        protected void BindAppDetail2(string appID)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //Retrieve Details
            string query = "select approvalDate, creditRating, interestRate, financingAmt from financingApplication where appID = @AppID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@AppID", appID);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string approvalDate = reader["approvalDate"].ToString();
                    string creditRating = reader["creditRating"].ToString();
                    decimal interestRate = (decimal)reader["interestRate"];
                    decimal financingAmount = (decimal)reader["financingAmt"];

                    // Calculate repayment amount - implement your own logic here
                    decimal repaymentAmount = CalculateRepaymentAmount(interestRate, financingAmount);

                    // Create a DataTable and add the values
                    DataTable dt = new DataTable();
                    dt.Columns.Add("approvalDate");
                    dt.Columns.Add("creditRating");
                    dt.Columns.Add("interestRate");
                    dt.Columns.Add("repaymentAmt");

                    DataRow dr = dt.NewRow();
                    dr["approvalDate"] = approvalDate;
                    dr["creditRating"] = creditRating;
                    dr["interestRate"] = interestRate.ToString(); // Convert to string if necessary
                    dr["repaymentAmt"] = repaymentAmount.ToString(); // Convert to string if necessary

                    dt.Rows.Add(dr);

                    //Set Client data as gridview data
                    AppDetail2.DataSource = dt;
                    AppDetail2.DataBind();
                }
            }
        }

        private decimal CalculateRepaymentAmount(decimal interestRate, decimal financingAmount)
        {
            decimal interest = interestRate * financingAmount;
            decimal repaymentAmount = interest + financingAmount;
            repaymentAmount = Math.Round(repaymentAmount, 2, MidpointRounding.AwayFromZero);
            return repaymentAmount;
        }

        protected void Reject_Click(object sender, EventArgs e)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string appID = Session["appID"].ToString();

            string query = "update financingApplication set status = 'rejected' where appID = @AppID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@AppID", appID);

            IntegrityCheck checkApp = new IntegrityCheck();
            string app = checkApp.GetAppDetails(appID);
            string hashApp = IntegrityCheck.ComputeSha256Hash(app);
            Debug.WriteLine("The hash for " + app + " is " + hashApp);
            con.Close();

            TableName1.Value = "App";
            hash1.Value = hashApp;
            callScript.Value = "reviewed";
        }

        protected void Back_Click(object sender, EventArgs e)
        {
            Response.Redirect("5-Borrower My Application.aspx");
        }
    }
}