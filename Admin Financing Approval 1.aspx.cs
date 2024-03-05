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
    public partial class WebForm13 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT appID, appDateTime, financingAmt," +
                "Duration, borrowerID FROM financingApplication where status = 'pending'";
            SqlDataAdapter da1 = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            da1.Fill(dt);

            //Set Client data as gridview data
            financingAppTB.DataSource = dt;
            financingAppTB.DataBind();
        }


        protected void ShowBorrower(object sender, CommandEventArgs e)
        {
            if (e.CommandArgument != null)
            {
                // get borrowerID
                string borrowerID = e.CommandArgument.ToString();

                Session["borrowerID"] = borrowerID;
                Debug.WriteLine(Session["borrowerID"]);

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                // retrieve clientID
                string query1 = "select clientID from Borrower where borrowerID = '" + borrowerID + "'";
                SqlCommand cmd1 = new SqlCommand(query1, con);
                string clientID = (string)cmd1.ExecuteScalar();
                Session["clientID"] = clientID;

                // retrieve lender id
                string query2 = "select lenderID from Lender where clientID = '" + clientID + "'";
                SqlCommand cmd2 = new SqlCommand(query2, con);
                string lenderID = (string)cmd2.ExecuteScalar();
                Session["lenderID"] = lenderID;

                // Next page
                Response.Redirect("Admin Financing Approval 3.aspx");
            }
        }
        protected void ShowApp(object sender, CommandEventArgs e)
        {
            // get appID
            string appID = e.CommandArgument.ToString();

            Session["appID"] = appID;
            Debug.WriteLine(Session["appID"]);

            // Next page
            Response.Redirect("Admin Financing Approval 2.aspx");
        }
    }
}