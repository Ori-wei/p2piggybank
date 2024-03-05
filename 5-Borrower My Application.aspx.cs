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
    public partial class WebForm16 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["clientID"] == null)
            {
                Response.Redirect("3-Borrower My Profile.aspx");
            }
            else
            {
                string clientID = Session["clientID"].ToString();
                BindGrid(clientID);
            }
        }

        private void BindGrid(string clientID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query1 = "SELECT borrowerID from Borrower where clientID = @clientID";
            SqlCommand cmdCheck = new SqlCommand(query1, con);
            cmdCheck.Parameters.AddWithValue("@clientID", clientID);
            string borrowerID = (string)cmdCheck.ExecuteScalar();

            string query2 = "SELECT appID, appDateTime, financingAmt," +
                "Duration, financingPurpose, status FROM financingApplication where borrowerID = '" + borrowerID + "'";
            SqlDataAdapter da1 = new SqlDataAdapter(query2, con);
            DataTable dt = new DataTable();
            da1.Fill(dt);

            //Set Client data as gridview data
            myApplicationTB.DataSource = dt;
            myApplicationTB.DataBind();
        }

        protected void myApplicationTB_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Retrieve the status value from the DataItem of the row
                var dataItem = e.Row.DataItem as DataRowView;
                string status = dataItem["status"].ToString();

                LinkButton viewBtn = (LinkButton)e.Row.FindControl("viewBtn");

                if (viewBtn != null)
                {
                    switch (status.ToLower())
                    {
                        case "pending":
                            viewBtn.Visible = false;
                            break;
                        case "approved":
                            viewBtn.Visible = true;
                            break;
                        case "declined":
                            viewBtn.Visible = false;
                            break;
                    }
                }
            }
        }

        protected void ShowApp(object sender, CommandEventArgs e)
        {
            // get appID
            string appID = e.CommandArgument.ToString();

            Session["appID"] = appID;
            Debug.WriteLine(Session["appID"]);

            // Next page
            Response.Redirect("51-Borrower My Application 2.aspx");
        }
    }
}