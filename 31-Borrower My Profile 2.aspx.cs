using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.Diagnostics;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string publicKey = Session["publicKey"].ToString();
            
        }

        protected void backBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("3-Borrower My Profile.aspx");
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            try
            {
                string publicKey = Session["publicKey"].ToString();

                //create borrower id
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "select count(*) from Borrower";
                SqlCommand cmd = new SqlCommand(query, con);
                int totalBorrower = Convert.ToInt32(cmd.ExecuteScalar().ToString());
                int borrowerNo = totalBorrower + 1;
                string num = borrowerNo.ToString();
                string borrowerID;

                if (num.Length == 1)
                {
                    borrowerID = "00" + num;
                }
                else if (num.Length == 2)
                {
                    borrowerID = "0" + num;
                }
                else
                {
                    borrowerID = num;
                }

                Debug.WriteLine("=================Page 31====================");
                Debug.WriteLine("BorrowerID:" + "B" + borrowerID);

                // check if is new user
                if (Session["clientID"] == null)
                {
                    // catch data from previous page
                    string icNo = Session["icNo"].ToString();
                    string fullName = Session["fullName"].ToString();
                    string dob = Session["dob"].ToString();
                    string gender = Session["gender"].ToString();
                    string contactNo = Session["contactNo"].ToString();

                    // parse data to the next page
                    Session["icNo"] = icNo;
                    Session["fullName"] = fullName;
                    Session["dob"] = dob;
                    Session["gender"] = gender;
                    Session["contactNo"] = contactNo;
                    Session["publicKey"] = publicKey;

                    Debug.WriteLine("==============Borrower My Profile 2==============");
                    Debug.WriteLine("icNo:" + icNo);
                    Debug.WriteLine("fullName:" + fullName);
                    Debug.WriteLine("dob:" + dob);
                    Debug.WriteLine("gender:" + gender);
                    Debug.WriteLine("contactNo:" + contactNo);
                    Debug.WriteLine("publicKey:" + publicKey);
                }
                
                Session["borrowerID"] = "B" + borrowerID;
                Session["bizName"] = bizName.Text;
                Session["bizRegNo"] = bizRegNo.Text;
                Session["bizAdd"] = bizAdd.Text;
                Session["bizContact"] = bizContact.Text;
                Session["bizIndustry"] = bizIndustry.SelectedItem.Text;
                Session["entityType"] = entityType.SelectedItem.Text;

                Response.Redirect("32-Borrower My Profile 3.aspx");
            }
            catch
            {
                Debug.WriteLine("Unknown Error in passing Borrower Profile 2.");
            }
        }
    }
}