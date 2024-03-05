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
    public partial class WebForm18 : System.Web.UI.Page
    {
        private const string ActiveTabKey = "ActiveTabIndex";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if(Session["clientID"] == null)
                {
                    Response.Redirect("3-Borrower My Profile.aspx");
                }
                else
                {
                    FundraisingTab_Click(fundraisingTab, EventArgs.Empty);
                }
            }
        }

        protected void FundraisingTab_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            ViewState[ActiveTabKey] = 0;
            UpdateTabClasses();

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = Session["clientID"].ToString();
            string query1 = "SELECT borrowerID from Borrower where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string borrowerID = (string)cmdCheck.ExecuteScalar();

            //Retrieve Class Details
            string query2 = "select n.noteAddress, n.listedEndDate, " +
                "a.financingAmt, n.fundedToDate from Note n inner join financingApplication a on n.appID = a.appID " +
                "where n.noteStatus = 'funding' and a.borrowerID = '" + borrowerID + "'";
            SqlCommand cmd = new SqlCommand(query2, con);

            DataTable dt = new DataTable();
            dt.Columns.Add("noteAddress");
            dt.Columns.Add("listedEndDate");
            dt.Columns.Add("financingAmt");
            dt.Columns.Add("fundedToDate");
            dt.Columns.Add("remainingAmt");

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string noteAddress = reader["noteAddress"].ToString();
                    string listedEndDate = reader["listedEndDate"].ToString();
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    decimal fundedToDate = (decimal)reader["fundedToDate"];

                    // Calculate remaining amount
                    decimal remainingAmt = financingAmt - fundedToDate;
                    Debug.WriteLine(remainingAmt);

                    DataRow dr = dt.NewRow();
                    dr["noteAddress"] = noteAddress;
                    dr["listedEndDate"] = listedEndDate;
                    dr["financingAmt"] = financingAmt;
                    dr["fundedToDate"] = fundedToDate;
                    dr["remainingAmt"] = remainingAmt;

                    dt.Rows.Add(dr);
                }
            }

            //Set Client data as gridview data
            fundraisingTB.DataSource = dt;
            fundraisingTB.DataBind();
        }

        protected void RepaymentTab_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 1;
            ViewState[ActiveTabKey] = 1;
            UpdateTabClasses();
            
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = Session["clientID"].ToString();
            string query1 = "SELECT borrowerID from Borrower where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string borrowerID = (string)cmdCheck.ExecuteScalar();

            //Retrieve Class Details
            string query2 = "select n.noteAddress, n.repaymentDate, " +
                "a.financingAmt, a.interestRate, n.repaymentAmt from Note n inner join financingApplication a on n.appID = a.appID " +
                "where n.noteStatus = 'disbursed' and a.borrowerID = '" + borrowerID + "'";
            SqlCommand cmd = new SqlCommand(query2, con);

            DataTable dt = new DataTable();
            dt.Columns.Add("noteAddress");
            dt.Columns.Add("repaymentDate");
            dt.Columns.Add("financingAmt");
            dt.Columns.Add("interestRate");
            dt.Columns.Add("repaymentAmt");

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string noteAddress = reader["noteAddress"].ToString();
                    string repaymentDate = reader["repaymentDate"].ToString();
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    string interestRate = reader["interestRate"].ToString();
                    decimal repaymentAmt = (decimal)reader["repaymentAmt"];

                    DataRow dr = dt.NewRow();
                    dr["noteAddress"] = noteAddress;
                    dr["repaymentDate"] = repaymentDate;
                    dr["financingAmt"] = financingAmt;
                    dr["interestRate"] = interestRate;
                    dr["repaymentAmt"] = repaymentAmt;

                    dt.Rows.Add(dr);
                }
            }
            //Set Client data as gridview data
            repaymentTB.DataSource = dt;
            repaymentTB.DataBind();
        }

        protected void CompleteTab_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 2;
            ViewState[ActiveTabKey] = 2;
            UpdateTabClasses();
            
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = Session["clientID"].ToString();
            string query1 = "SELECT borrowerID from Borrower where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string borrowerID = (string)cmdCheck.ExecuteScalar();

            //Retrieve Class Details
            string query2 = "select n.noteAddress, n.repaymentDate, " +
                "a.financingAmt, a.interestRate, n.repaymentAmt, n.noteStatus from Note n inner join financingApplication a on n.appID = a.appID " +
                "where n.noteStatus = 'completed' and a.borrowerID = '" + borrowerID + "'";
            SqlCommand cmd = new SqlCommand(query2, con);

            DataTable dt = new DataTable();
            dt.Columns.Add("noteAddress");
            dt.Columns.Add("repaymentDate");
            dt.Columns.Add("financingAmt");
            dt.Columns.Add("interestRate");
            dt.Columns.Add("repaymentAmt");
            dt.Columns.Add("noteStatus");

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string noteAddress = reader["noteAddress"].ToString();
                    string repaymentDate = reader["repaymentDate"].ToString();
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    string interestRate = reader["interestRate"].ToString();
                    decimal repaymentAmt = (decimal)reader["repaymentAmt"];
                    string noteStatus = reader["noteStatus"].ToString();

                    DataRow dr = dt.NewRow();
                    dr["noteAddress"] = noteAddress;
                    dr["repaymentDate"] = repaymentDate;
                    dr["financingAmt"] = financingAmt;
                    dr["interestRate"] = interestRate;
                    dr["repaymentAmt"] = repaymentAmt;
                    dr["noteStatus"] = noteStatus;

                    dt.Rows.Add(dr);
                }
            }
            //Set Client data as gridview data
            completedTB.DataSource = dt;
            completedTB.DataBind();
        }

        private void UpdateTabClasses()
        {
            // Retrieve the active tab index from ViewState
            int activeTabIndex = Convert.ToInt32(ViewState[ActiveTabKey]);

            // Remove all active-tab classes
            fundraisingTab.CssClass = fundraisingTab.CssClass.Replace("active-tab", "");
            repaymentTab.CssClass = repaymentTab.CssClass.Replace("active-tab", "");
            completedTab.CssClass = completedTab.CssClass.Replace("active-tab", "");

            // Add the active-tab class to the currently active tab
            switch (activeTabIndex)
            {
                case 0:
                    fundraisingTab.CssClass += " active-tab";
                    break;
                case 1:
                    repaymentTab.CssClass += " active-tab";
                    break;
                case 2:
                    completedTab.CssClass += " active-tab";
                    break;
            }
        }
    }
}