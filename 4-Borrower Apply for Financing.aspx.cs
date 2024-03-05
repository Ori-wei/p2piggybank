using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm7 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["clientID"] != null)
            {
                string publicKey = Session["publicKey"].ToString();
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string clientID = Session["clientID"].ToString();
                Debug.WriteLine("Test:" + clientID);

                // check status
                string query = "select status from Client where clientID = @clientID";
                SqlCommand cmdCheck = new SqlCommand(query, con);
                cmdCheck.Parameters.AddWithValue("@clientID", clientID);
                string verifyStatus = ((string)cmdCheck.ExecuteScalar())?.Trim(); // Trim the result
                Debug.WriteLine("Test:" + verifyStatus);

                if (verifyStatus == "verified")
                {
                    ApplyForFinancingForm.Visible = true;
                }
                else
                {
                    string script = "alert('Your identity is not verified yet. Redirecting to homepage.'); window.location = '1-Client Homepage.aspx';";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ServerControlScript", script, true);
                }
                con.Close();
            }
            else
            {
                Response.Redirect("3-Borrower My Profile.aspx");
            }
            
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            // parse data to the next page
            Session["financingAmt"] = financingAmt.Text;
            Session["noteDuration"] = noteDuration.SelectedItem.Text;
            Session["financingPurpose"] = financingPurpose.SelectedItem.Text;

            // Redirect to the second page
            Response.Redirect("41-Borrower Apply for Financing 2.aspx");
        }

        protected void backBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("1-Client Homepage.aspx");
        }
    }
}