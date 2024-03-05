using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm19 : System.Web.UI.Page
    {
        private const string ActiveTabKey = "ActiveTabIndex";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if(Session["clientID"] == null)
                {
                    Response.Redirect("34-Lender My Profile.aspx");
                }
                else
                {
                    InvestedTab_Click(investedTab, EventArgs.Empty);
                }
            }
        }

        protected void InvestedTab_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 0;
            ViewState[ActiveTabKey] = 0;
            UpdateTabClasses();

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = Session["clientID"].ToString();
            string query1 = "SELECT lenderID from Lender where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string lenderID = (string)cmdCheck.ExecuteScalar();

            if(lenderID != null)
            {
                //Retrieve Class Details
                string query2 = "SELECT n.noteAddress, a.interestRate, a.Duration, " +
                    "a.financingAmt, i.investedAmt, n.listedEndDate " +
                    "FROM Note n " +
                    "INNER JOIN financingApplication a ON n.appID = a.appID " +
                    "INNER JOIN InvestedNote i ON n.noteAddress = i.noteAddress " +
                    "WHERE n.noteStatus = 'funding' AND i.lenderID = @LenderID";
                SqlCommand cmd = new SqlCommand(query2, con);
                cmd.Parameters.AddWithValue("@LenderID", lenderID);

                DataTable dt = new DataTable();
                dt.Columns.Add("noteAddress");
                dt.Columns.Add("interestRate");
                dt.Columns.Add("Duration");
                dt.Columns.Add("financingAmt");
                dt.Columns.Add("investedAmt");
                dt.Columns.Add("listedEndDate");

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        // Assuming the data types are string for dates, decimal for amounts and interest rates
                        string noteAddress = reader["noteAddress"].ToString();
                        string interestRate = reader["interestRate"].ToString();
                        string Duration = reader["Duration"].ToString();
                        decimal financingAmt = (decimal)reader["financingAmt"];
                        decimal investedAmt = (decimal)reader["investedAmt"];
                        string listedEndDate = reader["listedEndDate"].ToString();

                        DataRow dr = dt.NewRow();
                        dr["noteAddress"] = noteAddress;
                        dr["interestRate"] = interestRate;
                        dr["Duration"] = Duration;
                        dr["financingAmt"] = financingAmt;
                        dr["investedAmt"] = investedAmt;
                        dr["listedEndDate"] = listedEndDate;

                        dt.Rows.Add(dr);
                    }
                }
                //Set Client data as gridview data
                investedTB.DataSource = dt;
                investedTB.DataBind();
            }
        }

        protected void ServicingTab_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 1;
            ViewState[ActiveTabKey] = 1;
            UpdateTabClasses();

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = Session["clientID"].ToString();
            string query1 = "SELECT lenderID from Lender where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string lenderID = (string)cmdCheck.ExecuteScalar();

            //Retrieve Class Details
            string query2 = "SELECT n.noteAddress, a.interestRate, a.Duration, " +
                "a.financingAmt, i.investedAmt, n.repaymentDate " +
                "FROM Note n " +
                "INNER JOIN financingApplication a ON n.appID = a.appID " +
                "INNER JOIN InvestedNote i ON n.noteAddress = i.noteAddress " +
                "WHERE n.noteStatus = 'disbursed' AND i.lenderID = @LenderID";
            SqlCommand cmd = new SqlCommand(query2, con);
            cmd.Parameters.AddWithValue("@LenderID", lenderID);

            DataTable dt = new DataTable();
            dt.Columns.Add("noteAddress");
            dt.Columns.Add("interestRate");
            dt.Columns.Add("Duration");
            dt.Columns.Add("financingAmt");
            dt.Columns.Add("investedAmt");
            dt.Columns.Add("repaymentDate");

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string noteAddress = reader["noteAddress"].ToString();
                    string interestRate = reader["interestRate"].ToString();
                    string Duration = reader["Duration"].ToString();
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    decimal investedAmt = (decimal)reader["investedAmt"];
                    string repaymentDate = reader["repaymentDate"].ToString();

                    DataRow dr = dt.NewRow();
                    dr["noteAddress"] = noteAddress;
                    dr["interestRate"] = interestRate;
                    dr["Duration"] = Duration;
                    dr["financingAmt"] = financingAmt;
                    dr["investedAmt"] = investedAmt;
                    dr["repaymentDate"] = repaymentDate;

                    dt.Rows.Add(dr);
                }
            }
            //Set Client data as gridview data
            servicingTB.DataSource = dt;
            servicingTB.DataBind();
        }

        protected void CompletedTab_Click(object sender, EventArgs e)
        {
            MultiView1.ActiveViewIndex = 2;
            ViewState[ActiveTabKey] = 2;
            UpdateTabClasses();

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string clientID = Session["clientID"].ToString();
            string query1 = "SELECT lenderID from Lender where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string lenderID = (string)cmdCheck.ExecuteScalar();

            //Retrieve Class Details
            string query2 = "SELECT n.noteAddress, a.interestRate, a.Duration, " +
                "a.financingAmt, i.investedAmt, n.repaymentDate, n.noteStatus " +
                "FROM Note n " +
                "INNER JOIN financingApplication a ON n.appID = a.appID " +
                "INNER JOIN InvestedNote i ON n.noteAddress = i.noteAddress " +
                "WHERE n.noteStatus IN ('completed', 'failed') AND i.lenderID = @LenderID";
            SqlCommand cmd = new SqlCommand(query2, con);
            cmd.Parameters.AddWithValue("@LenderID", lenderID);

            DataTable dt = new DataTable();
            dt.Columns.Add("noteAddress");
            dt.Columns.Add("interestRate");
            dt.Columns.Add("Duration");
            dt.Columns.Add("financingAmt");
            dt.Columns.Add("investedAmt");
            dt.Columns.Add("repaymentDate");
            dt.Columns.Add("noteStatus");

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string noteAddress = reader["noteAddress"].ToString();
                    string interestRate = reader["interestRate"].ToString();
                    string Duration = reader["Duration"].ToString();
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    decimal investedAmt = (decimal)reader["investedAmt"];
                    string repaymentDate = reader["repaymentDate"].ToString();
                    string noteStatus = reader["noteStatus"].ToString();

                    DataRow dr = dt.NewRow();
                    dr["noteAddress"] = noteAddress;
                    dr["interestRate"] = interestRate;
                    dr["Duration"] = Duration;
                    dr["financingAmt"] = financingAmt;
                    dr["investedAmt"] = investedAmt;
                    dr["repaymentDate"] = repaymentDate;
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
            investedTab.CssClass = investedTab.CssClass.Replace("active-tab", "");
            servicingTab.CssClass = servicingTab.CssClass.Replace("active-tab", "");
            completedTab.CssClass = completedTab.CssClass.Replace("active-tab", "");

            // Add the active-tab class to the currently active tab
            switch (activeTabIndex)
            {
                case 0:
                    investedTab.CssClass += " active-tab";
                    break;
                case 1:
                    servicingTab.CssClass += " active-tab";
                    break;
                case 2:
                    completedTab.CssClass += " active-tab";
                    break;
            }
        }
    }
}