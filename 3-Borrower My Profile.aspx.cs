using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string publicKey = Session["publicKey"].ToString();
            Debug.WriteLine("Test parsing public Key: "+publicKey);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            if (Session["clientID"] == null)
            {
                // new user
                CreateProfileForm.Visible = true;
            }
            else
            {
                // existing user
                if (Session["borrowerID"] == null)
                {
                    Response.Redirect("31-Borrower My Profile 2.aspx");
                }
                else
                {
                    Response.Redirect("35-Show User Profile.aspx");
                }
            }
            con.Close();
        }

        [WebMethod]
        public static string CheckICExists(string ic)
        {
            /*SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if the public key already exists
            string checkKeyQuery = "SELECT COUNT(*) FROM Client WHERE icNo = @ic";
            SqlCommand cmdCheck = new SqlCommand(checkKeyQuery, con);
            cmdCheck.Parameters.AddWithValue("@ic", ic);
            int exists = (int)cmdCheck.ExecuteScalar();

            if(exists != 0)
            {
                return "exists";
            }
            else
            {*/
            string yearPrefix = ic.Substring(0, 2);
            int year = int.Parse(yearPrefix);
            string century;

            // set century
            if (year >= 10 && year <= 99)
            {
                century = "19";
            }
            else if (year >= 0 && year <= 6)
            {  // Assuming year prefix ranges from 00 to 06 for 2000 to 2006
                century = "20";
            }
            else
            {
                century = "invalid"; // Handle invalid year prefix
            }

            if (century != "invalid")
            {
                string dob = ic.Substring(2, 2) + "-" + ic.Substring(4, 2) + "-" + century + yearPrefix;
                return dob;
            }
            return null;
        }

        protected void backBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("1-Client Homepage.aspx");
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            // parse data to the next page
            Session["icNo"] = icNo.Text;
            Session["fullName"] = fullName.Text;
            Session["dob"] = dob.Text;
            Session["gender"] = gender.SelectedItem.Text;
            Session["contactNo"] = contactNo.Text;

            // Redirect to the second page
            Response.Redirect("31-Borrower My Profile 2.aspx");
        }
    }
}